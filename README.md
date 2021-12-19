# dotfiles

## 1. Git Clone

Clone this repository into `~/dotfiles`

```sh
git clone https://github.com/myako10s/dotfiles.git ~/dotfiles
```

## 2. Deploy dotfiles

```sh
# Do not override existing dotfiles
bash ~/dotfiles/setup.sh deploy

# Force override existing dotfiles
bash ~/dotfiles/setup.sh -f deploy
```
