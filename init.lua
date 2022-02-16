print("****************************************")
print("*** *** Neovim-Lisp Bootstrapper *** ***")
print("****************************************")

local time_start = os.clock()

function bootstrap (user, repo)
    local fn = vim.fn
    local install_path = fn.stdpath('data')..string.format('/site/pack/packer/start/%s', repo)
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', string.format('https://github.com/%s/%s', user, repo), install_path})
        vim.api.nvim_command(string.format('packadd %s', repo))
    end
end

print("Bootstrapping Nvim.lua")
bootstrap("norcalli", "nvim.lua")

print("Bootstrapping Packer.nvim")
bootstrap("wbthomason", "packer.nvim")

print("Bootstrapping Aniseed")
bootstrap("Olical", "aniseed")

print("Bootstrapping Plenary")
bootstrap("nvim-lua", "plenary.nvim")

print("Bootstrapping Nui")
bootstrap("MunifTanjim", "nui.nvim")

print("Bootstrapping Arshlib")
bootstrap("arsham", "arshlib.nvim")

vim.g["aniseed#env"] = { module = "nvim_config.init" }

print(string.format("Bootstrapper took: %.9f s\n", os.clock() - time_start))
print("****************************************")
print("Aniseed is taking over...")
