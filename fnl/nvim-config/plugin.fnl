(module nvim-config.plugin
    {require {sys aniseed.core
              nvim aniseed.nvim
              packer packer}})

; Rebinding nvim.set_keymap to keymap for conciseness
(local keymap nvim.set_keymap)

(defn packages [use]
    ;;; Some notes on package management: 
    ; use is injected by packer.startup, so it is available within this local call
    ; It is possible also to directly provide a lambda to packer.startup
    ; (packer.startup (fn [use] ... )

    ; (use "thomason/packer.nvim") -> use { "thomason/packer.nvim" }
    ; (use {1 "Olical/aniseed" :config ( aniseed-config ) }) -> use { "Olical/aniseed" config=aniseed-config() }
    ; Interestingly `1` is a special symbol for the table. Any other symbol will translate to the following
    ; (use {2 "Olical/aniseed" :config ( aniseed-config ) }) -> use { [2]="Olical/aniseed" config=aniseed-config() }

    ; Although packer.nvim does provide the ability to set a lambda as a function, Fennel does not like that
    ; However, if it is a single-line function, it is possible to provide that
    ; (use {1 "Olical/aniseed" :config ( set nvim.g.aniseed nvim.v.true )}) ; this will work
    ; (use {1 "Olical/aniseed" :config (fn [] set nvim.g.aniseed nvim.v.true )}) ; this will not
    ; This problem is exacerbated when we need more commands to be called in the function
    ; For a more consistent behavior and interface, I decided to just define a function as necessary, and pass that

    ; It should also be noted that on a first-load, themes are not yet loaded by packer.nvim before they are required
    ; This causes a bit of a weird issue, where at least at the time of writing we cannot enable theme as a config or post-install function
    ; Current solution to this is simply to define an autocommand, which is also semi-supported in Lua at this point
    ; The following helper function helps to make the hack a little more palatable
    (defn autocmd [trigger func_str]
        "Creates an autocommand given the trigger and a function string"
        (nvim.command (.. "autocmd " trigger " " func_str)))


    ; Package management
    (use "wbthomason/packer.nvim")

    ; Fennel
    (defn aniseed-config [] (set nvim.g.aniseed nvim.v.true))
    (use {1 "Olical/aniseed"
          :config ( aniseed-config )})
    (defn conjure-config [] (keymap "n" "<C-c><C-b>" ":ConjureEvalBuf<CR>" {}))
    (use {1 "Olical/conjure"
          :config ( conjure-config )})

    ; Lua
    (use "nvim-lua/plenary.nvim")

    ; Interface
    (use "kyazdani42/nvim-web-devicons")
    (defn telescope-config []
        (keymap "n" "<C-p>" ":Telescope<CR>" {})
        (keymap "n" "<C-p><C-f>" ":Telescope find_files<CR>" {})
        (keymap "n" "<C-p><C-m>" ":Telescope oldfiles<CR>" {}))
    (use {1 "nvim-telescope/telescope.nvim"
          :config ( telescope-config )})
    (defn dashboard-config []
        (set nvim.g.dashboard_default_executive "telescope")
        (keymap "n" "<C-k><C-w>" ":Dashboard<CR>" {}))
    (use {1 "glepnir/dashboard-nvim" 
          :config ( dashboard-config )})
    (defn nvim-tree-config [] (keymap "n" "<C-n>" ":NvimTreeToggle<CR>" {}))
    (use {1 "kyazdani42/nvim-tree.lua" 
          :config ( nvim-tree-config )})

    ; Status line
    (use "akinsho/bufferline.nvim")
    (use "itchyny/lightline.vim")

    ; Terminal
    (defn floaterm-config []
        (keymap "n" "<C-t>" ":FloatermToggle<CR>" {})
        (keymap "t" "<C-t>" "<C-\\><C-n>:FloatermToggle<CR>" {}))
    (use {1 "voldikss/vim-floaterm"
          :config ( floaterm-config )})
    (use "dylanaraps/taskrunner.nvim")

    ; Git
    (use "tpope/vim-fugitive")
    (use "airblade/vim-gitgutter")

    ; Text manipulation
    (use "tpope/vim-surround")
    (use "tpope/vim-commentary")

    ; Language Support
    (use {1 "neoclide/coc.nvim" 
          :branch "release"})
    (use "sheerun/vim-polyglot")
    (use "bakpakin/fennel.vim")
    (use "keith/swift.vim")

    ; Misc Tools
    (use "vimwiki/vimwiki")

    ; Themes
    (defn onedark-config []
        (autocmd "User PackerComplete" "colorscheme onedark"))
    (use {1 "navarasu/onedark.nvim"
          :config ( onedark-config )})
)

; Small, high level interface
(defn update []
    (sys.println "Loading plugins...")

    (packer.startup  packages)

    (packer.sync)
)
