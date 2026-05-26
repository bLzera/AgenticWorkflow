#!/usr/bin/env bash
#
# install.sh — copia o workflow para um projeto existente.
#
# Uso: ./install.sh <path-do-projeto>
#
# O que é copiado:
#   crew/           → <projeto>/crew/
#   CLAUDE.md       → <projeto>/CLAUDE.md  (somente se não existir, a menos que --force)
#
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"

# ── argumentos ───────────────────────────────────────────────────────────────

FORCE=false
TARGET=""

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=true ;;
    *)       TARGET="$arg" ;;
  esac
done

if [ -z "$TARGET" ]; then
  echo "Uso: ./install.sh <path-do-projeto> [--force]"
  echo ""
  echo "  --force   sobrescreve crew/ e CLAUDE.md se já existirem"
  exit 1
fi

# ── validações ───────────────────────────────────────────────────────────────

if [ ! -d "$TARGET" ]; then
  echo "Erro: diretório '$TARGET' não encontrado."
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"

if [ ! -d "$TARGET/.git" ]; then
  echo "Aviso: '$TARGET' não parece ser um repositório git (sem .git)."
  read -r -p "Continuar mesmo assim? [s/N] " confirm
  [[ "$confirm" =~ ^[sS]$ ]] || exit 0
fi

# ── verificar conflitos ───────────────────────────────────────────────────────

CREW_EXISTS=false
CLAUDE_EXISTS=false

[ -d "$TARGET/crew" ]     && CREW_EXISTS=true
[ -f "$TARGET/CLAUDE.md" ] && CLAUDE_EXISTS=true

if { $CREW_EXISTS || $CLAUDE_EXISTS; } && [ "$FORCE" = false ]; then
  echo "Conflitos encontrados em '$TARGET':"
  $CREW_EXISTS   && echo "  - crew/ já existe"
  $CLAUDE_EXISTS && echo "  - CLAUDE.md já existe"
  echo ""
  echo "Use --force para sobrescrever, ou remova os arquivos manualmente."
  exit 1
fi

# ── copiar ────────────────────────────────────────────────────────────────────

echo "Instalando workflow em '$TARGET'..."

cp -r "$SRC/crew" "$TARGET/"
echo "  ✔ crew/ copiado"

if [ "$CLAUDE_EXISTS" = false ]; then
  cp "$SRC/CLAUDE.md" "$TARGET/CLAUDE.md"
  echo "  ✔ CLAUDE.md copiado"
elif [ "$FORCE" = true ]; then
  cp "$SRC/CLAUDE.md" "$TARGET/CLAUDE.md"
  echo "  ✔ CLAUDE.md sobrescrito (--force)"
fi

# ── próximos passos ───────────────────────────────────────────────────────────

echo ""
echo "Pronto. Próximos passos:"
echo "  1. Preencha crew/project.md com a stack e convenções do projeto"
echo "  2. Preencha os checklists em crew/prompts/reviewer.md"
echo "  3. Configure crew/run-tests.sh e crew/run-lint.sh"
echo "  4. Preencha CLAUDE.md com o contexto do projeto"
