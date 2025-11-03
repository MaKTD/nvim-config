-- This file is automatically loaded by lazyvim.config.init

-- Essential --

vim.keymap.set("n", "Up", "<nop>")
vim.keymap.set("n", "Down", "<nop>")
vim.keymap.set("n", "Left", "<nop>")
vim.keymap.set("n", "Right", "<nop>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Same as regular J but keep cursor at same place" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down but keep cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up but keep cursor centered" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Nav search terms, but keep cursor at the middle" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Nav search terms, but keep cursor at the middle" })

vim.keymap.set(
  "x",
  "<leader>p",
  [["_dP]],
  { desc = "Delete highlighted world without copying and paster to the place" }
)

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>e", '"_d', { desc = "Delete to void register (without copy)" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable orig dinding" })

vim.keymap.set("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Quick replace" })

-- fix quick fix navigation (moved to trouble mappings)
--vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
--vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<C-j>", function()
  if require("trouble").is_open() then
    require("trouble").next({ skip_groups = true, jump = true })
  else
    local status, _ = pcall(vim.api.nvim_exec2, "cnext", { output = true })
    if status then
      vim.api.nvim_feedkeys("zz", "n", false)
    end
  end
end)
vim.keymap.set("n", "<C-k>", function()
  if require("trouble").is_open() then
    require("trouble").prev({ skip_groups = true, jump = true })
  else
    local status, _ = pcall(vim.api.nvim_exec2, "cprev", { output = true })
    if status then
      vim.api.nvim_feedkeys("zz", "n", false)
    end
  end
end)
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- tabs
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- native snippets. only needed on < 0.11, as 0.11 creates these by default
if vim.fn.has("nvim-0.11") == 0 then
  vim.keymap.set("s", "<Tab>", function()
    return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
  end, { expr = true, desc = "Jump Next" })
  vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
  end, { expr = true, desc = "Jump Previous" })
end

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
--vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
--vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- use `vim.keymap.set` instead
--local map = LazyVim.safe_keymap_set

---- Move to window using the <ctrl> hjkl keys
--map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
--map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
--map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
--map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

---- buffers
--map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
--map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
--map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
--map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
--map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
--map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
--map("n", "<leader>bd", function()
--  Snacks.bufdelete()
--end, { desc = "Delete Buffer" })
--map("n", "<leader>bo", function()
--  Snacks.bufdelete.other()
--end, { desc = "Delete Other Buffers" })
--map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
--
---- Clear search and stop snippet on escape
--map({ "i", "n", "s" }, "<esc>", function()
--  vim.cmd("noh")
--  LazyVim.cmp.actions.snippet_stop()
--  return "<esc>"
--end, { expr = true, desc = "Escape and Clear hlsearch" })
--
---- Clear search, diff update and redraw
---- taken from runtime/lua/_editor.lua
--map(
--  "n",
--  "<leader>ur",
--  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
--  { desc = "Redraw / Clear hlsearch / Diff Update" }
--)
--
---- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
--map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
--map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
--map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
--map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
--map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
--map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
--
---- Add undo break-points
--map("i", ",", ",<c-g>u")
--map("i", ".", ".<c-g>u")
--map("i", ";", ";<c-g>u")

----keywordprg
--map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
--

---- commenting
--map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
--map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
--

---- location list
--map("n", "<leader>xl", function()
--  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
--  if not success and err then
--    vim.notify(err, vim.log.levels.ERROR)
--  end
--end, { desc = "Location List" })
--
---- quickfix list
--map("n", "<leader>xq", function()
--  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
--  if not success and err then
--    vim.notify(err, vim.log.levels.ERROR)
--  end
--end, { desc = "Quickfix List" })
--
--map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
--map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
--
--
---- stylua: ignore start
--
---- toggle options
--LazyVim.format.snacks_toggle():map("<leader>uf")
--LazyVim.format.snacks_toggle(true):map("<leader>uF")
--Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
--Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
--Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
--Snacks.toggle.diagnostics():map("<leader>ud")
--Snacks.toggle.line_number():map("<leader>ul")
--Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
--Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
--Snacks.toggle.treesitter():map("<leader>uT")
--Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
--Snacks.toggle.dim():map("<leader>uD")
--Snacks.toggle.animate():map("<leader>ua")
--Snacks.toggle.indent():map("<leader>ug")
--Snacks.toggle.scroll():map("<leader>uS")
--Snacks.toggle.profiler():map("<leader>dpp")
--Snacks.toggle.profiler_highlights():map("<leader>dph")
--
--if vim.lsp.inlay_hint then
--  Snacks.toggle.inlay_hints():map("<leader>uh")
--end
--
---- lazygit
--if vim.fn.executable("lazygit") == 1 then
--  map("n", "<leader>gg", function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
--  map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
--  map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
--  map("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, { desc = "Git Log" })
--  map("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
--end
--
--map("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
--map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
--map({"n", "x" }, "<leader>gY", function()
--  Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
--end, { desc = "Git Browse (copy)" })

---- highlights under cursor
--map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
--map("n", "<leader>uI", function() vim.treesitter.inspect_tree() vim.api.nvim_input("I") end, { desc = "Inspect Tree" })

---- floating terminal
--map("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
--map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
--map("n", "<c-/>",      function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
--map("n", "<c-_>",      function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "which_key_ignore" })
--
---- Terminal Mappings
--map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
--map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
--
---- windows
--map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
--map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
--map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
--Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
--Snacks.toggle.zen():map("<leader>uz")

--vim.keymap.set("n", "<leader>[", function() vim.cmd("bprev") end, { desc = "Go to the prev buffer" })
--vim.keymap.set("n", "<leader>]", function() vim.cmd("bnext") end, { desc = "Go to the next buffer" })

---- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }, { desc = "Make file executable" })

---- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Navigate projects with tmux" })

---- --- Telesckope ---
--local telebuiltin = require('telescope.builtin')
--vim.keymap.set('n', '<leader>ff', telebuiltin.find_files, { desc = 'Telescope find files' })
--vim.keymap.set('n', '<leader>s', telebuiltin.git_files, { desc = 'Telescope find in git files' })
--vim.keymap.set('n', '<leader>fh', telebuiltin.help_tags, { desc = 'Telescope help tags' })
--vim.keymap.set(
--  'n', '<leader>b',
--  function() telebuiltin.buffers({ initial_mode = 'normal' }) end,
--  { desc = 'Telescope buffers' }
--)
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
--vim.keymap.set('n', '<leader>fg',
--  function()
--    telebuiltin.grep_string({ search = vim.fn.input("Grep > ") })
--  end
--  , { desc = 'Telescope grep search' }
--)
----vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
--
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

---- --- Trouble ---
--vim.keymap.set("n", "]t", function()
--  require("trouble").next({ skip_groups = true, jump = true });
--end)
--
--vim.keymap.set("n", "[t", function()
--  require("trouble").prev({ skip_groups = true, jump = true });
--end)
--
--
---- Obsession --
---- :Obsessesion - start recording session
---- :Obsessesion! - stop recording session and delete
