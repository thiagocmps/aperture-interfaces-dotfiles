-- colors/flux.lua

vim.cmd("hi clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "flux"

----------------------------------------------------
-- Palette
----------------------------------------------------

local c = {
	bg = "#00000D",
	bg_alt = "#0F0F1C",
	bg_dark = "#191926",
	bg_popup = "#323232",

	fg = "#FFFFFF",

	green = "#77FF1D",
	lime = "#C4E665",

	pink = "#E65BC0",
	red = "#FF6981",

	blue = "#7889B2",
	cyan = "#BBD7FE",
	lavender = "#C0C7FF",

	orange = "#FED597",

	diff_add = "#252556",
	diff_change = "#4C4C09",
	diff_delete = "#3F000A",
	diff_text = "#66326E",
}

----------------------------------------------------
-- Helper
----------------------------------------------------

local hl = vim.api.nvim_set_hl

local function set(groups)
	for group, opts in pairs(groups) do
		hl(0, group, opts)
	end
end

----------------------------------------------------
-- Highlights
----------------------------------------------------

set({

	------------------------------------------------
	-- Editor
	------------------------------------------------

	Normal = { fg = c.fg, bg = c.bg },
	Cursor = { bg = c.fg },

	CursorLine = { bg = c.bg },
	CursorColumn = { bg = c.bg },

	LineNr = { fg = c.fg, bg = c.bg_dark },
	NonText = { fg = c.fg, bg = c.bg_alt },

	VertSplit = { fg = c.fg, bg = c.bg_dark },

	StatusLine = { fg = c.fg, bg = "#272E1E", italic = true },
	StatusLineNC = { fg = c.fg, bg = "#282835" },

	Folded = { fg = c.fg, bg = c.bg },

	Title = { fg = c.lime, bold = true },

	Visual = { fg = c.red, bg = c.bg_popup },

	MatchParen = {
		fg = c.green,
		bg = c.bg,
		bold = true,
	},

	SpecialKey = {
		fg = c.pink,
		bg = c.bg_alt,
	},

	------------------------------------------------
	-- Popup
	------------------------------------------------

	Pmenu = {
		fg = c.fg,
		bg = c.bg_popup,
	},

	PmenuSel = {
		fg = c.fg,
		bg = c.lime,
	},

	------------------------------------------------
	-- Tabs
	------------------------------------------------

	TabLineFill = {
		fg = "#662A3B",
		bg = "#5E5E5E",
	},

	TabLineSel = {
		fg = "#FFFFD7",
		bold = true,
	},

	------------------------------------------------
	-- Diff
	------------------------------------------------

	DiffAdd = {
		bg = c.diff_add,
	},

	DiffChange = {
		bg = c.diff_change,
	},

	DiffDelete = {
		fg = "#FF0000",
		bg = c.diff_delete,
	},

	DiffText = {
		bg = c.diff_text,
	},

	------------------------------------------------
	-- Syntax
	------------------------------------------------

	Comment = { fg = c.lime },

	Constant = { fg = c.pink },
	Number = { fg = c.pink },

	Identifier = { fg = c.blue },

	Statement = { fg = c.green },
	Keyword = { fg = c.green },

	Function = { fg = c.cyan },

	Type = { fg = c.orange },

	String = { fg = c.red },

	Special = { fg = c.lavender },
	PreProc = { fg = c.lavender },

	pythonBuiltin = {
		fg = c.blue,
	},
})
