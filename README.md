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
<C-o> is shorthand for Ctrl + 'o'


Neo-tree
? - help
Shift <,> - switch between panels Files, Buff, Git
Shift H,L - switch between neo-tree and the file windows
<Leader-e> - toggle neo-tree open/close

Splits happen
:on - only, close all other splits
Ctrl c - close the current split

Plugins
What plugins do I have installed? What version?
:Lazy
Shows a list, hover over any one and hit enter to see the version and details

