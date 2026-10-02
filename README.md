# mac-setup

複数のMacに、研究・開発・AIハンズオン用の基本環境をまとめて導入するセットアップ一式です。

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

### VPN
- WireGuard CLI (`wg`, `wg-quick`)
- WireGuard公式macOSアプリ
  - App Storeから `mas` を使って自動導入を試みます
  - Mac App Storeに未ログインの場合は、GUIアプリだけ手動導入が必要です

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
- dockutil

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

また、「最近使ったアプリをDockに表示」をOFFにして、余計なアプリアイコンが自動で増えにくい状態にします。

macOS 25以前で `Apps.app` が存在しない場合は、可能ならLaunchpadを代わりに追加します。

## 使い方

このリポジトリを取得して、通常ユーザーのターミナルから以下を実行します。

```bash
git clone https://github.com/Taka-cst/mac-setup.git
cd mac-setup
chmod +x setup.sh check.sh
./setup.sh
```

Homebrewが入っていなければ、公式インストーラから自動で導入します。

セットアップ確認:

```bash
./check.sh
```

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

### WireGuard

各Macに使用するWireGuard設定をインポートしてください。

**秘密鍵や実際のWireGuard設定ファイルを、この公開リポジトリへ直接入れないでください。**

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
