return {
  {
    "saghen/blink.cmp",
    enabled = false,
    optional = true,
  },

  -- Setup nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    -- Not all LSP servers add brackets when completing a function.
    -- To better deal with this, LazyVim adds a custom option to cmp,
    -- that you can configure. For example:
    --
    -- ```lua
    -- opts = {
    --   auto_brackets = { "python" }
    -- }
    -- ```
    opts = function()
      --vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local auto_select = true
      return {
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-space>"] = LazyVim.cmp.confirm({ select = true }),
          ["<C-y>"] = {
            i = cmp.mapping.complete(),
          },
          ["<C-e>"] = {
            i = cmp.mapping.abort(),
          },
          --["<C-b>"] = cmp.mapping.scroll_docs(-4),
          --["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<tab>"] = function(fallback)
            return LazyVim.cmp.map({ "snippet_forward", "ai_accept" }, fallback)()
          end,
        }),

        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources({
          { name = "copilot", group_index = 1, priority = 100 },
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = function(entry, item)
            local icons = LazyVim.config.icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end

            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
              end
            end

            return item
          end,
        },
        experimental = {
          -- only show ghost text when we show ai completions
          ghost_text = vim.g.ai_cmp and {
            hl_group = "CmpGhostText",
          } or false,
        },
        sorting = defaults.sorting,
      }
    end,
    main = "lazyvim.util.cmp",
  },

  {
    "hrsh7th/cmp-cmdline",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = {
          ["<Tab>"] = {
            c = function()
              local cmp = require("cmp")
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.complete()
              end
            end,
          },
          ["<S-Tab>"] = {
            c = function()
              local cmp = require("cmp")
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.complete()
              end
            end,
          },
          ["<C-j>"] = {
            c = function()
              local cmp = require("cmp")
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.complete()
              end
            end,
          },
          ["<C-k>"] = {
            c = function()
              local cmp = require("cmp")
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.complete()
              end
            end,
          },
          ["<C-space>"] = {
            c = cmp.mapping.confirm({ select = true }),
          },
          ["<C-y>"] = {
            c = cmp.mapping.confirm({ select = false }),
          },
          ["<C-e>"] = {
            c = cmp.mapping.abort(),
          },
        },
        --mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = {
          ["<Tab>"] = {
            c = function()
              local cmp = require("cmp")
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.complete()
              end
            end,
          },
          ["<S-Tab>"] = {
            c = function()
              local cmp = require("cmp")
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.complete()
              end
            end,
          },
          ["<C-j>"] = {
            c = function()
              local cmp = require("cmp")
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.complete()
              end
            end,
          },
          ["<C-k>"] = {
            c = function()
              local cmp = require("cmp")
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.complete()
              end
            end,
          },
          ["<C-space>"] = {
            c = cmp.mapping.confirm({ select = true }),
          },
          ["<C-y>"] = {
            c = cmp.mapping.confirm({ select = false }),
          },
          ["<C-e>"] = {
            c = cmp.mapping.abort(),
          },
        },
        --mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },

  -- snippets
  --{
  --  "hrsh7th/nvim-cmp",
  --  dependencies = {
  --    {
  --      "garymjr/nvim-snippets",
  --      opts = {
  --        friendly_snippets = true,
  --      },
  --      dependencies = { "rafamadriz/friendly-snippets" },
  --    },
  --  },
  --  opts = function(_, opts)
  --    opts.snippet = {
  --      expand = function(item)
  --        return LazyVim.cmp.expand(item.body)
  --      end,
  --    }
  --    if LazyVim.has("nvim-snippets") then
  --      table.insert(opts.sources, { name = "snippets" })
  --    end
  --  end,
  --},
}
