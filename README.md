# .cfg
Configuration .dotfiles

## Starting from scratch

If you haven't been tracking your configurations in a Git repository before, you can start using this technique easily with these lines:

```bash
git init --bare $HOME/.cfg
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
cfg config --local status.showUntrackedFiles no
echo "alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.zshrc
```

- The first line creates a folder `~/.cfg` which is a Git [bare repository](https://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/) that will track our files.
- Then we create an alias `cfg` which we will use instead of the regular `git` when we want to interact with our configuration repository.
- We set a flag - local to the repository - to hide files we are not explicitly tracking yet. This is so that when you type `cfg status` and other commands later, files you are not interested in tracking will not show up as `untracked`.
- Also you can add the alias definition by hand to your `.zshrc` or use the the fourth line provided for convenience.

After you've executed the setup any file within the `$HOME` folder can be versioned with normal commands, replacing `git` with your newly created `cfg` alias, like:

```bash
cfg status
cfg add .vimrc
cfg commit -m "Add vimrc"
cfg add .zshrc
cfg commit -m "Add zshrc"
cfg push
```

## Install your dotfiles onto a new system (or migrate to this setup)

> ProTip :fire:: Use a script like [mine](https://files.imranc.io/static/cfg/clone) to setup new system automatically (and skip all remaining steps):
```bash
bash <(curl -s https://files.imranc.io/static/cfg/clone)
```

If you already store your configuration/dotfiles in a Git repository, on a new system you can migrate to this setup with the following steps:

- Prior to the installation make sure you have committed the alias to your `.zsh`:

```bash
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

- And that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:

```bash
echo ".cfg" >> .gitignore
```

- Now clone your dotfiles into a bare repository in a "dot" folder of your `$HOME`:

```bash
git clone --bare https://github.com/imrancio/.cfg.git $HOME/.cfg
# or git clone --bare git@github.com:imrancio/.cfg.git $HOME/.cfg
```

- Define the alias in the current shell scope:

```bash
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

- Checkout the actual content from the bare repository to your `$HOME`:

```bash
cfg checkout
```

- The step above might fail with a message like:

```bash
error: The following untracked working tree files would be overwritten by checkout:
    .zshrc
    .gitignore
Please move or remove them before you can switch branches.
Aborting
```

This is because your `$HOME` folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder:

```bash
mkdir -p .cfg-backup && \
cfg checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .cfg-backup/{}
```

- Re-run the check out if you had problems:

```bash
cfg checkout
```

- Set the flag `showUntrackedFiles` to `no` on this specific (local) repository:

```bash
cfg config --local status.showUntrackedFiles no
```

- You're done, from now on you can now type `cfg` commands to add and update your dotfiles:

```bash
cfg status
cfg add .vimrc
cfg commit -m "Add vimrc"
cfg add .bashrc
cfg commit -m "Add bashrc"
cfg push
```
