# mac-setup

複数のMacに、研究・開発用の基本環境をまとめて導入するためのセットアップ一式です。

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

## 使い方

このフォルダをMacへコピーして、ターミナルで以下を実行します。

```bash
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

**秘密鍵や実際のWireGuard設定ファイルを、この共有セットアップ一式へ直接入れないでください。**

### Slack

Slackを起動して各自のアカウントでログインします。

### OrbStack

初回だけOrbStackを起動して初期セットアップを完了してください。

## 構成

```text
mac-setup/
├── Brewfile
├── setup.sh
├── check.sh
└── README.md
```

## 補足

`Brewfile` は「全Macに共通で入れるもの」に限定するのがおすすめです。
個人しか使わないアプリやCLIを追加し始めると、共通環境が肥大化します。

OrbStackが不要なら、`Brewfile` の次の行を削除またはコメントアウトしてください。

```ruby
cask "orbstack"
```

## 追加GUIアプリ

- Zoom
- Box Drive
- Adobe Acrobat Reader
- Notion
