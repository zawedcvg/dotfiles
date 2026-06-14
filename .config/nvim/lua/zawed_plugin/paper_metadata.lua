local M = {}

local vault_path = vim.fn.fnamemodify(vim.fn.expand("~/stuff"), ":p"):gsub("/$", "")
local pdf_folder = vault_path .. "/PDFs"

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "paper_metadata" })
end

local function trim(value)
	return (tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalize_space(value)
	return trim(tostring(value or ""):gsub("%s+", " "))
end

local function html_unescape(value)
	value = tostring(value or "")
	local entities = {
		amp = "&",
		lt = "<",
		gt = ">",
		quot = '"',
		apos = "'",
		nbsp = " ",
	}

	value = value:gsub("&#x(%x+);", function(hex)
		return vim.fn.nr2char(tonumber(hex, 16))
	end)
	value = value:gsub("&#(%d+);", function(num)
		return vim.fn.nr2char(tonumber(num, 10))
	end)
	return value:gsub("&([%a]+);", entities)
end

local function url_encode(value)
	return tostring(value or ""):gsub("([^%w%-%._~])", function(char)
		return string.format("%%%02X", string.byte(char))
	end)
end

local function list_slice(items, first, last)
	local result = {}
	last = last or #items
	for index = first, last do
		table.insert(result, items[index])
	end
	return result
end

local function fetch(url)
	if vim.fn.executable("curl") ~= 1 then
		notify("curl is required to fetch paper metadata", vim.log.levels.ERROR)
		return nil
	end

	notify("Fetching metadata: " .. url)
	local cmd = { "curl", "-L", "-fsS", "--max-time", "20", url }
	if vim.system then
		local result = vim.system(cmd, { text = true }):wait()
		if result.code == 0 then
			return result.stdout
		end

		notify(trim(result.stderr) ~= "" and trim(result.stderr) or "Failed to fetch " .. url, vim.log.levels.ERROR)
		return nil
	end

	local output = vim.fn.system(cmd)
	if vim.v.shell_error == 0 then
		return output
	end

	notify("Failed to fetch " .. url, vim.log.levels.ERROR)
end

local function run_command(cmd)
	if vim.system then
		return vim.system(cmd, { text = true }):wait()
	end

	local output = vim.fn.system(cmd)
	return {
		code = vim.v.shell_error,
		stdout = output,
		stderr = output,
	}
end

local function safe_filename(value)
	value = normalize_space(value):gsub('[/%z\1-\31\\:*?"<>|]', "-")
	value = value:gsub("%s+", " "):gsub("^%.+", ""):gsub("%.+$", "")
	if #value > 140 then
		value = value:sub(1, 140):gsub("%s+%S*$", "")
	end
	if value == "" then
		value = "paper"
	end
	return value .. ".pdf"
end

local function vault_relative_path(path)
	local absolute = vim.fn.fnamemodify(path, ":p")
	if absolute:sub(1, #vault_path + 1) == vault_path .. "/" then
		return absolute:sub(#vault_path + 2)
	end
	return absolute
end

local function download_pdf(metadata)
	local pdf_url = metadata.pdf_url or metadata.pdf
	if not pdf_url or pdf_url == "" then
		return
	end

	if vim.fn.executable("curl") ~= 1 then
		notify("curl is required to download PDFs", vim.log.levels.ERROR)
		return
	end

	vim.fn.mkdir(pdf_folder, "p")
	local target = pdf_folder .. "/" .. safe_filename(metadata.title or metadata.arxiv or metadata.doi or "paper")
	metadata.pdf_url = pdf_url
	metadata.pdf = vault_relative_path(target)

	if vim.fn.filereadable(target) == 1 then
		notify("PDF already exists: " .. metadata.pdf)
		return metadata.pdf
	end

	notify("Downloading PDF: " .. metadata.pdf)
	local result = run_command({ "curl", "-L", "-fS", "--max-time", "90", "-o", target, pdf_url })
	if result.code ~= 0 then
		pcall(vim.fn.delete, target)
		notify(trim(result.stderr) ~= "" and trim(result.stderr) or "Failed to download PDF", vim.log.levels.WARN)
		metadata.pdf = pdf_url
		metadata.pdf_url = nil
		return
	end

	notify("Downloaded PDF: " .. metadata.pdf)
	return metadata.pdf
end

local function first(value)
	if type(value) == "table" then
		return value[1]
	end
	return value
end

local function date_year(date_parts)
	local parts = date_parts and date_parts[1]
	if type(parts) == "table" and parts[1] then
		return tostring(parts[1])
	end
end

local function year_from_date(value)
	return tostring(value or ""):match("^(%d%d%d%d)")
end

local function arxiv_id_from_input(input)
	local id = input:match("arxiv%.org/abs/([^%?#/]+)") or input:match("arxiv%.org/pdf/([^%?#/]+)")
	if id then
		return (id:gsub("%.pdf$", ""))
	end

	return input:match("^(%d%d%d%d%.%d+v?%d*)$")
end

local function doi_from_input(input)
	local doi = input:match("doi%.org/(10%.%S+)") or input:match("(10%.%d%d%d%d+/%S+)")
	if doi then
		return (doi:gsub("[%)%].,;]+$", ""))
	end
end

local function parse_arxiv(input)
	local arxiv_id = arxiv_id_from_input(input)
	if not arxiv_id then
		return nil
	end

	local xml = fetch("https://export.arxiv.org/api/query?id_list=" .. url_encode(arxiv_id))
	if not xml then
		return nil
	end

	local entry = xml:match("<entry>(.-)</entry>")
	if not entry then
		notify("No arXiv metadata found for " .. arxiv_id, vim.log.levels.WARN)
		return nil
	end

	local authors = {}
	for author in entry:gmatch("<author>%s*<name>(.-)</name>%s*</author>") do
		table.insert(authors, normalize_space(html_unescape(author)))
	end

	local published = normalize_space(entry:match("<published>(.-)</published>") or "")
	local doi = normalize_space(html_unescape(entry:match("<arxiv:doi[^>]*>(.-)</arxiv:doi>") or ""))
	local journal = normalize_space(html_unescape(entry:match("<arxiv:journal_ref[^>]*>(.-)</arxiv:journal_ref>") or ""))

	return {
		title = normalize_space(html_unescape(entry:match("<title>(.-)</title>") or "")),
		authors = authors,
		year = year_from_date(published),
		published = published ~= "" and published or nil,
		doi = doi ~= "" and doi or nil,
		arxiv = arxiv_id,
		url = "https://arxiv.org/abs/" .. arxiv_id,
		pdf = "https://arxiv.org/pdf/" .. arxiv_id,
		pdf_url = "https://arxiv.org/pdf/" .. arxiv_id,
		journal = journal ~= "" and journal or nil,
	}
end

local function parse_crossref(input)
	local doi = doi_from_input(input)
	if not doi then
		return nil
	end

	local body = fetch("https://api.crossref.org/works/" .. url_encode(doi))
	if not body then
		return nil
	end

	local ok, decoded = pcall(vim.fn.json_decode, body)
	if not ok or type(decoded) ~= "table" or type(decoded.message) ~= "table" then
		notify("Could not parse Crossref metadata", vim.log.levels.WARN)
		return nil
	end

	local work = decoded.message
	local authors = {}
	for _, author in ipairs(work.author or {}) do
		local name = normalize_space(table.concat(vim.tbl_filter(function(part)
			return part and part ~= ""
		end, { author.given, author.family }), " "))
		if name ~= "" then
			table.insert(authors, name)
		end
	end

	local year = date_year(work["published-print"] and work["published-print"]["date-parts"])
		or date_year(work["published-online"] and work["published-online"]["date-parts"])
		or date_year(work.issued and work.issued["date-parts"])

	return {
		title = normalize_space(first(work.title) or ""),
		authors = authors,
		year = year,
		doi = work.DOI or doi,
		url = work.URL or input,
		journal = normalize_space(first(work["container-title"]) or ""),
	}
end

local function meta_attrs(tag)
	local attrs = {}
	for key, value in tag:gmatch('([%w_:%-]+)%s*=%s*"(.-)"') do
		attrs[key:lower()] = html_unescape(value)
	end
	for key, value in tag:gmatch("([%w_:%-]+)%s*=%s*'(.-)'") do
		attrs[key:lower()] = html_unescape(value)
	end
	return attrs
end

local function parse_html(input)
	if not input:match("^https?://") then
		return nil
	end

	local html = fetch(input)
	if not html then
		return nil
	end

	local metadata = { url = input, authors = {} }
	for tag in html:gmatch("<meta%s+[^>]->") do
		local attrs = meta_attrs(tag)
		local name = (attrs.name or attrs.property or ""):lower()
		local content = normalize_space(attrs.content or "")

		if content ~= "" then
			if name == "citation_title" then
				metadata.title = content
			elseif name == "citation_author" then
				table.insert(metadata.authors, content)
			elseif name == "citation_publication_date" or name == "citation_date" then
				metadata.published = content
				metadata.year = metadata.year or year_from_date(content)
			elseif name == "citation_doi" then
				metadata.doi = content
			elseif name == "citation_arxiv_id" then
				metadata.arxiv = content
			elseif name == "citation_pdf_url" then
				metadata.pdf = content
			elseif name == "citation_journal_title" or name == "citation_conference_title" then
				metadata.journal = content
			elseif not metadata.title and (name == "og:title" or name == "twitter:title") then
				metadata.title = content
			end
		end
	end

	if not metadata.title then
		metadata.title = normalize_space(html_unescape(html:match("<title[^>]*>(.-)</title>") or ""))
	end

	if metadata.doi then
		local crossref = parse_crossref(metadata.doi)
		if crossref and crossref.title and crossref.title ~= "" then
			metadata = vim.tbl_extend("force", metadata, crossref)
		end
	end

	if not metadata.title or metadata.title == "" then
		notify("No metadata found at URL", vim.log.levels.WARN)
		return nil
	end

	return metadata
end

local function parse_pdf_url(input)
	if not input:match("^https?://") or not input:lower():match("%.pdf[%?#]?") then
		return nil
	end

	local filename = input:match("/([^/%?#]+)%.pdf") or "paper"
	local title = filename:gsub("%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end):gsub("[_-]+", " ")

	return {
		title = normalize_space(title),
		url = input,
		pdf = input,
		pdf_url = input,
	}
end

local function metadata_from_input(input)
	local arxiv = parse_arxiv(input)
	if arxiv then
		return arxiv
	end

	local direct_pdf = parse_pdf_url(input)
	if direct_pdf then
		return direct_pdf
	end

	if input:match("^https?://") then
		return parse_html(input) or parse_crossref(input)
	end

	return parse_crossref(input)
end

local function frontmatter_bounds()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	if lines[1] ~= "---" then
		return nil, nil, lines
	end

	for index = 2, #lines do
		if lines[index] == "---" then
			return 1, index, lines
		end
	end

	return nil, nil, lines
end

local function read_list(lines, key)
	local values = {}
	for index, line in ipairs(lines) do
		local inline = line:match("^" .. key .. ":%s*%[(.-)%]%s*$")
		if inline then
			for value in inline:gmatch("[^,]+") do
				value = trim(value:gsub('^"', ""):gsub('"$', ""):gsub("^'", ""):gsub("'$", ""))
				if value ~= "" then
					table.insert(values, value)
				end
			end
			return values
		end

		if line:match("^" .. key .. ":%s*$") then
			for inner = index + 1, #lines do
				local value = lines[inner]:match("^%s*%-%s+(.+)%s*$")
				if value then
					table.insert(values, trim(value:gsub('^"', ""):gsub('"$', "")))
				elseif not lines[inner]:match("^%s") then
					break
				end
			end
			return values
		end
	end

	return values
end

local function read_scalar(lines, key)
	for _, line in ipairs(lines) do
		local value = line:match("^" .. key .. ":%s*(.+)%s*$")
		if value then
			value = trim(value:gsub("%s+#.*$", ""))
			if value:sub(1, 1) == '"' and value:sub(-1) == '"' then
				value = value:sub(2, -2):gsub('\\"', '"'):gsub("\\\\", "\\")
			elseif value:sub(1, 1) == "'" and value:sub(-1) == "'" then
				value = value:sub(2, -2):gsub("''", "'")
			end
			return value ~= "" and value or nil
		end
	end
end

local function remove_key(lines, key)
	local result = {}
	local index = 1
	while index <= #lines do
		if lines[index]:match("^" .. key .. ":") then
			index = index + 1
			while index <= #lines and lines[index]:match("^%s+") do
				index = index + 1
			end
		else
			table.insert(result, lines[index])
			index = index + 1
		end
	end

	return result
end

local function yaml_scalar(value)
	value = tostring(value or "")
	value = value:gsub("\\", "\\\\"):gsub('"', '\\"')
	return '"' .. value .. '"'
end

local function append_key(lines, key, value)
	if value == nil or value == "" then
		return
	end

	if type(value) == "table" then
		if #value == 0 then
			return
		end

		table.insert(lines, key .. ":")
		for _, item in ipairs(value) do
			if item and item ~= "" then
				table.insert(lines, "  - " .. yaml_scalar(item))
			end
		end
		return
	end

	table.insert(lines, key .. ": " .. yaml_scalar(value))
end

local function merge_tags(existing)
	local seen = {}
	local tags = {}
	for _, tag in ipairs(existing or {}) do
		if tag ~= "" and not seen[tag] then
			seen[tag] = true
			table.insert(tags, tag)
		end
	end
	if not seen.paper then
		table.insert(tags, "paper")
	end
	return tags
end

local function apply_frontmatter(metadata)
	local start_line, end_line, buffer_lines = frontmatter_bounds()
	local frontmatter = {}
	local body_start = 1

	if start_line then
		frontmatter = list_slice(buffer_lines, start_line + 1, end_line - 1)
		body_start = end_line + 1
	end

	local tags = merge_tags(read_list(frontmatter, "tags"))
	local keys = { "title", "authors", "year", "published", "doi", "arxiv", "url", "pdf", "pdf_url", "journal", "tags" }
	for _, key in ipairs(keys) do
		frontmatter = remove_key(frontmatter, key)
	end

	append_key(frontmatter, "title", metadata.title)
	append_key(frontmatter, "authors", metadata.authors)
	append_key(frontmatter, "year", metadata.year)
	append_key(frontmatter, "published", metadata.published)
	append_key(frontmatter, "doi", metadata.doi)
	append_key(frontmatter, "arxiv", metadata.arxiv)
	append_key(frontmatter, "url", metadata.url)
	append_key(frontmatter, "pdf", metadata.pdf)
	append_key(frontmatter, "pdf_url", metadata.pdf_url)
	append_key(frontmatter, "journal", metadata.journal)
	append_key(frontmatter, "tags", tags)

	local replacement = { "---" }
	vim.list_extend(replacement, frontmatter)
	table.insert(replacement, "---")

	if not start_line then
		table.insert(replacement, "")
		vim.list_extend(replacement, buffer_lines)
		vim.api.nvim_buf_set_lines(0, 0, -1, false, replacement)
		return
	end

	local body = list_slice(buffer_lines, body_start)
	vim.list_extend(replacement, body)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, replacement)
end

local function url_under_cursor()
	local cfile = vim.fn.expand("<cfile>")
	if cfile:match("^https?://") or arxiv_id_from_input(cfile) or doi_from_input(cfile) then
		return cfile
	end

	local line = vim.api.nvim_get_current_line()
	return line:match("https?://%S+") or doi_from_input(line) or arxiv_id_from_input(line)
end

function M.populate_from_url(input)
	input = trim(input)
	if input == "" then
		vim.ui.input({ prompt = "Paper URL/DOI/arXiv ID: ", default = url_under_cursor() or "" }, function(answer)
			if answer and trim(answer) ~= "" then
				M.populate_from_url(answer)
			end
		end)
		return
	end

	local metadata = metadata_from_input(input)
	if not metadata then
		return
	end

	download_pdf(metadata)
	apply_frontmatter(metadata)
	notify("Updated paper frontmatter: " .. (metadata.title or input))
end

function M.open_metadata_pdf()
	local start_line, end_line, buffer_lines = frontmatter_bounds()
	if not start_line then
		notify("No frontmatter found in current note", vim.log.levels.WARN)
		return
	end

	local frontmatter = list_slice(buffer_lines, start_line + 1, end_line - 1)
	local pdf = read_scalar(frontmatter, "pdf")
	if not pdf then
		notify("No pdf field found in frontmatter", vim.log.levels.WARN)
		return
	end

	require("zawed_plugin.research_pdf").open_pdf_from_note(pdf)
end

function M.setup()
	vim.api.nvim_create_user_command("PaperMetadata", function(opts)
		M.populate_from_url(opts.args)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("PaperOpenPdf", function()
		M.open_metadata_pdf()
	end, {})

	vim.keymap.set("n", "<leader>pm", function()
		M.populate_from_url("")
	end, { desc = "Populate paper metadata" })

	vim.keymap.set("n", "<leader>pp", M.open_metadata_pdf, { desc = "Open metadata PDF" })
end

return M
