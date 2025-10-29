-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- view missed notifications
        ["<Leader>n"] = {
          function() require("snacks").notifier.show_history() end,
          desc = "Notification history",
        },

        -- show TypeScript type information in floating window
        ["<Leader>lt"] = {
          function()
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
              if err then
                vim.notify("Error getting type info: " .. tostring(err), vim.log.levels.ERROR)
                return
              end
              if not result or not result.contents then
                vim.notify("No type information available", vim.log.levels.WARN)
                return
              end

              -- Format the hover content
              local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
              markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)

              if vim.tbl_isempty(markdown_lines) then
                vim.notify("No type information available", vim.log.levels.WARN)
                return
              end

              -- Create floating window with better styling
              local bufnr = vim.api.nvim_create_buf(false, true)
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, markdown_lines)
              vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")

              local width = math.min(80, vim.o.columns - 4)
              local height = math.min(#markdown_lines + 2, math.floor(vim.o.lines * 0.8))

              local opts = {
                relative = "cursor",
                width = width,
                height = height,
                row = 1,
                col = 0,
                style = "minimal",
                border = "rounded",
                focusable = true,
              }

              local win = vim.api.nvim_open_win(bufnr, false, opts)
              vim.api.nvim_win_set_option(win, "wrap", true)
              vim.api.nvim_win_set_option(win, "linebreak", true)

              -- Close on cursor move or buffer leave (from the original buffer)
              local original_buf = vim.api.nvim_get_current_buf()
              vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter" }, {
                buffer = original_buf,
                callback = function()
                  if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                  end
                  return true -- Delete the autocmd after it fires
                end,
              })

              -- Also close if user presses escape or clicks elsewhere
              vim.keymap.set("n", "<Esc>", function()
                if vim.api.nvim_win_is_valid(win) then
                  vim.api.nvim_win_close(win, true)
                end
              end, { buffer = bufnr, nowait = true })
            end)
          end,
          desc = "Show type info",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
