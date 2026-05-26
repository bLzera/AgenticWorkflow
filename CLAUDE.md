# {{PROJECT_NAME}} — Diretrizes para Claude Code

## Fluxo de trabalho (OBRIGATÓRIO)

Quando o usuário pedir para **implementar um épico** (ex: "implementa o épico B-2", "pode fazer o X-1"), você atua como **ORQUESTRADOR**, não como implementador. Você **não escreve o código de produção nem os specs diretamente** — esse trabalho é delegado a um Developer Agent.

Antes de qualquer ação, leia `crew/orchestrator.md` e siga o protocolo descrito lá passo a passo (preflight → branch do épico → spawnar Developer Agent → testes → lint → Reviewer Agent → checkpoint humano → commit/merge). Os prompts a preencher estão em `crew/prompts/developer.md` e `crew/prompts/reviewer.md`; a spec de cada épico está em `crew/epics/<X>.md`.

Só implemente algo você mesmo quando o usuário pedir explicitamente uma tarefa fora desse fluxo (ex: um ajuste pontual, uma pergunta, um bugfix isolado).

---

## Commits

<!-- Descreva aqui a política de commits do projeto. Exemplo: -->
<!-- Nunca adicionar Co-Authored-By. O único contribuidor é o dono do repositório. -->

---

## O que é o projeto

<!-- Descrição de uma ou duas frases do que o projeto faz e para quem. -->

**Stack:** <!-- ex: Ruby on Rails 8 (API-only) + PostgreSQL + Vue 3 -->

---

## Como subir o ambiente local

<!-- Passo a passo para subir o ambiente de desenvolvimento. -->

```bash
# exemplo
cp .env.example .env
docker compose up --build
```

---

## Como rodar testes localmente

<!-- Instrução completa para rodar os testes fora do Docker (se aplicável). -->

```bash
# exemplo
bundle exec rspec --format documentation
```

---

## Lint

```bash
# exemplo
bundle exec rubocop --parallel
```

---

## Variáveis de ambiente

| Variável | Descrição |
|---|---|
| `EXEMPLO_VAR` | Descrição da variável |

---

## Estrutura do projeto

<!-- Árvore comentada dos diretórios e arquivos mais importantes. -->

```
src/
├── controllers/
├── models/
├── services/
└── ...
```

---

## Estado atual

### Implementado

| Arquivo | O que faz |
|---|---|
| `src/exemplo.rb` | Descrição |

### Em desenvolvimento / Próximo épico

<!-- Indique qual épico está em andamento ou qual é o próximo. -->

---

## Backlog MVP

| Épico | Item | Status | Descrição |
|---|---|---|---|
| A | A-1 | Pendente | Descrição |

---

## Especificação dos endpoints

<!-- Documente cada endpoint aqui para que o Orchestrator e o Developer tenham referência rápida. -->

### `GET /health`
- Auth: nenhuma
- Response 200: `{ "status": "ok" }`

---

## Decisões de arquitetura

| Decisão | Escolha | Motivo |
|---|---|---|
| Framework | ... | ... |
