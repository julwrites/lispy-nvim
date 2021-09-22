(module nvim_config.utils
        {require {nvim aniseed.nvim}})

; Helper function helps to make autocmd definition look better
(defn vim_autocmd [trigger pattern func_str]
    (nvim.command (.. "au " trigger " " pattern " " func_str)))
