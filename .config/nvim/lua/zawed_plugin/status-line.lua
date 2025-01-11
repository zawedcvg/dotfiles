local gl = require("galaxyline")
local gls = gl.section
local condition = require("galaxyline.condition")
local navic = require("nvim-navic")


gl.short_line_list = { " " }

local mocha = require("catppuccin.palettes").get_palette "mocha"
local latte = require("catppuccin.palettes").get_palette "latte"
local frappe = require("catppuccin.palettes").get_palette "frappe"

local ICON = '📡'

-- Returns a statusline-compatible string
local function statusline()
    -- Attempt to load the distant.nvim plugin
    local ok, plugin = pcall(require, 'distant')

    -- Check the following to see if we are in a remote buffer
    --
    -- 1. Can the plugin be found?
    -- 2. Is the plugin initialized?
    -- 3. Does the buffer have remote data associated?
    --
    -- If the answer to any of these questions is no, we return
    -- an empty string to avoid putting anything in our statusline
    if not ok or not plugin:is_initialized() or not plugin.buf.has_data() then
        return ''
    end

    -- At this point, we know that we have a remote buffer,
    -- and we want to look up what server is represented,
    -- which we do by retrieving a destination table that
    -- contains a host string we can include alongside
    -- a custom emoji
    local destination = assert(plugin:client_destination(plugin.buf.client_id()))
    return ('%s %s'):format(ICON, destination.host)
end

gls.left[1] = {
    FirstElement = {
        provider = function() return '▋' end,
        highlight = { mocha.green, mocha.green }
    },
}

gls.left[2] = {
    statusIcon = {
        --provider = function()
            --return "  "
        --end,
        provider = statusline,
        highlight = { latte.text, mocha.green },
        separator = " ",
        separator_highlight = { mocha.green, mocha.white }
    }
}

gls.left[3] = {
    FileIcon = {
        provider = "FileIcon",
        condition = condition.buffer_not_empty,
        highlight = { mocha.white, mocha.mantle }
    }
}

gls.left[4] = {
    FileName = {
        provider = { "FileName" },
        condition = condition.buffer_not_empty,
        highlight = { mocha.white, mocha.mantle },
        separator = " ",
        separator_highlight = { mocha.mantle, mocha.mantle }
    }
}

gls.left[5] = {
    current_dir = {
        provider = function()
            local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return " 󰉖 " .. dir_name .. " "
        end,
        highlight = { mocha.white, mocha.mantle },
        separator = " ",
        --separator = " ",
        separator_highlight = { mocha.mantle, mocha.white }
        --separator_highlight = { mocha.mantle, mocha.mantle }
    }
}

local checkwidth = function()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 30 then
        return true
    end
    return false
end

gls.left[6] = {
    DiffAdd = {
        provider = "DiffAdd",
        condition = checkwidth,
        icon = "  ",
        --highlight = { mocha.white, frappe.base }
        highlight = { frappe.grey_fg2, mocha.statusline_bg }
    }
}

gls.left[7] = {
    DiffModified = {
        provider = "DiffModified",
        condition = checkwidth,
        icon = "   ",
        highlight = { frappe.grey_fg2, mocha.statusline_bg }
    }
}

gls.left[8] = {
    DiffRemove = {
        provider = "DiffRemove",
        condition = checkwidth,
        icon = "  ",
        highlight = { frappe.grey_fg2, mocha.statusline_bg }
    }
}

--gls.left[9] = {
    --DiagnosticError = {
        --provider = "DiagnosticError",
        --icon = "  ",
        --highlight = { mocha.red, mocha.statusline_bg }
    --}
--}
gls.left[10] = {
    Space = {
        provider = function() return ' ' end,
        highlight = { frappe.grey_fg2, frappe.statusline_bg }
    }
}


--gls.left[11] = {
    --DiagnosticWarn = {
        --provider = "DiagnosticWarn",
        --icon = "  ",
        --highlight = { mocha.green, mocha.statusline_bg }
    --}
--}

gls.right[1] = {
    nvimNavic = {
        provider = function()
            return navic.get_location()
        end,
        condition = function()
            return navic.is_available()
        end
    }
}


gls.right[2] = {
    Space = {
        provider = function() return ' ' end,
        highlight = { frappe.grey_fg2, frappe.statusline_bg }
    }
}

gls.right[3] = {
    GitIcon = {
        provider = function()
            return "󰊢 "
        end,
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = { frappe.grey_fg2, mocha.statusline_bg },
        separator = "",
        separator_highlight = { frappe.statusline_bg, frappe.statusline_bg }
    }
}

gls.right[4] = {
    GitBranch = {
        provider = "GitBranch",
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        hightlight = { mocha.mantle, mocha.white }
    }
}

gls.right[5] = {
    viMode_icon = {
        provider = function()
            return " "
        end,
        highlight = { latte.text, mocha.red },
        separator = " ",
        separator_highlight = { mocha.red, mocha.white }
    }
}

gls.right[6] = {
    ViMode = {
        provider = function()
            local alias = {
                n = "Normal",
                i = "Insert",
                c = "Command",
                V = "Visual",
                [""] = "Visual",
                v = "Visual",
                R = "Replace"
            }
            local current_Mode = alias[vim.fn.mode()]

            if current_Mode == nil then
                return "  Terminal "
            else
                return "  " .. current_Mode .. " "
            end
        end,
        highlight = { mocha.red, mocha.white }
    }
}

gls.right[7] = {
    some_icon = {
        provider = function()
            return " "
        end,
        separator = "",
        separator_highlight = { mocha.green, mocha.white },
        highlight = { latte.text, mocha.green }
    }
}

gls.right[8] = {
    line_percentage = {
        provider = function()
            local current_line = vim.fn.line(".")
            local total_line = vim.fn.line("$")

            if current_line == 1 then
                return "  Top "
            elseif current_line == vim.fn.line("$") then
                return "  Bot "
            end
            local result, _ = math.modf((current_line / total_line) * 100)
            return "  " .. result .. "% "
        end,
        highlight = { mocha.green, latte.white }
    }
}
--local function status_line()
    ----local mode = "%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}"
    --local buf_nr = "%n "
    --local file_type = "%y"
    --local right_align = "%="
    --local symbol = ""

    ----if navic.is_available() then
        ----symbol = navic.get_location()
    ----end

    ----vim.schedule(function()
      ----symbol = navic.get_location()
    ----end)

    --return string.format(
        --"%s%s%s",
        --right_align,
        --buf_nr,
        --file_type
    --)
--end

-- vim.opt.statusline = status_line()
--vim.opt.winbar = status_line()
