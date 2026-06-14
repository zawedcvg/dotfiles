local M = {}

local vault_path = vim.fn.fnamemodify(vim.fn.expand("~/stuff"), ":p"):gsub("/$", "")
local last_note_path = vim.fn.stdpath("cache") .. "/sioyek-last-note.txt"
local server_path = vim.fn.stdpath("cache") .. "/sioyek-nvim-server"
local log_path = vim.fn.stdpath("state") .. "/research_pdf.log"
local insert_target

local function starts_with(value, prefix)
	return value:sub(1, #prefix) == prefix
end

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "research_pdf" })
end

local function log(message)
	local line =
		string.format("%s [research_pdf] %s", os.date("%Y-%m-%d %H:%M:%S"), tostring(message):gsub("\n", "\\n"))
	pcall(vim.fn.writefile, { line }, log_path, "a")
end

local function inspect_value(value)
	return (vim.inspect(value):gsub("\n", " "))
end

local function trim(value)
	return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function strip_quotes(value)
	value = tostring(value or "")
	return (value:gsub('^"', ""):gsub('"$', ""):gsub("^'", ""):gsub("'$", ""))
end

local function url_decode(value)
	value = value:gsub("+", " ")
	return (value:gsub("%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end))
end

local function normalize_path(path)
	return vim.fn.fnamemodify(vim.fn.expand(path), ":p")
end

local function current_file_dir()
	local current = vim.api.nvim_buf_get_name(0)
	if current == "" then
		return vim.uv.cwd()
	end

	return vim.fn.fnamemodify(current, ":p:h")
end

local function is_absolute(path)
	return starts_with(path, "/") or path:match("^%a:[/\\]") ~= nil
end

local function clean_number(value)
	value = strip_quotes(trim(tostring(value or "")))
	if value:match("^-?%d+%.?%d*$") or value:match("^-?%.%d+$") then
		return value
	end
end

local function clean_word(value)
	value = tostring(value or "")
	if value:match("^[%w_-]+$") then
		return value
	end
end

local function resolve_pdf_path(path)
	path = strip_quotes(url_decode(trim(path)))

	if starts_with(path, "~") or is_absolute(path) then
		return normalize_path(path)
	end

	local vault_candidate = normalize_path(vault_path .. "/" .. path)
	if vim.fn.filereadable(vault_candidate) == 1 then
		return vault_candidate
	end

	local current = vim.api.nvim_buf_get_name(0)
	if current ~= "" then
		current = normalize_path(current)
		if not starts_with(current, vault_path .. "/") then
			local local_candidate = normalize_path(current_file_dir() .. "/" .. path)
			if vim.fn.filereadable(local_candidate) == 1 then
				return local_candidate
			end
		end
	end

	return vault_candidate
end

local function split_target(target)
	target = trim(target)
	target = target:gsub("^<", ""):gsub(">$", "")
	target = target:match("^[^|]+") or target

	local path, fragment = target:match("^([^#]+)#(.+)$")
	path = strip_quotes(path or target)

	local page
	local xloc
	local yloc
	if fragment then
		page = fragment:match("[?&]?page=(%d+)")
		xloc = clean_number(fragment:match("[?&]?xloc=([^&]+)") or fragment:match("[?&]?x=([^&]+)"))
		yloc = clean_number(fragment:match("[?&]?yloc=([^&]+)") or fragment:match("[?&]?y=([^&]+)"))
	end

	return {
		path = path,
		page = page,
		xloc = xloc,
		yloc = yloc,
	}
end

--NOTE: Refactor this, this is a bad way
local function link_under_cursor()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1

	for _, quote in ipairs({ '"', "'" }) do
		local init = 1
		while true do
			local pattern = quote .. "([^" .. quote .. "]-%.pdf[^" .. quote .. "]*)" .. quote
			local start_pos, end_pos, path = line:find(pattern, init)
			if not start_pos then
				break
			end

			if start_pos <= col and col <= end_pos then
				return path
			end

			init = end_pos + 1
		end
	end

	local yaml_pdf = line:match("^%s*pdf:%s*(.+%.pdf.*)$")
	if yaml_pdf then
		yaml_pdf = trim(yaml_pdf:gsub("%s+#.*$", ""))
		local path_start = line:find(yaml_pdf, 1, true) or 1
		if path_start <= col and col <= #line + 1 then
			return yaml_pdf
		end
	end

	local init = 1
	while true do
		local start_pos, end_pos = line:find("%[%[[^%]]+%]%]", init)
		if not start_pos then
			break
		end

		if start_pos <= col and col <= end_pos then
			return line:sub(start_pos + 2, end_pos - 2)
		end

		init = end_pos + 1
	end

	init = 1
	while true do
		local start_pos, end_pos, target = line:find("%[[^%]]-%]%(([^%)]+)%)", init)
		if not start_pos then
			break
		end

		if start_pos <= col and col <= end_pos then
			return target
		end

		init = end_pos + 1
	end

	local cfile = vim.fn.expand("<cfile>")
	if cfile:lower():find("%.pdf") then
		return cfile
	end
end

local function vault_relative_path(path)
	local absolute = normalize_path(path)
	if starts_with(absolute, vault_path .. "/") then
		return absolute:sub(#vault_path + 2)
	end

	return absolute
end

local function pdf_title(path)
	return vim.fn.fnamemodify(path, ":t:r")
end

local function markdown_quote_lines(text)
	text = (text or ""):gsub("\r\n", "\n"):gsub("\r", "\n")
	local lines = vim.split(text, "\n", { plain = true })

	if #lines == 0 then
		return { "> " }
	end

	for index, line in ipairs(lines) do
		lines[index] = "> " .. line
	end

	return lines
end

local function list_slice(items, first)
	local result = {}
	for index = first, #items do
		table.insert(result, items[index])
	end
	return result
end

local function remember_insert_target()
	insert_target = {
		bufnr = vim.api.nvim_get_current_buf(),
		winid = vim.api.nvim_get_current_win(),
	}
end

local function put_lines_at_target(lines)
	if insert_target and vim.api.nvim_win_is_valid(insert_target.winid) then
		local current_win = vim.api.nvim_get_current_win()
		vim.api.nvim_set_current_win(insert_target.winid)
		vim.api.nvim_put(lines, "l", true, true)
		if vim.api.nvim_win_is_valid(current_win) then
			vim.api.nvim_set_current_win(current_win)
		end
		return
	end

	if insert_target and vim.api.nvim_buf_is_valid(insert_target.bufnr) then
		vim.api.nvim_buf_set_lines(insert_target.bufnr, -1, -1, false, lines)
		return
	end

	vim.api.nvim_put(lines, "l", true, true)
end

local function publish_nvim_server()
	local servername = vim.v.servername
	if servername == "" then
		local ok, started = pcall(vim.fn.serverstart)
		if ok and started and started ~= "" then
			servername = started
		end
	end

	if servername == "" then
		notify("Could not start Neovim server for Sioyek callbacks", vim.log.levels.WARN)
		return
	end

	vim.fn.writefile({ servername }, server_path)
end

function M.open_pdf_link(link)
	local target = split_target(link)
	if not target.path:lower():find("%.pdf$") then
		notify("Not a PDF link: " .. link, vim.log.levels.WARN)
		return
	end

	local pdf_path = resolve_pdf_path(target.path)
	local cmd = { "sioyek", "--reuse-window" }
	if target.page then
		table.insert(cmd, "--page")
		table.insert(cmd, target.page)
	end
	if target.xloc then
		table.insert(cmd, "--xloc")
		table.insert(cmd, target.xloc)
	end
	if target.yloc then
		table.insert(cmd, "--yloc")
		table.insert(cmd, target.yloc)
	end
	table.insert(cmd, pdf_path)

	local job = vim.fn.jobstart(cmd, { detach = true })
	if job <= 0 then
		notify("Failed to start sioyek", vim.log.levels.ERROR)
	end
end

function M.open_pdf_under_cursor()
	remember_insert_target()

	local link = link_under_cursor()
	if not link then
		notify("No PDF link under cursor", vim.log.levels.WARN)
		return
	end

	M.open_pdf_link(link)
end

function M.open_pdf_from_note(link)
	remember_insert_target()
	M.open_pdf_link(link)
end

function M.insert_pdf_annotation(data)
	log("insert_pdf_annotation received data=" .. inspect_value(data))

	local page = tonumber(data.page) or 1
	local color = data.color or "yellow"
	local kind = data.kind or "quote"
	local pdf_path = strip_quotes(data.file or data.path or "")
	local xloc = clean_number(data.xloc or data.x)
	local yloc = clean_number(data.yloc or data.y)

	log(
		string.format(
			"insert_pdf_annotation resolved page=%s raw_page=%s color=%s raw_color=%s kind=%s raw_kind=%s pdf_path=%s raw_file=%s raw_path=%s xloc=%s yloc=%s",
			inspect_value(page),
			inspect_value(data.page),
			inspect_value(color),
			inspect_value(data.color),
			inspect_value(kind),
			inspect_value(data.kind),
			inspect_value(pdf_path),
			inspect_value(data.file),
			inspect_value(data.path),
			inspect_value(xloc),
			inspect_value(yloc)
		)
	)

	if pdf_path == "" then
		notify("Missing PDF path for annotation", vim.log.levels.ERROR)
		return false
	end

	local rel_path = vault_relative_path(pdf_path)
	local params = { string.format("page=%d", page) }
	if xloc then
		table.insert(params, "xloc=" .. xloc)
	end
	if yloc then
		table.insert(params, "yloc=" .. yloc)
	end
	table.insert(params, "color=" .. (clean_word(color) or "yellow"))
	local link = string.format("[[%s#%s|%s, p. %d]]", rel_path, table.concat(params, "&"), pdf_title(pdf_path), page)
	local lines = { string.format("> [!%s] %s", kind, link) }
	vim.list_extend(lines, markdown_quote_lines(data.text or ""))
	table.insert(lines, "")

	put_lines_at_target(lines)
	return true
end

local function read_last_sioyek_note(path)
	path = path or last_note_path
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok or #lines < 5 then
		notify("No usable Sioyek note found at " .. path, vim.log.levels.WARN)
		return nil
	end

	local text_start = 6
	for index, line in ipairs(lines) do
		if line == "---text---" then
			text_start = index + 1
			break
		end
	end

	log(
		string.format(
			"read_last_sioyek_note path=%s line_count=%d raw_kind=%s raw_file=%s raw_page=%s raw_color=%s raw_text_start=%s",
			inspect_value(path),
			#lines,
			inspect_value(lines[1]),
			inspect_value(lines[2]),
			inspect_value(lines[3]),
			inspect_value(lines[4]),
			inspect_value(lines[text_start])
		)
	)

	return {
		kind = lines[1] ~= "" and lines[1] or "quote",
		file = lines[2],
		page = tonumber(lines[3]) or 1,
		color = lines[4] ~= "" and lines[4] or "yellow",
		xloc = lines[5],
		yloc = lines[6],
		text = strip_quotes(table.concat(list_slice(lines, text_start), "\n")),
	}
end

function M.insert_last_sioyek_note(path)
	local data = read_last_sioyek_note(path)
	if not data then
		return false
	end

	return M.insert_pdf_annotation(data)
end

function M.setup()
	publish_nvim_server()

	vim.api.nvim_create_user_command("PdfOpen", function(opts)
		remember_insert_target()

		if opts.args ~= "" then
			M.open_pdf_link(opts.args)
		else
			M.open_pdf_under_cursor()
		end
	end, { nargs = "?", complete = "file" })

	vim.api.nvim_create_user_command("PdfInsertLastSioyekNote", function()
		M.insert_last_sioyek_note()
	end, {})

	vim.keymap.set("n", "<leader>po", M.open_pdf_under_cursor, { desc = "Open PDF in Sioyek" })
	vim.keymap.set("n", "<leader>pi", M.insert_last_sioyek_note, { desc = "Insert Sioyek note" })
end

return M
