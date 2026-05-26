# AgenticWorkflow

Template de workflow multi-agente para Claude Code. Permite implementar épicos de forma
orquestrada: um Orchestrator delega a implementação para um Developer Agent, valida com
testes e lint, e opcionalmente passa por um Reviewer Agent antes do merge.

---

## Estrutura

```
crew/
├── project.md           # briefing dos agentes — stack, convenções, regras
├── orchestrator.md      # protocolo completo do workflow
├── prompts/
│   ├── developer.md     # template do prompt do Developer Agent
│   └── reviewer.md      # template do prompt do Reviewer Agent
├── epics/
│   └── EXAMPLE.md       # template de épico — copie e preencha para cada feature
├── run-tests.sh         # stub — configure com o comando de teste do projeto
└── run-lint.sh          # stub — configure com o comando de lint do projeto
CLAUDE.md                # template de instruções para o Claude Code
```

---

## Setup num projeto novo

### 1. Copie o workflow para o projeto

Clone ou copie os arquivos deste repo para dentro do seu projeto.

### 2. Preencha `crew/project.md`

Este é o briefing dos agentes. Descreva:
- Stack (linguagem, framework, banco, dependências principais)
- Arquitetura e estrutura de diretórios
- Padrão de autenticação
- Convenções de código
- Framework de testes e estilo de specs
- Ferramenta de lint
- Constraints para o Developer Agent
- Regras de segurança para o Reviewer Agent

### 3. Preencha os checklists em `crew/prompts/reviewer.md`

Substitua os comentários `<!-- ... -->` das seções Segurança, Correção e Qualidade pelas
regras específicas do seu projeto.

### 4. Configure os scripts de teste e lint

Em `crew/run-tests.sh`, substitua o bloco TODO pelo comando de teste do projeto.

Em `crew/run-lint.sh`, ajuste `FILE_PATTERN` e `LINT_CMD` para o seu projeto.

### 5. Preencha o `CLAUDE.md`

Use o template como base. As seções importantes:
- O que é o projeto e qual a stack
- Como subir o ambiente e rodar os testes
- Estrutura de diretórios
- Backlog com os épicos
- Especificação dos endpoints (ou features equivalentes)

### 6. Crie os épicos

Copie `crew/epics/EXAMPLE.md` para `crew/epics/<ID>.md` e preencha cada seção.

---

## Como usar

Com o setup completo, peça ao Claude Code:

```
implementa o épico X-1
```

O Orchestrator lerá `crew/orchestrator.md` e conduzirá o fluxo completo automaticamente.

---

## Fluxo resumido

```
Orchestrator
  → lê crew/project.md (preflight)
  → lê crew/epics/<X>.md
  → cria branch epic/<X>
  → spawna Developer Agent (com contexto do projeto injetado)
  → roda run-tests.sh
  → roda run-lint.sh
  → spawna Reviewer Agent (épicos complexos)
  → checkpoint humano
  → commit + merge para main
```

Máximo de 3 tentativas por falha (testes, lint, revisão ou rejeição humana).
Se esgotar, aborta e volta para main sem commitar.
