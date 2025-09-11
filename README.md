# AstroNvim Template

**NOTE:** This is for AstroNvim v5+
A template for getting started with [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 🛠️ Installation

Installing this configuration on a new system

1. Clone the repo

```sh
git clone https://github.com/natomato/astronvim_v5 ~/.config/nvim
```

2. Initialize AstroNvim

```sh
nvim --headless -c 'quitall'
```

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

## Basic Usage Notes

Notation:
`<C-o>` is shorthand for Ctrl + 'o': jump to previous location

Neo-tree
`?` - help
`Shift <,>` - switch between panels Files, Buff, Git
`Shift H,L` - switch between neo-tree and the file windows
`<Leader-e>` - toggle neo-tree open/close

Splits happen
`:on` - only, close all other splits
`<C-c>` - close the current split

Plugins
What plugins do I have installed? What version?
`:Lazy`
Shows a list, hover over any one and hit enter to see the version and details

Custom Keymaps
`<Leader>n`: Review Missed Notifications

## Changes from v4 to v5

telescope is replaced with Snacks.picker: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

auto format on save is default and provides a filter function
https://docs.astronvim.com/recipes/advanced_lsp/#disabling-formatting-for-a-filter-function

this is probably the way to prevent denols and ts_ls from both attaching to the same buffer

## Troubleshooting

Ask claude.

These commands were once useful

```sh
:lua vim.print(vim.diagnostic.get(0))
```

## Errors and Hacks

#### Selene

Mason install will add selene on start of astronvim.
I dont know how to stop this behavior.
Everytime it installs selene, I will get an error from null-ls when loading a lua file.
However, if i use the binary installed from `brew` selene works as expected, without a null-ls error notification.

```sh
brew install selene
selene <some_lua_file>
which selene
```

My solution is to trick Mason into thinking it installed selene, but symlink to the brew installed version instead.
This is achieved by letting Mason install selene, then cd into

```
cd ~/.local/share/nvim/mason/bin
ln -s "/usr/local/bin/selene" ./selene
```
