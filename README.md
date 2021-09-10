# lispy-nvim
Modern Neovim configuration that bootstraps itself to be lispy

## Motivation
The original motivation of this configuration was, as much as possible, to use Neovim packages written in Lua, both for the speed boost, and for the modern features. At the same time, the goal was to have a Neovim configuration written largely - if not entirely - in a Lisp (in this case, [Fennel](https://fennel-lang.org)), so that I could learn Lisp. 

During this foray, I quickly discovered that there were not many configurations available for reference, and the ones that were written were by Lisp experts, which were quite overwhelming for a Lisp newbie. 

As such, after struggling through the process and coming to a point where I was somewhat happy with my configuration as a starting point, I decided to freeze it, document it, and move it over to Github so that others who want to do the same can have some reference. 

I will continue to update this configuration as the ecosystem improves. 

## Requirements
This configuration attempts to be modern, lispy, and as independent as reasonably possible. 
- Neovim >0.5; several key features around using Lua are dependent on it
- Git; bootstrapping requires some way to get the necessary packages, in this case we use Git

## Usage
Clone this repository and drop it into
`~/.config/nvim` on MacOS or Linux
`%localappdata%/nvim` on Windows

The configuration proper is defined in, and loaded from `/fnl/nvim-config`, with the entry point being `fnl/nvim-config/init.fnl`.

## Walkthrough

For those who are new to Neovim, it can be quite confusing to figure out what the different files will do when Neovim loads up, and worse still when Aniseed takes over. Let's attempt to break down the black box a little. 

### Architecture
(If you can call it architecture) 

The basic structure of the configuration is as follows:
(.config/nvim)
| init.lua
| fnl
  | nvim-config
    | init.fnl
    | ...
    
As of Neovim 0.5, `init.vim` and `init.lua` are both treated as first class, and either is loaded (and accessible through $MYVIMRC) upon startup. I took advantage of this to not only upgrade ourselves to Aniseed, but also to Lua, but it should be noted that the bootstrap can also be written in VimL if you really want to. 

### Flow
When Neovim loads, it starts at `init.lua`, and here it bootstraps two things using git; [packer.nvim](https://github.com/wbthomason/packer.nvim) (For package management), and [aniseed](https://github.com/Olical/aniseed) (For Fennel compilation of the configuration). At the very end of that, it runs this line:

```
vim.g["aniseed#env"] = { module = "nvim-config.init" }
```

If you prefer to use your own Fennel module for configuration, this is the line to edit. It specifies to Aniseed to load a particular module, found in `fnl`, called `nvim-config.init`. This corresponds directly to `fnl/nvim-config/init.fnl` in this case, but could just as well correspond to `fnl/init.fnl` if you had declared the module name accordingly. 

Once Aniseed takes over, it automatically compiles all the `.fnl` files it finds, and then runs it starting from `nvim-config.init`. 

## Mentions
I relied heavily on reading through and attempting to use parts of different repositories

- [Aniseed](https://github.com/Olical/aniseed) Is the base of all the Fennel compilation in the config. I also briefly explored [hotpot.nvim](https://github.com/rktjmp/hotpot.nvim), but it had a different direction than I wanted. 
- [Conjure](https://github.com/Olical/conjure) Is a REPL for Fennel, which I used to reload my configuration on the fly, once `init.lua` was done.
- [packer.nvim](https://github.com/wbthomason/packer.nvim) Is a modern package manager for Neovim, which is written in Lua and extremely configurable. 
- [magic-kit](https://github.com/Olical/magic-kit) I initially tried this, but it was too complex for me to understand. Nonetheless, I referred to it a lot especially to get my bootstrap working. 

