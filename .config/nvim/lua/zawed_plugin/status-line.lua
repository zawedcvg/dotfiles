local gl = require("galaxyline")
local gls = gl.section
local condition = require("galaxyline.condition")
local navic = require("nvim-navic")


gl.short_line_list = { " " }

local colors = {
    white = "#abb2bf",
    darker_black = "#1b1f27",
    black = "#1e222a", --  nvim bg
    black2 = "#252931",
    one_bg = "#282c34", -- real bg of onedark
    one_bg2 = "#353b45",
    one_bg3 = "#30343c",
    grey = "#42464e",
    grey_fg = "#565c64",
    grey_fg2 = "#6f737b",
    light_grey = "#6f737b",
    red = "#d47d85",
    baby_pink = "#DE8C92",
    pink = "#ff75a0",
    line = "#2a2e36", -- for lines like vertsplit
    green = "#A3BE8C",
    vibrant_green = "#7eca9c",
    nord_blue = "#81A1C1",
    blue = "#61afef",
    yellow = "#e7c787",
    sun = "#EBCB8B",
    purple = "#b4bbc8",
    dark_purple = "#c882e7",
    teal = "#519ABA",
    orange = "#fca2aa",
    cyan = "#a3b8ef",
    statusline_bg = "9ea7b7",
    lightbg = "#282E2C",
    lightbg2 = "#262a32"
}

gls.left[1] = {
    FirstElement = {
        provider = function() return '▋' end,
        highlight = { colors.green, colors.green }
    },
}

gls.left[2] = {
    statusIcon = {
        provider = function()
            return "  "
        end,
        highlight = { colors.lightbg, colors.green },
        separator = " ",
        separator_highlight = { colors.green, colors.lightbg }
    }
}

gls.left[3] = {
    FileIcon = {
        provider = "FileIcon",
        condition = condition.buffer_not_empty,
        highlight = { colors.white, colors.lightbg }
    }
}

gls.left[4] = {
    FileName = {
        provider = { "FileName" },
        condition = condition.buffer_not_empty,
        highlight = { colors.white, colors.lightbg },
        separator = " ",
        separator_highlight = { colors.lightbg, colors.lightbg }
    }
}

gls.left[5] = {
    current_dir = {
        provider = function()
            local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return " 󰉖 " .. dir_name .. " "
        end,
        highlight = { colors.white, colors.lightbg },
        separator = " ",
        separator_highlight = { colors.lightbg, colors.statusline_bg }
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
        highlight = { colors.white, colors.statusline_bg }
    }
}

gls.left[7] = {
    DiffModified = {
        provider = "DiffModified",
        condition = checkwidth,
        icon = "   ",
        highlight = { colors.grey_fg2, colors.statusline_bg }
    }
}

gls.left[8] = {
    DiffRemove = {
        provider = "DiffRemove",
        condition = checkwidth,
        icon = "  ",
        highlight = { colors.grey_fg2, colors.statusline_bg }
    }
}

--gls.left[9] = {
    --DiagnosticError = {
        --provider = "DiagnosticError",
        --icon = "  ",
        --highlight = { colors.red, colors.statusline_bg }
    --}
--}
gls.left[10] = {
    Space = {
        provider = function() return ' ' end,
        highlight = { colors.grey_fg2, colors.statusline_bg }
    }
}


--gls.left[11] = {
    --DiagnosticWarn = {
        --provider = "DiagnosticWarn",
        --icon = "  ",
        --highlight = { colors.green, colors.statusline_bg }
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
        highlight = { colors.grey_fg2, colors.statusline_bg }
    }
}

gls.right[3] = {
    GitIcon = {
        provider = function()
            return "󰊢 "
        end,
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = { colors.white, colors.lightbg },
        separator = "",
        separator_highlight = { colors.lightbg, colors.statusline_bg }
    }
}

gls.right[4] = {
    GitBranch = {
        provider = "GitBranch",
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = { colors.white, colors.statusline_bg }
    }
}

gls.right[5] = {
    viMode_icon = {
        provider = function()
            return " "
        end,
        highlight = { colors.lightbg, colors.red },
        separator = " ",
        separator_highlight = { colors.red, colors.lightbg }
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
        highlight = { colors.red, colors.lightbg }
    }
}

gls.right[7] = {
    some_icon = {
        provider = function()
            return " "
        end,
        separator = "",
        separator_highlight = { colors.green, colors.lightbg },
        highlight = { colors.lightbg, colors.green }
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
        highlight = { colors.green, colors.lightbg }
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
