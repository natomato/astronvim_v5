-- Alternative approach: Filter diagnostics after they're published
return {
  {
    "AstroNvim/astrocore",
    opts = {
      autocmds = {
        jsonc_diagnostic_filter = {
          {
            event = "DiagnosticChanged",
            pattern = "*.jsonc",
            callback = function(args)
              local bufnr = args.buf
              local diagnostics = vim.diagnostic.get(bufnr)
              local filtered = {}

              for _, diag in ipairs(diagnostics) do
                local keep = true

                -- Check if this is a jsonls diagnostic we want to filter
                if diag.source == "jsonc" or diag.source == "jsonls" then
                  local message = diag.message or ""

                  -- Filter out trailing commas and comments
                  if
                    diag.code == 519
                    or string.find(message, "Trailing comma")
                    or string.find(message, "Comments are not permitted")
                  then
                    keep = false
                  end
                end

                if keep then table.insert(filtered, diag) end
              end

              -- Only update if we actually filtered something
              if #filtered < #diagnostics then
                vim.diagnostic.reset(nil, bufnr)
                vim.diagnostic.set(vim.api.nvim_create_namespace "filtered_jsonc", bufnr, filtered)
              end
            end,
          },
        },
      },
    },
  },
}
