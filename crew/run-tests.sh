#!/usr/bin/env bash
#
# crew/run-tests.sh — roda a suíte de testes do projeto.
#
# TODO: substitua o bloco abaixo pelo comando de teste do seu projeto.
#
# Exemplos por stack:
#   Rails/RSpec:  bundle exec rspec "$@"
#   Python/pytest: pytest "$@"
#   Node/Jest:    npm test -- "$@"
#   Go:           go test ./... "$@"
#   Node/Vitest:  npm run test -- "$@"
#
# O script deve:
#   - Retornar exit 0 se todos os testes passaram
#   - Retornar exit != 0 se algum teste falhou
#   - Aceitar argumentos extras para o runner de testes (ex: arquivo específico, flags de formato)
#
# Dica: se o projeto roda em Docker, siga o padrão de detecção host-vs-container:
#   if <runtime disponível no host>; then
#     <rodar no host>
#   else
#     docker compose exec -T <service> <comando>
#   fi
#
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"

echo "[run-tests] TODO: configure este script com o comando de teste do projeto."
echo "[run-tests] Consulte os comentários acima para exemplos por stack."
exit 1
