(module nvim-config.init
    {autoload { sys aniseed.core
                nvim aniseed.nvim
                plug nvim-config.plugin
                opts nvim-config.options}})

; If you see this, bootstrapper succeeded
(sys.println "Aniseed found init.fnl...")

; Nvim setup
(opts.define)

; Plugin setup
(plug.update)
