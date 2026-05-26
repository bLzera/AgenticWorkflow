#!/usr/bin/env bash
#
# crew/run-lint.sh — roda o lint SOMENTE nos arquivos que o épico tocou.
#
# Por quê só os arquivos do épico: o repo pode ter dívida técnica pré-existente, então
# exigir "zero problemas no repo inteiro" nunca passaria. O gate real é "o épico não
# introduz problemas nos arquivos que altera".
#
# TODO: ajuste as variáveis abaixo para o seu projeto.
#
# FILE_PATTERN: glob para filtrar os arquivos relevantes do diff
#   Exemplos: 'backend/**/*.rb', 'src/**/*.ts', '**/*.py', 'src/**/*.go'
#
# LINT_CMD: comando de lint a executar com a lista de arquivos como argumento
#   Exemplos:
#     bundle exec rubocop          (Ruby)
#     npx eslint                   (JS/TS)
#     flake8                       (Python)
#     golangci-lint run            (Go — recebe os arquivos via stdin ou args)
#
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"

# TODO: ajuste para o padrão de arquivos do seu projeto
FILE_PATTERN='src/**/*'

# TODO: ajuste para o comando de lint do seu projeto
LINT_CMD='echo "[run-lint] TODO: configure LINT_CMD neste script." && exit 1'

mapfile -t CHANGED < <(git -C "$ROOT" diff --name-only main...HEAD -- "$FILE_PATTERN")

if [ "${#CHANGED[@]}" -eq 0 ]; then
  echo "[run-lint] nenhum arquivo alterado pelo épico — nada a lintar."
  exit 0
fi

echo "[run-lint] lintando ${#CHANGED[@]} arquivo(s) do épico:"
printf '  - %s\n' "${CHANGED[@]}"

exec $LINT_CMD "${CHANGED[@]}"
