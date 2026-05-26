# Protocolo do Orquestrador

Quando o usuário pedir "implementa o épico X", execute os passos abaixo em ordem.

---

## Pré-condições (preflight)

1. **Resolver a raiz do projeto de forma portável.** Nunca use paths absolutos hard-coded.
   ```bash
   ROOT="$(git rev-parse --show-toplevel)"
   ```
   Se o comando falhar, **aborte** e reporte ao usuário. Todos os comandos abaixo usam `"$ROOT/..."`.

2. **Sanidade do checkout:**
   ```bash
   test -f "$ROOT/CLAUDE.md" && test -d "$ROOT/crew"
   ```
   Se falhar, aborte.

3. **Suba o ambiente local** se o projeto exigir (ex: banco via Docker). Consulte o CLAUDE.md do projeto.

4. **Branch atual é `main` e está limpa:**
   ```bash
   git status
   ```

5. **Carregar contexto do projeto:** ler `crew/project.md` inteiro e manter em memória — esse conteúdo
   será injetado como `{{STACK_CONTEXT}}` nos prompts do Developer e do Reviewer.

---

## Passo 1 — Carregar contexto do épico

1. Ler `crew/epics/<X>.md` (spec completa do épico)
2. Ler todos os arquivos listados na seção "Arquivos a ler" do epic file
3. Criar a branch do épico:
   ```bash
   git checkout -b epic/<X>
   ```

---

## Passo 2 — Spawnar Developer Agent

Construir o prompt preenchendo `crew/prompts/developer.md` com:

- `{{STACK_CONTEXT}}` → conteúdo completo de `crew/project.md` (lido no preflight)
- `{{EPIC_ID}}` → ex: `B-2`
- `{{EPIC_SPEC}}` → spec do épico
- `{{FILES_TO_READ}}` → **apenas a lista de paths** do epic file (não cole o conteúdo — o Developer abre cada arquivo com `Read` por conta própria)
- `{{FILES_TO_CREATE_OR_MODIFY}}` → lista do epic file
- `{{ACCEPTANCE_CRITERIA}}` → critérios do epic file
- `{{RETRY_CONTEXT}}` → vazio na primeira tentativa; nos retries, incluir o output de erro

Spawnar com `Agent(subagent_type="general-purpose", prompt=<prompt_preenchido>)`.

O agente implementa o código e os specs. **Não commita, não roda testes.**

**Sobre retries:** cada retry spawna um Developer Agent **novo**. No retry, o prompt deve ser
**enxuto**: apenas o `{{RETRY_CONTEXT}}` (output cru de testes/lint ou feedback humano) +
o `{{EPIC_ID}}` + instrução para ler a branch atual com `Read`/`git diff`. Não re-cole todo
o contexto do primeiro spawn — o código já está na branch e o agente o lê sozinho.

---

## Passo 3 — Rodar testes

```bash
"$(git rev-parse --show-toplevel)/crew/run-tests.sh" 2>&1
```

- **Passou (exit 0):** ir para o Passo 4
- **Falhou:** incrementar `attempts`. Se `attempts < 3`, voltar ao Passo 2 com o output em `{{RETRY_CONTEXT}}`. Se `attempts >= 3`, ir para **Abort**.

---

## Passo 4 — Rodar lint

```bash
"$(git rev-parse --show-toplevel)/crew/run-lint.sh" 2>&1
```

O script de lint deve checar **apenas os arquivos que o épico alterou** (diff `main...HEAD`).
Isso é proposital: o gate é *"o épico não introduz problemas no que toca"*, não *"zero problemas no repo"*.

- **Limpo (exit 0):** ir para o Passo 5
- **Com problemas:** incrementar `attempts`. Se `attempts < 3`, voltar ao Passo 2 com o output em `{{RETRY_CONTEXT}}`. Se `attempts >= 3`, ir para **Abort**.

---

## Passo 5 — Spawnar Reviewer Agent (opcional)

Para épicos simples o orquestrador pode revisar diretamente.
Para épicos complexos, spawnar o Reviewer Agent.

Antes de qualquer coisa, garanta que arquivos novos (untracked) entrem no diff:
```bash
git add -A
git diff main...HEAD
```

Construir o prompt preenchendo `crew/prompts/reviewer.md` com:
- `{{STACK_CONTEXT}}` → conteúdo de `crew/project.md` (já em memória do preflight)
- `{{EPIC_ID}}` → ex: `B-2`

O Reviewer Agent roda `git diff main...HEAD` e lê os arquivos no disco por conta própria —
**não** cole o diff no prompt.

Spawnar com `Agent(subagent_type="general-purpose", prompt=<prompt_preenchido>)`.

- **Output "APROVADO":** ir para o Passo 6
- **Output "REPROVADO: ...":** incrementar `attempts`. Se `attempts < 3`, voltar ao Passo 2 com o feedback em `{{RETRY_CONTEXT}}`. Se `attempts >= 3`, ir para **Abort**.

---

## Passo 6 — Checkpoint humano

Mostrar o diff para o usuário (com `git add -A` já feito no Passo 5):
```bash
git diff main...HEAD
```

Perguntar: "O diff está aprovado para commit e merge?"

- **Aprovado:** ir para o Passo 7
- **Rejeitado com feedback:** incrementar `attempts`. Se `attempts < 3`, voltar ao Passo 2 com o feedback em `{{RETRY_CONTEXT}}`. Se `attempts >= 3`, ir para **Abort**.

---

## Passo 7 — Commit, merge e cleanup

### Commit na branch do épico

```bash
cd "$(git rev-parse --show-toplevel)"
git add <arquivos_listados_pelo_developer>
git commit -m "feat: <descrição gerada pelo developer — uma linha>"
```

### Merge para main

```bash
git checkout main
git merge --no-ff epic/<X> -m "Merge epic/<X>"
git branch -d epic/<X>
```

### Atualizar CLAUDE.md

Marcar o épico como concluído no backlog do `CLAUDE.md`.

---

## Projetos multi-stack

Se o projeto tiver múltiplos stacks (ex: backend + frontend), configure scripts separados por stack:

- `crew/run-tests-<stack>.sh` e `crew/run-lint-<stack>.sh`
- Indique no arquivo do épico qual par de scripts usar
- O orquestrador substitui `run-tests.sh`/`run-lint.sh` pelos scripts da stack do épico nos Passos 3 e 4

---

## Abort

Se `attempts >= 3` em qualquer etapa:

1. Reportar ao usuário: qual etapa falhou, qual foi o último erro
2. Fazer checkout de volta para main:
   ```bash
   git checkout main
   git branch -D epic/<X>
   ```
3. **Não commitar nada.**

---

## Contador de attempts

| Evento que incrementa          | Limite         |
|-------------------------------|----------------|
| Testes falharam               | 3 total        |
| Lint com problemas            | 3 total (compartilhado) |
| Reviewer reprovou             | 3 total (compartilhado) |
| Usuário rejeitou no checkpoint | 3 total (compartilhado) |
