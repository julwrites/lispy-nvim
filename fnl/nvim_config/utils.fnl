(module nvim_config.utils
        {require {nvim aniseed.nvim}})

; Helper function helps to make autocmd definition look better
(defn vim_autocmd [trigger pattern func_str]
    (nvim.command (.. "au " trigger " " pattern " " func_str)))

(local keymap nvim.set_keymap)

(defn define []
    ; Defining utility functions or keymaps

    (keymap "n" "<C-t><C-s>" "a<C-R>=strftime('%Y-%m-%d %a %I:%M %p')<CR><Esc>" {}) ; Timestamp
    )
