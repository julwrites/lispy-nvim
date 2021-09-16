(module nvim-config.plugin
    {require {sys aniseed.core
              nvim aniseed.nvim
              packer packer}})

; Rebinding nvim.set_keymap to keymap for conciseness
(local keymap nvim.set_keymap)

; The following helper function helps to make autocmd definition look better
(defn autocmd [trigger func_str]
    "Creates an autocommand given the trigger and a function string"
    (nvim.command (.. "autocmd " trigger " " func_str)))

(defn spec-packages []
    ; It should also be noted that on a first-load, themes are not yet loaded by packer.nvim before they are required
    ; This causes a bit of a weird issue, where at least at the time of writing we cannot enable theme as a config or post-install function
    ; Current solution to this is simply to define an autocommand, which is also semi-supported in Lua at this point

    ; Specifying `use` for this function since we are using packer.init
    ; It is possible also to directly provide a lambda or function to packer.startup in the following form
    ; (packer.startup (fn [use] ... )
    (local use packer.use)

    ; Regarding the `use` function
    ; (use "thomason/packer.nvim") -> use { "thomason/packer.nvim" }
    ; (use {1 "Olical/aniseed" :config ( aniseed-config ) }) -> use { "Olical/aniseed" config=aniseed-config() }
    ; Interestingly `1` is a special symbol for the table. Any other symbol will translate to the following
    ; (use {2 "Olical/aniseed" :config ( aniseed-config ) }) -> use { [2]="Olical/aniseed" config=aniseed-config() }

    ; Regarding the specification of a function as a config callback
    ; Although packer.nvim does provide the ability to set a lambda as a function, Fennel does not like that
    ; However, if it is a single-line function, it is possible to provide that
    ; (use {1 "Olical/aniseed" :config ( set nvim.g.aniseed nvim.v.true )}) ; this will work
    ; (use {1 "Olical/aniseed" :config (fn [] set nvim.g.aniseed nvim.v.true )}) ; this will not
    ; This problem is exacerbated when we need more commands to be called in the function
    ; For a more consistent behavior and interface, I decided to just define a function as necessary, and pass that

    (defn boilerplate []
        ; Package management
        (use "wbthomason/packer.nvim") ; Package manager

        ; Fennel
        (defn aniseed-config [] (set nvim.g.aniseed nvim.v.true))
        (use {1 "Olical/aniseed"
              :config ( aniseed-config )}) ; Transpiler for configs in fennel to lua
        (defn conjure-config [] (keymap "n" "<C-c><C-b>" ":ConjureEvalBuf<CR>" {}))
        (use {1 "Olical/conjure"
              :config ( conjure-config )}) ; On-the-fly fennel interpretation
        (use "nvim-lua/plenary.nvim") ; Lua functions, very useful for a lot of lua-based plugins
    )

    (defn interface []
        ; File explorer
        (use "kyazdani42/nvim-web-devicons") ; Icons for file interaction
        (defn nvim-tree-config [] (keymap "n" "<C-n>" ":NvimTreeToggle<CR>" {}))
        (use {1 "kyazdani42/nvim-tree.lua" 
              :config ( nvim-tree-config )}) ; File explorer
        (defn telescope-config []
            (keymap "n" "<C-p>" ":Telescope<CR>" {})
            (keymap "n" "<C-p><C-f>" ":Telescope find_files<CR>" {})
            (keymap "n" "<C-p><C-m>" ":Telescope oldfiles<CR>" {}))
        ; Dashboard
        (defn dashboard-config []
            (set nvim.g.dashboard_default_executive "telescope")
            (keymap "n" "<C-k><C-w>" ":Dashboard<CR>" {}))
        (use {1 "glepnir/dashboard-nvim" 
              :config ( dashboard-config )}) ; Startup dashboard
        ; Fuzzy finder
        (use "nvim-telescope/telescope.nvim"
              :config ( telescope-config )) ; Fuzzy finder

        ; Status line
        (use "itchyny/lightline.vim") ; Statusline
        (use "airblade/vim-gitgutter") ; Statusline git indicators
    )

    (defn utility []
        ; Terminal
        (defn floaterm-config []
            (keymap "n" "<C-t>" ":FloatermToggle<CR>" {})
            (keymap "t" "<C-t>" "<C-\\><C-n>:FloatermToggle<CR>" {}))
        (use {1 "voldikss/vim-floaterm"
              :config ( floaterm-config )}) ; Floating terminal
        (use "dylanaraps/taskrunner.nvim") ; Task runner using gulp or grunt

        ; Misc Tools
        (use "vimwiki/vimwiki") ; Local wiki
    )

    (defn programming []
        ; Git
        (use "tpope/vim-fugitive") ; Git manipulation

        ; Docker
        (use "kkvh/vim-docker-tools") ; Tools for docker manipulation

        ; Language Support
        (use "neovim/nvim-lspconfig") ; Neovim's own LSP configuration
        (fn setup-lsp []
            ((. (require :lspinstall) :setup))
            (local servers ((. (require :lspinstall) :installed_servers)))
            (each [_ server (pairs servers)]
                ((. (. (require :lspconfig) server) :setup) {})))
        (use {1 "kabouzeid/nvim-lspinstall"
              :config ( setup-lsp )}) ; Enables :LspInstall, which hosts quite a number of LSP installers
        (use "bakpakin/fennel.vim") ; Fennel

        ; Text manipulation
        (use "tpope/vim-surround") ; Use `S<?>` to surround a visual selection with `<?>`
        (use "tpope/vim-commentary") ; Manipulate comments
        (use "sheerun/vim-polyglot") ; Syntax highlighting
    )

    (defn theme []
        ; Themes
        (defn onedark-config []
            (autocmd "User PackerComplete" "colorscheme onedark"))
        (use {1 "navarasu/onedark.nvim"
              :config ( onedark-config )})
    )

    (boilerplate)
    (interface)
    (utility)
    (programming)
    (theme)
)

; Small, high level interface
(defn update []
    (sys.println "Loading plugins...")

    (packer.init
      {:display 
        {:non_interactive true}} ; Silent install and update
      {:profile
       {:enable true}} ; Enable profiling for package management
      )

    (packer.reset)

    (spec-packages)

    (packer.sync)
 support)
