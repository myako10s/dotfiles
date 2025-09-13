# dotfiles

## 0. Prerequisites

### Xcode

Install [Xcode](https://developer.apple.com/download/more/#). Or, install Xcode Command-Line Tools with below.

```sh
xcode-select --install
```

> [!NOTE]
> Even if Xcode is installed, the command line tools are installed within the Homebrew installation.

### Homebrew

Install Homebrew. Check [here](https://brew.sh/ja/) for the latest installation procedure.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 1. Git Clone

Clone this repository into `~/dotfiles`.

```sh
git clone https://github.com/myako10s/dotfiles.git ~/.dotfiles.git
```

## 2. Deploy dotfiles

Do not override existing dotfiles.

```sh
bash ~/dotfiles/setup.sh deploy
```

Force override existing dotfiles.

```sh
bash ~/dotfiles/setup.sh -f deploy
```

> [!NOTE]
> Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting to load these completions, you may need to run this, and see also `compaudit`:
```sh
chmod -R go-w /opt/homebrew/share
```

## 3. Install apps

Install Rosetta

```sh
sudo softwareupdate --install-rosetta
```

Install brew apps

```sh
bash ~/dotfiles/setup.sh install
```

## 4. Update Brewfile

```sh
bash ~/dotfiles/setup.sh update
```
