local vscode = require('vscode')

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down but keep cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up but keep cursor centered" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Nav search terms, but keep cursor at the middle" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Nav search terms, but keep cursor at the middle" })


vim.keymap.set("n", "J", "mzJ`z", { desc = "Same as regular J but keep cursor at same place" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>e", "\"_d", { desc = "Delete to void register (without copy)" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable orig dinding" })

vim.keymap.set("n", "<leader>rr", [[:%s/<C-r><C-w>/<C-r><C-w>]], { desc = "Quick replace" })

-- fix quick fix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set('n', "<leader>,", function()
  vscode.action("editor.action.formatDocument")
end)

vim.keymap.set('v', "<leader>,", function()
  vscode.action('editor.action.formatSelection')
end)

vim.keymap.set('n', "<leader>ff", function()
  vscode.action("workbench.action.quickOpen")
end)

vim.keymap.set('n', "<leader>s", function()
  vscode.action("workbench.action.quickOpen")
end)

vim.keymap.set('n', "<leader>fg", function()
  vscode.action('workbench.action.findInFiles', {
    args = {
      query = vim.fn.input("Grep > "),
      isRegex = false,
      isCaseSensitive = false,
      focusResults = true,
      triggerSearch = true,
      contextLines = 4,
      --"matchWholeWord": true,
      --"replace": "that's $1 swell",
      --"filesToInclude": "",
      --"filesToExclude": "",
      --"showIncludesExcludes": false,
      --"useExcludeSettingsAndIgnoreFiles": true,
    },
  })
end)

vim.keymap.set('n', '<leader>gd', function()
  vscode.action('workbench.view.explorer')
end)

-- --- Telesckope ---
--local telebuiltin = require('telescope.builtin')
--vim.keymap.set(
--  'n', '<leader>fr',
--  function() telebuiltin.lsp_references({ initial_mode = 'normal' }) end,
--  { desc = 'Telescope lsp_references' }
--)
--vim.keymap.set(
--  'n', '<leader>tlf',
--  function() telebuiltin.diagnostics({ initial_mode = 'normal', bufnr = 0 }) end,
--  { desc = 'Teleskope current buffer diagnostics' }
--)
--vim.keymap.set(
--  'n', '<leader>tlg',
--  function() telebuiltin.diagnostics({ initial_mode = 'normal' }) end,
--  { desc = 'Telescope project diagnostics'  }
--)
--


--local harpoon = require("harpoon")
--vim.keymap.set("n", "<leader>n", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
--vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = 'Harpoon add to list' })
---- Toggle previous & next buffers stored within Harpoon list
--vim.keymap.set("n", "<leader>-", function() harpoon:list():prev() end)
--vim.keymap.set("n", "<leader>=", function() harpoon:list():next() end)
----vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
----vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
----vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
----vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
--
---- ---UndoTree--- --
--vim.keymap.set('n', '<leader>U', vim.cmd.UndotreeToggle)
--
---- ---Neogit--- --
--vim.keymap.set('n', '<leader>gs', vim.cmd.Neogit)



-- --- Trouble ---
--vim.keymap.set("n", "]t", function()
--  require("trouble").next({ skip_groups = true, jump = true });
--end)
--
--vim.keymap.set("n", "[t", function()
--  require("trouble").prev({ skip_groups = true, jump = true });
--end)
