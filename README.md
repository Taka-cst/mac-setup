# mac-setup

複数のMacに、研究・開発・AIハンズオン用の基本環境をまとめて導入するセットアップ一式です。

既に一部のHomebrewパッケージやアプリが入っているMacでも、そのまま `setup.sh` を実行できます。
不足分は追加され、Homebrew管理対象は通常どおり更新され、Dockは指定した構成に整理されます。

## 入るもの

### 開発環境
- Homebrew
- Git
- GitHub CLI (`gh`)
- Git LFS
- Python
- Node.js
- `uv`
- OpenCode

### GUI
- Visual Studio Code
- Slack
- OrbStack
- Notion
- Zoom
- Box Drive
- Adobe Acrobat Reader
- ChatGPT
- Claude

### CLI
- jq / yq
- ripgrep
- fd
- fzf
- bat
- tree
- wget
- htop
- tmux
- shellcheck
- nmap

### VS Code extensions
- Python
- Remote - SSH
- Prettier
- ESLint

## Dock

セットアップ時にDockを整理して、AIハンズオンで使うアプリを見つけやすくします。

macOS 26 Tahoeでは次の順序になります。

```text
Finder
Apps
Safari
Slack
Notion
Zoom
Visual Studio Code
ChatGPT
Claude
```

Finderとゴミ箱はmacOSが管理する特殊なDock項目です。
`setup.sh` は通常のDock項目を一度削除したあと、上記のアプリを順番に追加します。

「最近使ったアプリをDockに表示」はOFFにします。

Dock編集には `dockutil` を使いますが、これは常設しません。

```text
setup.sh
  ↓
dockutil を一時インストール
  ↓
Dockを再構成
  ↓
dockutil をアンインストール
```

もともと端末に `dockutil` が入っていた場合だけは、既存環境を壊さないため削除しません。

macOS 25以前で `Apps.app` が存在しない場合は、可能ならLaunchpadを代わりに追加します。

## 使い方

```bash
git clone https://github.com/Taka-cst/mac-setup.git
cd mac-setup
chmod +x setup.sh check.sh
./setup.sh
```

Homebrewが入っていなければ、公式インストーラから自動で導入します。

既にHomebrewが入っているMacでは、その環境を使って `brew update` と `brew bundle` を実行します。
`--no-upgrade` は指定していないため、通常のHomebrew Bundleの更新動作を維持しています。

セットアップ確認:

```bash
./check.sh
```

### デスクトップにコピーするファイル

`setup.sh` と同じ場所にある `toDesktop/` に、コピーしたいファイルやフォルダを入れてください。
セットアップ時に、その中身をフォルダ構成や隠しファイルも含めて `~/Desktop/` へコピーします。
同名のファイルは上書きされます。`toDesktop/` が空の場合は何もコピーせず、存在しない場合は空のフォルダを作成します。

`toDesktop/` はGit管理の対象外なので、中身はGitHubへpushされません。clone後は必要なファイルを各自で入れてください。

## セットアップ後に各自で行うこと

### GitHub

```bash
gh auth login
```

Gitの名前とメールアドレスを設定する場合:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### 各GUIアプリ

Slack / Notion / Zoom / ChatGPT / Claude は、必要に応じて各自ログインしてください。

OrbStackは初回だけ起動して初期セットアップを完了してください。

## 構成

```text
mac-setup/
├── Brewfile
├── setup.sh
├── check.sh
└── README.md
```
