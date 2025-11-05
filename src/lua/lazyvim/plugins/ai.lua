return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<C-j>",
          prev = "<C-k>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- add ai_accept action
  {
    "zbirenbaum/copilot.lua",
    opts = function()
      LazyVim.cmp.actions.ai_accept = function()
        if require("copilot.suggestion").is_visible() then
          LazyVim.create_undo()
          require("copilot.suggestion").accept()
          return true
        end
      end
    end,
  },

  vim.g.ai_cmp
      and {
        -- copilot cmp source
        {
          "hrsh7th/nvim-cmp",
          optional = true,
          dependencies = { -- this will only be evaluated if nvim-cmp is enabled
            {
              "MaKTD/copilot-cmp",
              version = false,
              opts = {},
              config = function(_, opts)
                local copilot_cmp = require("copilot_cmp")
                copilot_cmp.setup(opts)
                -- attach cmp source whenever copilot attaches
                -- fixes lazy-loading issues with the copilot cmp source
                LazyVim.lsp.on_attach(function()
                  copilot_cmp._on_insert_enter({})
                end, "copilot")
              end,
            },
          },
        },
      }
    or nil,

  {
    "Davidyz/VectorCode",
    version = "*", -- optional, depending on whether you're on nightly or release
    build = "uv tool upgrade vectorcode",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode", -- if you're lazy-loading VectorCode
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Davidyz/VectorCode",
    },
    event = "VeryLazy",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
    keys = {
      { "<leader>i", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>io",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "Toggle Ai Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>ia",
        "<cmd>CodeCompanionActions<cr>",
        desc = "Toggle Ai Actions",
        mode = { "n", "v" },
      },
      --{
      --  "<leader>ix",
      --  function()
      --    return require("CopilotChat").reset()
      --  end,
      --  desc = "Clear (CopilotChat)",
      --  mode = { "n", "v" },
      --},
      --{
      --  "<leader>iq",
      --  function()
      --    vim.ui.input({
      --      prompt = "Quick Chat: ",
      --    }, function(input)
      --      if input ~= "" then
      --        require("CopilotChat").ask(input)
      --      end
      --    end)
      --  end,
      --  desc = "Quick Chat (CopilotChat)",
      --  mode = { "n", "v" },
      {
        "<leader>ip",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          opts = {
            show_model_choices = false,
          },
        },
        memory = {
          opts = {
            chat = {
              enabled = true,
              default_memory = "default",
            },
          },
        },
        strategies = {
          chat = {
            keymaps = {
              send = {
                modes = { n = "<C-s>", i = "<C-s>" },
                opts = {},
              },
              close = {
                modes = { n = "<C-c>", i = "<C-c>" },
                opts = {},
              },
            },
            opts = {
              completion_provider = "cmp", -- blink|cmp|coc|default
            },
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
            keymaps = {
              accept_change = {
                modes = { n = "<leader>ia" },
                description = "Accept the suggested change",
              },
              reject_change = {
                modes = { n = "gr" },
                opts = { nowait = true },
                description = "Reject the suggested change",
              },
            },
          },
          cmd = {
            adapter = "deepseek",
          },
        },
        display = {
          chat = {
            --show_settings = true,
          },
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ", -- Prompt used for interactive LLM calls
            provider = "telescope", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
            opts = {
              show_default_actions = true, -- Show the default actions in the action palette?
              show_default_prompt_library = true, -- Show the default prompt library in the action palette?
              title = "CodeCompanion actions", -- The title of the action palette
            },
          },
        },
        extensions = {
          vectorcode = {
            ---@type VectorCode.CodeCompanion.ExtensionOpts
            opts = {
              tool_group = {
                -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
                enabled = true,
                -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
                -- if you use @vectorcode_vectorise, it'll be very handy to include
                -- `file_search` here.
                extras = {},
                collapse = false, -- whether the individual tools should be shown in the chat
              },
              tool_opts = {
                ---@type VectorCode.CodeCompanion.ToolOpts
                ["*"] = {},
                ---@type VectorCode.CodeCompanion.LsToolOpts
                ls = {},
                ---@type VectorCode.CodeCompanion.VectoriseToolOpts
                vectorise = {},
                ---@type VectorCode.CodeCompanion.QueryToolOpts
                query = {
                  max_num = { chunk = -1, document = -1 },
                  default_num = { chunk = 50, document = 10 },
                  include_stderr = false,
                  use_lsp = false,
                  no_duplicate = true,
                  chunk_mode = false,
                  ---@type VectorCode.CodeCompanion.SummariseOpts
                  summarise = {
                    ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
                    enabled = false,
                    adapter = nil,
                    query_augmented = true,
                  },
                },
                files_ls = {},
                files_rm = {},
              },
            },
          },
        },
      })
    end,
  },

  --{
  --  "CopilotC-Nvim/CopilotChat.nvim",
  --  branch = "main",
  --  cmd = "CopilotChat",
  --  version = "v3.12.2",
  --  build = "make tiktoken",
  --  opts = function()
  --    local user = vim.env.USER or "User"
  --    user = user:sub(1, 1):upper() .. user:sub(2)
  --    local vectorcode_ctx = require("vectorcode.integrations.copilotchat").make_context_provider({
  --      prompt_header = "Here are relevant files from the repository:", -- Customize header text
  --      prompt_footer = "\nConsider this context when answering:", -- Customize footer text
  --      skip_empty = true, -- Skip adding context when no files are retrieved
  --    })
  --
  --    return {
  --      auto_insert_mode = true,
  --      question_header = "  " .. user .. " ",
  --      answer_header = "  Copilot ",
  --      window = {
  --        width = 0.4,
  --      },
  --      contexts = {
  --        vectorcode = vectorcode_ctx,
  --      },
  --      prompts = {
  --        Explain = {
  --          prompt = "Explain the following code in detail:\n$input",
  --          context = { "selection", "vectorcode" }, -- Add vectorcode to the context
  --        },
  --      },
  --    }
  --  end,
  --  keys = {
  --    { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
  --    { "<leader>i", "", desc = "+ai", mode = { "n", "v" } },
  --    {
  --      "<leader>io",
  --      function()
  --        return require("CopilotChat").toggle()
  --      end,
  --      desc = "Toggle (CopilotChat)",
  --      mode = { "n", "v" },
  --    },
  --    {
  --      "<leader>ix",
  --      function()
  --        return require("CopilotChat").reset()
  --      end,
  --      desc = "Clear (CopilotChat)",
  --      mode = { "n", "v" },
  --    },
  --    {
  --      "<leader>iq",
  --      function()
  --        vim.ui.input({
  --          prompt = "Quick Chat: ",
  --        }, function(input)
  --          if input ~= "" then
  --            require("CopilotChat").ask(input)
  --          end
  --        end)
  --      end,
  --      desc = "Quick Chat (CopilotChat)",
  --      mode = { "n", "v" },
  --    },
  --    {
  --      "<leader>ip",
  --      function()
  --        require("CopilotChat").select_prompt()
  --      end,
  --      desc = "Prompt Actions (CopilotChat)",
  --      mode = { "n", "v" },
  --    },
  --  },
  --  config = function(_, opts)
  --    local chat = require("CopilotChat")
  --
  --    vim.api.nvim_create_autocmd("BufEnter", {
  --      pattern = "copilot-chat",
  --      callback = function()
  --        vim.opt_local.relativenumber = false
  --        vim.opt_local.number = false
  --      end,
  --    })
  --
  --    chat.setup(opts)
  --  end,
  --},
}
