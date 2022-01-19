# setup-osx
setup macOS

## Xcode

Xcode自体も使うので本体を[Xcode](https://developer.apple.com/download/more/#)からダウンロードしてインストール。

Xcode本体が不要な場合は以下のようにコマンドラインツールだけ入れる。

```sh
xcode-select --install
```

## Homebrew

最新のインストールコマンドは [Homebrew](https://brew.sh/index_ja) を確認すること。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## dotfiles

[dotfiles](https://github.com/myako10s/dotfiles)をセットアップする。

### dotfilesデプロイ

```sh
bash ~/dotfiles/setup.sh deploy
```

### Homebrew管理アプリインストール

不要なものがあれば適宜 Brewfile を編集してからインストール実行する。

```sh
bash ~/dotfiles/setup.sh install
```

## 各種ランタイム

ランタイムバージョン管理は asdf を使う。手順は[こちら](asdf.md)を参照。

環境移行時は前の手順までで asdf のインストールと `.tool-versions` の配置も終わってるはずなので、以下コマンドでランタイムをまとめてインストールできる、はず。

```sh
asdf install
```

## 環境維持

### HomeBrew関連

```sh
# Homebrew更新
brew update

# Homebrew管理アプリの更新
brew upgrade --greedy

# 古くなったパッケージ確認
brew outdated

# インストール済みアプリの表示
brew list

# インストール済み AppStoreアプリの表示
mas list

# 更新などの診断
brew doctor

# Brewfile更新
bash ~/dotfiles/setup.sh update
```

### ランタイム関連

asdfコマンド例は[こちら](asdf.md)を参照。

```sh
# asdfの更新 (Homebrewでインストールしているので asdf update は無効)
brew upgrade asdf

# シンボリックリンク再作成
asdf reshim [<plugin name>] [<version>]

# プラグイン更新 -> 最新バージョンがリストに出てこない時などに使う
asdf plugin-update {<plugin name> [git-ref] | --all}

# インストールしたパッケージの更新
# 勝手に更新されない（そりゃそうだ）ので、必要に応じて instal して global/local でセッティングする。
# 古いバージョンが不要になったら uninstall する。

```

## その他設定

vscodeの設定は dotfiles ではなく標準装備された同期機能を使う。
設定から同期を有効にして github アカウントで認証、画面に従って認証トークンを vscode に貼り付けて完了。

スクリーンショットの保存先変更

```sh
defaults write com.apple.screencapture location ~/Pictures/screenshots
killall SystemUIServer
```

## TODO

* ~~dotfiles と setup-osx を1つにまとめてもいいかも・・・こだわりすぎない方がよさそう~~
* ~~dotfiles は 直下の .??* しか対応してなくて .git/config/ignore とか未対応。これを対応させようとなると結局アプリ毎にコマンドで組むことになりそう~~
* docker, lima
* ~~ruby とか python とか node とか~~
* ~~anyenv って？他にもいいのありそう~~
* ~~asdf で java~~
* ~~asdf のところ長くなったので切り出してコンパクトにしたい（初期導入〜維持のサイクルをコンパクトにって意味）~~
* dotfiles の更新アラートもほしいね（参考に例あり）
* iTerm2 ってそんなにいいんか
* fish ってそんなにいいんか
* Homebrew の依存関係の調べ方（いらないもの消したいとき用）
  * asdf入れたら（ってかasdf経由の Node.js）たくさん依存パッケージ入れる羽目になったので
  * `brew info <package>` で見れそうだが1つ1つはしんどいな
    * deps とか uses があるらしい。 https://qiita.com/shge/items/39e0e5cd83642c5d4add
    * 依存関係で入ったパッケージは Brewfile には出てこないので支障はなかった
* ~~Homebrew で入れた python アンインストール~~

## 参考

ほぼそのまま使わせてもらった

https://github.com/yoskeoka/setup-osx
https://github.com/yoskeoka/dotfiles

dotfiles の更新忘れを防いで継続的に管理していく

https://korosuke613.hatenablog.com/entry/2021/05/23/mydotfiles
https://github.com/korosuke613/dotfiles

make 美しい

https://github.com/MagicalLiebe/dotfiles

lima + docker

https://qiita.com/yoichiwo7/items/44aff38674134ad87da3

iTerm2

https://bottoms-programming.com/archives/mac-terminal-to-iterm2.html

