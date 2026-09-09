#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${HOME}/.codex/skills"
DRY_RUN=0
AGENT_DOCS="write"

usage() {
  cat <<'USAGE'
Usage: bash scripts/install.sh [--target DIR] [--dry-run] [--agent-docs write|skip]

Copies public utility skills into a local skills directory.
Default target: $HOME/.codex/skills

After install, invoke the stack with:
  use utility skills stack
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="${2:?missing --target value}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --agent-docs)
      AGENT_DOCS="${2:?missing --agent-docs value}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "install: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$AGENT_DOCS" in
  write|skip) ;;
  *)
    echo "install: --agent-docs must be write or skip" >&2
    exit 2
    ;;
esac

validate_target() {
  case "$TARGET" in
    ""|"/"|"$HOME"|"$HOME/"|".")
      echo "install: refusing unsafe --target: $TARGET" >&2
      exit 2
      ;;
  esac
}

safe_replace_dir() {
  local src="$1"
  local dst="$2"
  local parent
  local backup

  parent="$(dirname "$dst")"
  case "$dst" in
    "$TARGET"/*) ;;
    *)
      echo "install: refusing to write outside target: $dst" >&2
      exit 2
      ;;
  esac

  mkdir -p "$parent"
  backup="${dst}.bak.$$"
  if [[ -e "$dst" ]]; then
    mv "$dst" "$backup"
  fi
  cp -R "$src" "$dst"
  if [[ -e "$backup" ]]; then
    rm -R "$backup"
  fi
}

copy_skill() {
  local skill="$1"
  local src="$ROOT/skills/$skill"
  local dst="$TARGET/$skill"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "would copy $src -> $dst"
  else
    safe_replace_dir "$src" "$dst"
    echo "installed $skill -> $dst"
  fi
}

write_agent_docs() {
  local doc="$PWD/AGENTS.md"
  local block="$ROOT/agent-docs/AGENTS.managed-block.md"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "would update managed block in $doc"
    return
  fi

  if [[ ! -f "$doc" ]]; then
    cp "$block" "$doc"
    echo "created $doc"
    return
  fi

  python3 - "$doc" "$block" <<'PY'
from pathlib import Path
import sys

doc = Path(sys.argv[1])
block = Path(sys.argv[2]).read_text()
text = doc.read_text()
start = "<!-- BEGIN UTILITY_SKILLS -->"
end = "<!-- END UTILITY_SKILLS -->"

if start in text and end in text:
    before = text.split(start, 1)[0]
    after = text.split(end, 1)[1]
    doc.write_text(before + block + after)
else:
    sep = "" if text.endswith("\n") else "\n"
    doc.write_text(text + sep + "\n" + block + "\n")
PY
  echo "updated managed block in $doc"
}

validate_target
copy_skill figma-mcp-free
copy_skill figma-diagram-visualization
copy_skill free-seo-stack
copy_skill pdf-signing
copy_skill youtube-transcribe
copy_skill zoom-host
copy_skill remote-mac-access
copy_skill talk-deck-builder
copy_skill n8n-temp-cleanup
copy_skill pantheon-style

if [[ "$AGENT_DOCS" == "write" ]]; then
  write_agent_docs
else
  echo "agent docs skipped"
fi

echo "install: OK"
cat <<'NEXT'

Next steps:
  1. In your agent chat, say: use utility skills stack
  2. For Figma diagrams, say: use figma mcp free
  3. For SEO audit, say: use free seo stack
  4. For PDF signing, say: use pdf signing
  5. For YouTube transcription, say: use youtube transcribe
  6. For Zoom meetings, say: use zoom host
  7. For remote Mac access, say: use remote mac access
  8. For talk decks, say: use talk deck builder
  9. For n8n cleanup, say: use n8n temp cleanup

Optional:
  - Add your own trigger phrase by editing the managed AGENTS.md block.
NEXT
