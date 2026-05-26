# Project Context — {{PROJECT_NAME}}

> Este arquivo é o briefing dos agentes. O Orchestrator lê este arquivo durante o preflight
> e injeta o conteúdo como {{STACK_CONTEXT}} nos prompts do Developer e do Reviewer.
> Preencha todas as seções antes de usar o workflow.

---

## Stack

<!-- Linguagem, framework, versão, banco de dados, ferramentas principais -->

- **Linguagem:**
- **Framework:**
- **Banco de dados:**
- **Dependências principais:**

---

## Arquitetura

<!-- Como a aplicação está estruturada, padrões principais, diretórios relevantes -->

---

## Autenticação

<!-- Como a autenticação funciona (ex: JWT stateless, session, OAuth). Middleware/guard relevante. -->

---

## Convenções de código

<!-- Naming, formato de resposta da API, convenções de banco, padrões que o Developer deve seguir -->

---

## Testes

<!-- Framework de testes, estilo de spec, uso de mocks/fakes, onde ficam os arquivos de teste -->

- **Framework:**
- **Comando:**
- **Estilo de referência:** <!-- ex: spec/requests/example_spec.rb -->

---

## Lint

<!-- Ferramenta de lint, comando, escopo (ex: só arquivos do épico vs. repo inteiro) -->

- **Ferramenta:**
- **Comando:**

---

## Constraints para o Developer Agent

<!--
Liste aqui o que o Developer NÃO deve fazer neste projeto.
Exemplos:
- NÃO modifique migrations existentes
- NÃO adicione dependências sem aprovação
- Queries de DB sempre escopadas pelo usuário autenticado (nunca Model.find(id) sem filtro)
- Operações múltiplas de DB dentro de transaction
-->

---

## Regras de segurança para o Reviewer Agent

<!--
Liste aqui o que o Reviewer deve verificar como bloqueante.
Exemplos:
- Endpoint protegido tem middleware de autenticação?
- Todas as queries filtradas pelo usuário autenticado?
- Nenhum parâmetro de usuário inserido em query SQL raw?
-->
