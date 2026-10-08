local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    -- The restore of a first start leaves lazy.nvim on the tip of `stable`: begin at the locked commit.
    local lock = vim.api.nvim_get_runtime_file("lazy-lock.json", false)[1]
    local locked = lock and vim.json.decode(table.concat(vim.fn.readfile(lock), "\n"))["lazy.nvim"]
    if locked then
        vim.fn.system({ "git", "-C", lazypath, "checkout", "--quiet", locked.commit })
    end
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
