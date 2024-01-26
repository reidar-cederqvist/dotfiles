```
###################################################
____   ____   ____        _    __ _ _           
|  _ \ / ___| |  _ \  ___ | |_ / _(_) | ___  ___ 
| |_) | |     | | | |/ _ \| __| |_| | |/ _ \/ __|
|  _ <| |___  | |_| | (_) | |_|  _| | |  __/\__ \
|_| \_\\____| |____/ \___/ \__|_| |_|_|\___||___/
###################################################
```

# Disclaimer

This repository is only meant for my personal use, and come with zero guarantees. However, feel free to brows and take whatever you like to use in your own setup

This README is heavily based on a write-up by [**Nicola Paolucci**](https://www.atlassian.com/git/tutorials/dotfiles)

# How to install

start by adding an alias for config
```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```
Clone your configurations with the following command
```bash
git clone --bare <git-repo-url> $HOME/.cfg
```
Switch to the actual content from your dotfiles repository
```bash
config checkout <branch>
```
If this step fails with error message that files would be overwritten, then remove the offending files (and back them up if you care about them) and try again

Set the ``showUntrackedFiles`` flag to ``no`` on this repositories to avoid it listing every file in your home directory as untracked
```bash
config config --local status.showUntrackedFiles no
```
