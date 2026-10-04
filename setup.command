#!/bin/bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit 1

/bin/bash "$SCRIPT_DIR/setup.sh"
setup_status=$?

echo
if [[ "$setup_status" -eq 0 ]]; then
  echo "セットアップが完了しました。"
else
  echo "セットアップ中にエラーが発生しました（終了コード: $setup_status）。上の表示を確認してください。"
fi

read -r -p "Enterキーを押すと終了します。" || true
exit "$setup_status"
