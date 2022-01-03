# dotfiles

## 0. Prerequisites

### Xcode

Install [Xcode](https://developer.apple.com/download/more/#). Or, install Xcode Command-Line Tools with below.

```sh
xcode-select --install
```

### Homebrew

Install Homebrew. Check [here](https://brew.sh/index_ja) for the latest installation procedure.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 1. Git Clone

Clone this repository into `~/dotfiles`.

```sh
git clone https://github.com/myako10s/dotfiles.git ~/dotfiles
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

## 3. Install apps

```sh
bash ~/dotfiles/setup.sh install
```

## 4. Update Brewfile

```sh
bash ~/dotfiles/setup.sh update
```