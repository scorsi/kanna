-- The "master" branch (old API) was frozen upstream and the repo was
-- archived on 2026-04-03: the "main" rewrite (different API, requires
-- Neovim >=0.12) is the only branch still receiving updates.
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local languages = {
            "astro",
            "bash",
            "c",
            "css",
            "fish",
            "html",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "nim",
            "nix",
            "query",
            "svelte",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        }

        require("nvim-treesitter").install(languages)

        -- The main branch no longer handles highlight/indent automatically:
        -- these are native Neovim features, enabled per filetype.
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "astro",
                "sh",
                "c",
                "css",
                "fish",
                "html",
                "javascript",
                "javascriptreact",
                "json",
                "lua",
                "markdown",
                "nim",
                "nix",
                "svelte",
                "toml",
                "typescript",
                "typescriptreact",
                "vim",
                "help",
                "yaml",
            },
            callback = function()
                vim.treesitter.start()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
