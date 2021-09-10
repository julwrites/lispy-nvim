(module nvim-config.options
        { autoload {nvim aniseed.nvim}})

; Bind nvim set_keymap to a more concise key
(local keymap nvim.set_keymap)

(defn define []
    ; Some notes on options:
    ; Quite a number of options are available through nvim, and therefore through aniseed

    ; The most direct way to call older settings though, is just to use `nvim.command` and pass the command as a string
    ; This pretty much always works, but is generaly not preferred

    ; Display row number
    (set nvim.wo.number true)
    (nvim.command ":set nowrap")

    (set nvim.g.autoread true)

    (set nvim.g.showcmd true)
    (set nvim.g.showmatch true)
    (set nvim.g.showmode true)

    (set nvim.o.autoindent true)
    (set nvim.o.smarttab true)
    (set nvim.o.expandtab true)
    (set nvim.o.tabstop 2)
    (set nvim.o.shiftwidth 2)
)
