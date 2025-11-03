if lazyvim_docs then
  -- In case you don't want to use `:LazyExtras`,
  -- then you need to set the option below.
  vim.g.lazyvim_picker = "telescope"
end

local build_cmd ---@type string?
for _, cmd in ipairs({ "make", "cmake", "gmake" }) do
  if vim.fn.executable(cmd) == 1 then
    build_cmd = cmd
    break
  end
end

---@type LazyPicker
local picker = {
  name = "telescope",
  commands = {
    files = "find_files",
  },
  -- this will return a function that calls telescope.
  -- cwd will default to lazyvim.util.get_root
  -- for `files`, git_files or find_files will be chosen depending on .git
  ---@param builtin string
  ---@param opts? lazyvim.util.pick.Opts
  open = function(builtin, opts)
    opts = opts or {}
    opts.follow = opts.follow ~= false
    if opts.cwd and opts.cwd ~= vim.uv.cwd() then
      local function open_cwd_dir()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        LazyVim.pick.open(
          builtin,
          vim.tbl_deep_extend("force", {}, opts or {}, {
            root = false,
            default_text = line,
          })
        )
      end
      ---@diagnostic disable-next-line: inject-field
      opts.attach_mappings = function(_, map)
        -- opts.desc is overridden by telescope, until it's changed there is this fix
        map("i", "<a-c>", open_cwd_dir, { desc = "Open cwd Directory" })
        return true
      end
    end

    require("telescope.builtin")[builtin](opts)
  end,
}
if not LazyVim.pick.register(picker) then
  return {}
end

return {
  -- Fuzzy finder.
  -- The default key bindings to find files will use Telescope's
  -- `find_files` or `git_files` depending on whether the
  -- directory is a git repo.
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = (build_cmd ~= "cmake") and "make"
          or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = build_cmd ~= nil,
        config = function(plugin)
          LazyVim.on_load("telescope.nvim", function()
            local ok, err = pcall(require("telescope").load_extension, "fzf")
            if not ok then
              local lib = plugin.dir .. "/build/libfzf." .. (LazyVim.is_win() and "dll" or "so")
              if not vim.uv.fs_stat(lib) then
                LazyVim.warn("`telescope-fzf-native.nvim` not built. Rebuilding...")
                require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                  LazyVim.info("Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.")
                end)
              else
                LazyVim.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
              end
            end
          end)
        end,
      },
    },
    keys = {
      { "<leader>ff", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader>fs", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      {
        "<leader>fb",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal<cr>",
        desc = "Switch Buffer",
      },
      { "<leader>fnc", LazyVim.pick.config_files(), desc = "Find Neovim Config File" },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > "), initial_mode = "normal" })
        end,
        desc = "Telescope grep search",
      },
      { "<leader>fw", LazyVim.pick("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
      { "<leader>fw", LazyVim.pick("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
      {
        "<leader>fo",
        function()
          require("telescope.builtin").oldfiles({ initial_mode = "normal", cwd = vim.uv.cwd() })
        end,
        desc = "Recent",
      },
      { "<leader>fO", "<cmd>Telescope oldfiles<cr>", desc = "Recent Global" },
      { "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Resume (findl last)" },
      { "<leader>fi", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "In Buffer Search" },

      ---- git
      { "<leader>gqc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>gqb", "<cmd>Telescope git_branches<CR>", desc = "Status" },
      { "<leader>gqs", "<cmd>Telescope git_status<CR>", desc = "Status" },

      { "<leader>tlf", "<cmd>Telescope diagnostics bufnr=0 initial_mode=normal<cr>", desc = "Document Diagnostics" },
      { "<leader>tlF", "<cmd>Telescope diagnostics initial_mode=normal<cr>", desc = "Workspace Diagnostics" },

      { "<leader>vcu", LazyVim.pick("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },

      --{ "<leader>sW", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
      --{ "<leader>sW", LazyVim.pick("grep_string", { root = false }), mode = "v", desc = "Selection (cwd)" },
      --{ "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
      --{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      --{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      --{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      --{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      --{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      --{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      --{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      --{ "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
      --{ "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
      --{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      --{
      --  "<leader>ss",
      --  function()
      --    require("telescope.builtin").lsp_document_symbols({
      --      symbols = LazyVim.config.get_kind_filter(),
      --    })
      --  end,
      --  desc = "Goto Symbol",
      --},
      --{
      --  "<leader>sS",
      --  function()
      --    require("telescope.builtin").lsp_dynamic_workspace_symbols({
      --      symbols = LazyVim.config.get_kind_filter(),
      --    })
      --  end,
      --  desc = "Goto Symbol (Workspace)",
      --},
    },
    opts = function()
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.sources.telescope").open(...)
      end
      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
      end
      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        LazyVim.pick("find_files", { hidden = true, default_text = line })()
      end

      local function find_command()
        if 1 == vim.fn.executable("rg") then
          return { "rg", "--files", "--color", "never", "-g", "!.git" }
        elseif 1 == vim.fn.executable("fd") then
          return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("fdfind") then
          return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
          return { "find", ".", "-type", "f" }
        elseif 1 == vim.fn.executable("where") then
          return { "where", "/r", ".", "*" }
        end
      end

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              --["<a-t>"] = open_with_trouble,
              --["<a-i>"] = find_files_no_ignore,
              --["<a-h>"] = find_files_with_hidden,
              --["<C-Down>"] = actions.cycle_history_next,
              --["<C-Up>"] = actions.cycle_history_prev,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = find_command,
            hidden = true,
          },
        },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      local Keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- stylua: ignore
      vim.list_extend(Keys, {
        { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
        { "gr", "<cmd>Telescope lsp_references initial_mode=normal reuse_win=true<cr>", desc = "References", nowait = true },
        { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
        { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
      })
    end,
  },

  -- Flash Telescope config
  --{
  --  "nvim-telescope/telescope.nvim",
  --  optional = true,
  --  opts = function(_, opts)
  --    if not LazyVim.has("flash.nvim") then
  --      return
  --    end
  --    local function flash(prompt_bufnr)
  --      require("flash").jump({
  --        pattern = "^",
  --        label = { after = { 0, 0 } },
  --        search = {
  --          mode = "search",
  --          exclude = {
  --            function(win)
  --              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
  --            end,
  --          },
  --        },
  --        action = function(match)
  --          local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  --          picker:set_selection(match.pos[1] - 1)
  --        end,
  --      })
  --    end
  --    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
  --      mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
  --    })
  --  end,
  --},

  -- better vim.ui with telescope
  --{
  --  "stevearc/dressing.nvim",
  --  lazy = true,
  --  init = function()
  --    ---@diagnostic disable-next-line: duplicate-set-field
  --    vim.ui.select = function(...)
  --      require("lazy").load({ plugins = { "dressing.nvim" } })
  --      return vim.ui.select(...)
  --    end
  --    ---@diagnostic disable-next-line: duplicate-set-field
  --    vim.ui.input = function(...)
  --      require("lazy").load({ plugins = { "dressing.nvim" } })
  --      return vim.ui.input(...)
  --    end
  --  end,
  --},
}
