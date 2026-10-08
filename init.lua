-- The config runs either from a writable clone (dev mode: ~/.config/nvim links to it) or from a
-- read-only copy in the Nix store (home-manager without devPath, or `nix run`). The directory of
-- this file decides, not stdpath("config"): under `nix run` (`nvim -u <store>/init.lua`),
-- stdpath("config") is whatever the user has in ~/.config/nvim.
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
local frozen = vim.fn.filewritable(root) ~= 2

if root ~= vim.fn.stdpath("config") then
    vim.opt.rtp:prepend(root)
end

require("core.options")
require("core.keymaps")

require("lazy-init")

-- Dev mode: lazy.nvim writes the lockfile into the clone, to be committed.
-- Frozen: the repo's lockfile can't be written to, so lazy.nvim gets a copy in stdpath("state"),
-- refreshed at every start; when the repo's version changed since the last start, the installed
-- plugins are brought back to it once (`Lazy restore`).
local lockfile = root .. "/lazy-lock.json"
local new_hash
if frozen then
    local state = vim.fn.stdpath("state")
    local lines = vim.fn.readfile(lockfile, "b")
    local hash = vim.fn.sha256(table.concat(lines, "\n"))
    local hashfile = state .. "/lazy-lock.sha256"
    local previous = vim.fn.filereadable(hashfile) == 1 and vim.fn.readfile(hashfile)[1] or nil

    vim.fn.mkdir(state, "p")
    lockfile = state .. "/lazy-lock.json"
    vim.fn.writefile(lines, lockfile, "b")
    if hash ~= previous then
        new_hash = { hash, hashfile }
    end
end

require("lazy").setup("plugins", {
    lockfile = lockfile,
    -- Plugin updates are deliberate, made in dev mode and committed with the lockfile.
    checker = { enabled = false },
    change_detection = { enabled = not frozen },
    -- lazy.nvim resets the runtimepath to stdpath("config") & co: keep this directory in it.
    performance = { rtp = { paths = { root } } },
})

if new_hash then
    require("lazy").restore({ wait = true, show = false })
    vim.fn.writefile({ new_hash[1] }, new_hash[2])
end
