# asdf
asdf によるランタイム管理

## 各種ランタイム

ランタイムバージョン管理は asdf を使う。

インストール

```sh
brew install asdf
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.bash_profile
echo -e "\n. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash" >> ~/.bash_profile
exec $SHELL -l
```

プラグイン追加

```sh
# Node.js
asdf plugin-add nodejs

# Python
asdf plugin-add python
asdf plugin-add poetry

# Java
asdf plugin-add java
```

プラグインによっては依存パッケージの追加インストールが必要。以下は [nodejs](http://asdf-vm.com/guide/getting-started.html#plugin-dependencies) の場合。
```sh
brew install gpg gawk
```

[Python](https://github.com/pyenv/pyenv/wiki#suggested-build-environment) の場合。公式の案内の通りにすると openssl は3系が入ってしまうので1.1を明示的に指定した。
```sh
brew install openssl@1.1 readline sqlite3 xz zlib
```

### Node.js

```sh
# LTS(16.x)をインストールしてグローバルに設定
asdf install nodejs lts-gallium
asdf global nodejs lts-gallium

# 某アプリ用に 10.8 をインストールしてローカルに設定
asdf install nodejs 10.8.0
cd ~/some-app
asdf local nodejs 10.8.0

# バージョン確認
node --version # v10.8.0
npm --version  # 6.2.0
cd
node --version # v16.13.1
npm --version  # 8.1.2
```

### Python

MacOS ではビルドに失敗する例が多い模様。今回遭遇したのは binutils が入っているとビルドに失敗するってやつ（2022/1/3時点。MacOS 12.1/Intel)。

see）https://github.com/pyenv/pyenv/wiki/Common-build-problems#macos-ld-symbols-not-found-for-architecture-x86_64-1245

一時的に PATH から binutils を除外してからインストールする。

```sh
export PATH=xxx (binutilsを除外したパス)

# latest をインストールしてグローバルに設定
asdf install python latest
asdf global python latest

# バージョン確認
python -V   # Python 3.10.1　←今入れたやつ
python3 -V  # Python 3.10.1　←今入れたやつ
python2 -V  # Python 2.7.18　←MacOS付属のやつ

# poetry をインストールしてグローバルに設定
asdf install poetry 1.2.0a2
asdf global poetry 1.2.0a2
# latest指定で安定版最新の 1.1.12 がインストールできたが、1.2.0以降には自動更新されないらしいってのと、インストールしても動かなかった（poetry --version してもエラー）ため、アルファ版だけど最新の 1.2系を入れた

# バージョン確認
poetry --version # Poetry (version 1.2.0a2)

# 補完設定
# https://python-poetry.org/docs/#enable-tab-completion-for-bash-fish-or-zsh
poetry completions bash > $(brew --prefix)/etc/bash_completion.d/poetry.bash-completion
# 2022/1/5現在、これは動かない。1.2.0a2 のバグらしい。
# https://githubmate.com/repo/python-poetry/poetry/issues/4572
```

poetry設定

この変更により仮想環境がプロジェクトの .venv 配下に作成されるようになるので、VSCodeで実行環境を指定できるようになる。

```sh
poetry config virtualenvs.in-project true
```

※XDGへの対応が不完全なのか設定ファイルは `~/.config` ではなく `~/Library/Application Support` に作成される。

`.config` に入るようになったら dotfiles で管理しよう。

補足1）公式にあった[パッチ当て](https://github.com/danhper/asdf-python#install-with---patch)はしなかった。当てると上記の binutils のエラーとは別のエラーが出ていたため。binutils 問題回避した状態では試していない。

補足2）他、以下のような CFLAGS とか LDFLAGS の指定でビルドエラー解消との情報もあったが今回は binutils の対処のみでビルドできた。

```sh
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export CFLAGS="-I$(xcrun --show-sdk-path)/usr/include"
export CFLAGS="-I$(brew --prefix readline)/include $CFLAGS"
export LDFLAGS="-L$(brew --prefix readline)/lib $LDFLAGS"
export CFLAGS="-I$(brew --prefix openssl)/include $CFLAGS"
export LDFLAGS="-L$(brew --prefix openssl)/lib $LDFLAGS"
export CFLAGS="-I$(brew --prefix sqlite)/include $CFLAGS"
export LDFLAGS="-L$(brew --prefix sqlite)/lib $LDFLAGS"
export CFLAGS="-I$(brew --prefix zlib)/include $CFLAGS"
export LDFLAGS="-L$(brew --prefix zlib)/lib $LDFLAGS"
```

### Java

MacOS の場合は以下の設定を入れておくことで、インストール時に `/usr/libexec/java_home` にも設定される。

see) https://github.com/halcyon/asdf-java#java_home-integration

```sh
java_macos_integration_enable = yes
```

```sh
# LTS(11.x)をインストールしてグローバルに設定
asdf latest java adoptopenjdk-11  # adoptopenjdk-11.0.13+8
asdf install java latest:adoptopenjdk-11
asdf global java latest:adoptopenjdk-11

# JAVA_HOME設定
echo -e "\n# To set JAVA_HOME\n. ~/.asdf/plugins/java/set-java-home.bash"
exec $SHELL -l
# ↑ コレ、cd する度に JAVA_HOME を設定し直しているっぽくて cd がめっちゃ遅くなる。。。
# 遅くなるから慎重にってコメントも出てたのに。。。
# 普段java使わないなら無効にしておくのがよい

# バージョン確認
java -version
# openjdk version "11.0.13" 2021-10-19
# OpenJDK Runtime Environment Temurin-11.0.13+8 (build 11.0.13+8)
# OpenJDK 64-Bit Server VM Temurin-11.0.13+8 (build 11.0.13+8, mixed mode)
```

### asdf設定

デフォルトでは `.tool-versions` を参照するが、`.node-version` なども読み込むようにするには `$HOME/.asdfrc` に以下を設定する。

```sh
legacy_version_file = yes
```

### asdfコマンド例

```sh
## プラグイン関連
# インストール済みプラグイン一覧表示
asdf plugin-list

# インストール可能なプラグイン一覧表示
asdf plugin-list-all

# プラグイン追加/削除
asdf plugin-add <plugin name> [<git-url>]
asdf plugin-remove <plugin name>

# プラグイン更新 -> 最新バージョンがリストに出てこない時などに使う
asdf plugin-update {<plugin name> [git-ref] | --all}

## パッケージ関連
# カレントディレクトリで有効なバージョンを表示
asdf current [<plugin name>]

# インストール済みバージョン表示
asdf list <plugin name>

# インストール可能なバージョン一覧表示
asdf list-all <plugin name>

# 最新の安定バージョン表示　※補完候補に出てこない
asdf latest <plugin name> [<version>]

# インストール/アンインストール
asdf install <plugin name> <version>
asdf uninstall <plugin name> <version>

# .tool-versions にあるパッケージをインストール
asdf install

# インストール済みバージョンをグローバルに設定
asdf global <plugin name> <version>
asdf global <plugin name> latest[:<version>]

# インストール済みバージョンをローカルに設定
asdf local <plugin name> <version>
asdf local <plugin name> latest[:<version>]

# ランタイム/コマンドのパス表示
asdf where <plugin name>
asdf which <command>

## その他
# asdfのバージョン、インストール済みプラグインなどを表示
asdf info

# シンボリックリンク再作成
asdf reshim [<plugin name>] [<version>]

# asdfの更新
# Homebrewでインストールした場合はこのコマンドは無効化されているので brew upgrade asdf する。
asdf update
```

`$HOME/.tool-versions` を dotfiles で管理して `asdf install` すればまとめてランタイムのセットアップができそうですな！
