#!/usr/bin/env bash
# 把本目录的 ZCode 配置安装到 ~/.zcode（同名文件会先备份）
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${ZCODE_HOME:-$HOME/.zcode}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$DEST/backup-$STAMP"

mkdir -p "$DEST/rules" "$DEST/skills"

backup() {
  local rel="$1"
  if [ -e "$DEST/$rel" ]; then
    mkdir -p "$BACKUP/$(dirname "$rel")"
    cp -a "$DEST/$rel" "$BACKUP/$rel"
    echo "  备份 $DEST/$rel -> $BACKUP/$rel"
  fi
}

echo "[*] 安装到 $DEST"
backup "AGENTS.md"
cp -a "$ROOT/AGENTS.md" "$DEST/AGENTS.md"

for f in "$ROOT"/rules/*.md; do
  backup "rules/$(basename "$f")"
done
cp -a "$ROOT/rules/." "$DEST/rules/"

for d in "$ROOT"/skills/*/; do
  name="$(basename "$d")"
  backup "skills/$name"
done
mkdir -p "$DEST/skills"
cp -a "$ROOT/skills/." "$DEST/skills/"

echo "[+] 完成。规则: $(ls "$DEST/rules" | wc -l | tr -d ' ') 个，技能: $(ls "$DEST/skills" | wc -l | tr -d ' ') 个"
[ -d "$BACKUP" ] && echo "[i] 旧文件备份在 $BACKUP"
