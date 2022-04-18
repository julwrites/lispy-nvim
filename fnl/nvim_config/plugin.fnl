(module nvim_config.plugin
        {require {sys aniseed.core
                  nvim aniseed.nvim
                  packer packer
                  quick arshlib.quick}})

; Local bindings for conciseness
(local autocmd quick.autocmd)
(local keymap nvim.set_keymap)

(defn spec_packages []
    ; It should be noted that on a first-load, themes are not yet loaded by packer.nvim before they are required
    ; This causes a bit of a weird issue, where at least at the time of writing we cannot enable theme as a config or post-install function
    ; Current solution to this is simply to define an autocommand, which is also semi-supported in Lua at this point

    ; Specifying a table for package specifications, to be returned
    (let [packages {}]

    ; Defining `use` as a function to collect the packages and their configurations in the form
    ; (use "name"
    ;       { key1 value1
    ;         key2 value2 })
    ; This is partly for syntactic sugarcoating, so that the `use` statement can be written cleanly
    ; This also allows a more granular control over each of the configuration values, and extensions if necessary
    (defn use [name spec]
        (tset packages name {})
        (when (= (type spec) :table)
            (each [key value (pairs spec)]
              (tset (. packages name) key value))))

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Boilerplate packages
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Package management
    (use "norcalli/nvim.lua") ; Lua functions for nvim
    (use "wbthomason/packer.nvim") ; Package manager
    (use "nvim-lua/plenary.nvim") ; Lua functions, very useful for a lot of lua-based plugins
    (use "MunifTanjim/nui.nvim") ; UI for Neovim
    (use "arsham/arshlib.nvim"
         { :requires [ "nvim-lua/plenary.nvim" "MunifTanjim/nui.nvim" ] }) ; Functions for Neovim

    ; Fennel
    (defn aniseed_config [] (set nvim.g.aniseed nvim.v.true))
    (use "Olical/aniseed"
         { :config ( aniseed_config ) }) ; Transpiler for configs in fennel to lua
    (defn conjure_config [] (keymap "n" "<C-c><C-b>" ":ConjureEvalBuf<CR>" {}))
    (use "Olical/conjure"
         { :config ( conjure_config ) }) ; On-the-fly fennel interpretation
    (use "tsbohc/zest.nvim") ; Fennel macros for Neovim

    ; Themes
    (defn colorscheme []
        (nvim.command "colorscheme onedark"))
    (defn onedark_config []
        (autocmd { 
                  :events "User PackerComplete"
                  :pattern ""
                  :callback colorscheme }))
    (use "navarasu/onedark.nvim"
         { :config ( onedark_config ) })

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Interface packages
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Fuzzy finder
    (use "kyazdani42/nvim-web-devicons") ; Icons for file interaction
    (defn telescope_config []
        ; Chords (Ivy)
        (keymap "n" "<C-f>" ":Telescope current_buffer_fuzzy_find theme=ivy<CR>" {})
        (keymap "n" "<C-f><C-f>" ":Telescope treesitter theme=ivy<CR>" {})
        (keymap "n" "<C-f><C-g>" ":Telescope live_grep theme=ivy<CR>" {})
        ; Chords (Dropdown)
        (keymap "n" "<C-p><C-p>" ":Telescope commands theme=dropdown<CR>" {})
        (keymap "n" "<C-p><C-f>" ":Telescope find_files theme=ivy<CR>" {})
        ; Chords (Float)
        (keymap "n" "<C-p>" ":Telescope<CR>" {})
        (keymap "n" "<C-p><C-b>" ":Telescope buffers<CR>" {})
        (keymap "n" "<C-p><C-m>" ":Telescope oldfiles<CR>" {}))
    (use "nvim-telescope/telescope.nvim"
         { :config ( telescope_config ) }) ; Fuzzy finder
    (defn treesitter_update []
        (nvim.command "TSUpdate"))
    (defn treesitter_config []
        (autocmd {
                  :events "User PackerComplete"
                  :pattern ""
                  :callback treesitter_update }))
    (use "nvim-treesitter/nvim-treesitter"
         { :config ( treesitter_config ) }) ; Treesitter interface
    (use "BurntSushi/ripgrep") ; Regex search

    ; Status line
    (use "itchyny/lightline.vim") ; Statusline
    (use "maximbaz/lightline-ale") ; Linting indicator for statusline
    (use "airblade/vim-gitgutter") ; Statusline git indicators
    (use "APZelos/blamer.nvim") ; Inline git blame

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Utility packages
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Terminal
    (defn floaterm_config []
        (keymap "n" "<C-t>" ":FloatermToggle<CR>" {})
        (keymap "t" "<C-t>" "<C-\\><C-n>:FloatermToggle<CR>" {}))
    (use "voldikss/vim-floaterm"
         { :config ( floaterm_config ) }) ; Floating terminal
    (use "dylanaraps/taskrunner.nvim") ; Task runner using gulp or grunt

    ; Misc Tools
    (defn vimwiki_config []
        (set nvim.g.vimwiki_list [{:path "~/julwrites/wiki/vimwiki"
                                   :syntax "markdown"
                                   :ext ".md"}]))
    (use "vimwiki/vimwiki"
         { :config ( vimwiki_config ) }) ; Local wiki

    (use "wannesm/wmgraphviz.vim") ; Graphviz

    (use "sindrets/diffview.nvim"
         { :requires "nvim-lua/plenary.nvim" }) ; Difftool

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Software Development packages
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Git
    (use "tpope/vim-fugitive") ; Git manipulation

    (defn neogit_setup []
        ((. (require :neogit) :setup) 
         {:use_magit_keybindings true
          :integrations { 
                         :diffview true 
                         }
          }))
    (defn neogit_config [] 
        (autocmd { 
                  :events "User PackerComplete"
                  :pattern ""
                  :callback neogit_setup }))
    (use "TimUntersberger/neogit"
        { :requires "nvim-lua/plenary.nvim"
          :config ( neogit_config ) }) ; Magit for Vim

    ; Language Support
    (defn coc_enable []
        (nvim.command "CocEnable"))
    (defn coc_install [extensions]
        (nvim.command (string.format "CocInstall%s"
                                     (accumulate [ext_str ""
                                                  _ ext (ipairs extensions)]
                                                 (.. ext_str (string.format " coc-%s" ext))))))
     (defn coc_config [extensions]
        (autocmd { 
                  :events "User PackerComplete"
                  :pattern ""
                  :callback coc_enable }))
        ; (autocmd { :events "User PackerComplete" :pattern "" :callback coc_install }))
    (use "neoclide/coc.nvim"
         {:branch "release"
          :config ( coc_config [:pyright 
                                :tsserver 
                                :json 
                                :html 
                                :css
                                :clangd
                                :cmake
                                :sourcekit
                                :rust-analyzer
                                :flutter-tools])}) ; Extensions for language support (note that `coc-` is prefixed automatically in `coc_config`)
    (use "fannheyward/telescope-coc.nvim")
    (defn ale_config []
        (set nvim.g.ale_sign_error "!!")
        (set nvim.g.ale_sign_warning "--")
        (set nvim.g.ale_sign_column_always true)
        (set nvim.g.ale_disable_lsp true))
    (use "dense-analysis/ale"
         {:setup ( ale_config )}) ; Linting
    (use "bakpakin/fennel.vim") ; Fennel
    (use "elmcast/elm-vim") ; Elm
    (use "fatih/vim-go") ; Golang

    (use "dart-lang/dart-vim-plugin"
         {:config (set nvim.g.dart_format_on_save true)}) ; Dart

    (use "CoatiSoftware/vim-sourcetrail") ; Sourcetrail plugin

    ; Text manipulation
    (defn autoformat []
        (nvim.command ":Autoformat"))
    (defn autoformat_config []
        (set nvim.g.autoformat_autoindent 0)
        (set nvim.g.autoformat_retab 0)
        (set nvim.g.autoformat_remove_trailing_spaces 0)
        (keymap "n" "<F3>" ":Autoformat<CR>" {})
        (autocmd { 
                  :events "BufWrite" 
                  :pattern "*" 
                  :callback autoformat })
        )
    (use "vim-autoformat/vim-autoformat"
         { :config ( autoformat_config ) }) ; Autoformat using default formatprograms
    (use "tpope/vim-surround") ; Use `S<?>` to surround a visual selection with `<?>`
    (use "tpope/vim-commentary") ; Manipulate comments
    (defn polyglot_config []
        (set nvim.g.polyglot_disabled ["elm"]))
    (use "sheerun/vim-polyglot"
         { :config ( polyglot_config ) }) ; Syntax highlighting

    ; Docker
    (use "kkvh/vim-docker-tools") ; Tools for docker manipulation

    ; Return the list of package configurations
    packages
))

; Small, high level interface
(defn update []
    (sys.println "Loading plugins...")

    (let [packages (spec_packages)]
        (packer.init
            {:display
             {:non_interactive false}} ; Silent install and update
            {:profile
             {:enable true}} ; Enable profiling for package management
            )
        (packer.reset)
        (each [name spec (pairs packages)]
            (packer.use (sys.merge {1 name} spec)))
        (packer.sync))
)
