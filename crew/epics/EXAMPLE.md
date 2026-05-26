# Épico {{EPIC_ID}} — {{EPIC_TITLE}}

<!--
Template de épico. Copie este arquivo, renomeie para <ID>.md e preencha todas as seções.
Quanto mais preciso o preenchimento, melhor o Developer Agent performa.
-->

## Objetivo

<!-- Uma ou duas frases descrevendo o que este épico entrega. -->

## Spec

<!--
Descreva o comportamento esperado com detalhes suficientes para o Developer implementar sem
ambiguidade. Para endpoints de API, inclua: método HTTP, rota, auth, params, lógica, respostas.

Exemplo:
  POST /resources
  Auth: Bearer <token> obrigatório
  Body: { "field": String }
  Lógica: cria o recurso vinculado ao usuário autenticado
  Response 201: recurso criado
  Response 422: { "error": "invalid_params" } se validação falhar
  Response 401: { "error": "unauthorized" } se token ausente/inválido
-->

---

## Arquivos a ler antes de implementar

<!--
Liste os paths dos arquivos de referência que o Developer deve ler antes de começar.
O objetivo é garantir que o agente conheça os padrões do projeto antes de escrever código.
NÃO cole o conteúdo aqui — o agente lê do disco.

Exemplos:
  src/controllers/application_controller.rb
  src/services/example_service.rb
  spec/requests/example_spec.rb
-->

---

## Arquivos a criar ou modificar

<!--
Liste os paths dos arquivos que o Developer deve criar ou editar.
Seja específico — isso é o escopo de trabalho do agente.

Exemplos:
  src/controllers/new_controller.rb       # CRIAR
  src/services/new_service.rb             # CRIAR
  spec/requests/new_spec.rb               # CRIAR
  config/routes.rb                        # MODIFICAR — adicionar rota
-->

---

## Critérios de aceitação (specs obrigatórios)

<!--
Liste cada caso de teste que DEVE existir e passar. Estes critérios são vinculantes —
o Developer escreve os testes para cobrir exatamente estes casos, nem mais nem menos.
Seja explícito: descreva o input, o comportamento esperado e o output.

Exemplos:
1. Request autenticado com dados válidos → 201 com o recurso criado no body
2. Request sem token → 401
3. Request com dados inválidos → 422 com mensagem de erro
4. Recurso não pertence ao usuário autenticado → 404 (não 403 — não vazar existência)
-->

---

## Considerações especiais

<!--
Opcional. Use para anotar edge cases, decisões de design, dependências entre épicos,
ou qualquer coisa que não se encaixe nas seções acima.
-->
