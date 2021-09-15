(module nvim-config.init
    {autoload { sys aniseed.core
                nvim aniseed.nvim
                plug nvim-config.plugin
                opts nvim-config.options}})

; If you see this, bootstrapper succeeded
(sys.println "Aniseed found init.fnl...")

; Nvim setup
(sys.println "Defining vim options...")
(opts.define)

; Plugin setup
(sys.println "Ready to install/update packages...")
(plug.update)
