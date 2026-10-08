-- LSP: servers are provided by Nix (no more mason), nvim-lspconfig only
-- supplies their default configs (lsp/ folder). A server is enabled only
-- if its binary is in PATH: the same config works on the server (few tools)
-- and on the laptop (full dev tooling).

-- Server name -> the binary to look for. Named here rather than read from the
-- default config: many configs' `cmd` is a function (it prefers the project's
-- node_modules/.bin), which has no binary name to check.
local servers = {
    lua_ls = "lua-language-server",
    nil_ls = "nil", -- Nix
    yamlls = "yaml-language-server",
    taplo = "taplo", -- TOML
    bashls = "bash-language-server",
    jsonls = "vscode-json-language-server",
    cssls = "vscode-css-language-server",
    nim_langserver = "nimlangserver",
    astro = "astro-ls",
    svelte = "svelteserver",
    ts_ls = "typescript-language-server",
}

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "antosha417/nvim-lsp-file-operations", config = true },
        -- Replaces neodev.nvim (abandoned): Neovim API completion in Lua files.
        { "folke/lazydev.nvim", ft = "lua", opts = {} },
    },
    config = function()
        local keymap = vim.keymap

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }

                opts.desc = "Show LSP references"
                keymap.set("n", "gR", function()
                    Snacks.picker.lsp_references()
                end, opts)

                opts.desc = "Go to declaration"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                opts.desc = "Show LSP definitions"
                keymap.set("n", "gd", function()
                    Snacks.picker.lsp_definitions()
                end, opts)

                opts.desc = "Show LSP implementations"
                keymap.set("n", "gi", function()
                    Snacks.picker.lsp_implementations()
                end, opts)

                opts.desc = "Show LSP type definitions"
                keymap.set("n", "gt", function()
                    Snacks.picker.lsp_type_definitions()
                end, opts)

                opts.desc = "See available code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                opts.desc = "Smart rename"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "Show buffer diagnostics"
                keymap.set("n", "<leader>D", function()
                    Snacks.picker.diagnostics_buffer()
                end, opts)

                opts.desc = "Show line diagnostics"
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                opts.desc = "Go to previous diagnostic"
                keymap.set("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, opts)

                opts.desc = "Go to next diagnostic"
                keymap.set("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, opts)

                opts.desc = "Show documentation for what is under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
            end,
        })

        -- Native Neovim API (0.11+): completion capabilities shared by all servers.
        vim.lsp.config("*", {
            capabilities = require("blink.cmp").get_lsp_capabilities(),
        })

        for name, bin in pairs(servers) do
            if vim.fn.executable(bin) == 1 then
                vim.lsp.enable(name)
            end
        end
    end,
}
