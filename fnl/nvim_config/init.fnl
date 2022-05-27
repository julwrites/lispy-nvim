(module nvim_config.init
    {autoload { sys aniseed.core
                nvim aniseed.nvim
                plug nvim_config.plugin
                opts nvim_config.options
                util nvim_config.utils}})

; If you see this, bootstrapper succeeded
(sys.println "Aniseed found init.fnl...")

; Nvim setup
(sys.println "Defining vim options...")
(opts.define)

; Plugin setup
(sys.println "Ready to install/update packages...")
(plug.update)

(sys.println "Defining utilities...")
(util.define)
