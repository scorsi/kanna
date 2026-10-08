return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- Formatters come from PATH (provided by Nix); a missing formatter is ignored.
        -- prettier is the project's own when it has one (node_modules/.bin), with
        -- its plugins (prettier-plugin-astro/svelte), and the PATH one otherwise.
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                nix = { "nixfmt" },
                yaml = { "yamlfmt" },
                bash = { "shfmt" },
                json = { "prettier" },
                astro = { "prettier" },
                svelte = { "prettier" },
                typescript = { "prettier" },
                javascript = { "prettier" },
                css = { "prettier" },
                nim = { "nimpretty" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
