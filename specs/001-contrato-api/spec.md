# Feature Specification: Contrato da API Evidente e Único

**Feature Branch**: `001-contrato-api` (sem branch git; diretório `specs/001-contrato-api`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Crie mais uma spec para o contrato da API; ele deve ficar evidente
no README. Use como base o que já temos."

> **Ordem recomendada:** pelo princípio VI da constitution (contrato de API primeiro), esta
> feature deve ser planejada e entregue **antes** da implementação da 002 e das features
> 003–007, que vão implementar as rotas definidas aqui.
>
> **Ordem de implementação das specs:** 001 contrato da API → 002 servidor mock →
> 003 telas de estado → 004 autenticação → 005 catálogo → 006 carrinho e pagamento →
> 007 mapa de entrega → 008 esteira de testes.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Entender a API pelo README (Priority: P1)

Uma pessoa que abre o repositório pela primeira vez (aluno, professor, avaliador) encontra no
README, logo no início, uma seção "Contrato da API" com o resumo do contrato: endereço base,
autenticação, formato de erro, versão e a tabela de todas as rotas. Cada rota aponta para a
descrição detalhada.

**Why this priority**: o usuário pediu explicitamente que o contrato fique evidente no README; é
a porta de entrada do projeto.

**Independent Test**: só pelo README, sem abrir código, responder quais rotas existem, quais
exigem login, qual é o formato de erro e onde está o detalhe de cada rota.

**Acceptance Scenarios**:

1. **Given** o README, **When** a pessoa procura a API, **Then** encontra a seção "Contrato da
   API" no índice e antes das instruções de execução.
2. **Given** a seção, **When** a pessoa lê a tabela, **Then** vê, para cada rota: método,
   caminho, se exige login, a feature ou tela que usa e o link para o detalhe.
3. **Given** a seção, **When** a pessoa procura o formato de erro, **Then** vê o envelope único
   de erro e o link para a tabela completa de códigos.

---

### User Story 2 - Um contrato único que o servidor, o simulador e o app seguem (Priority: P1)

O contrato descreve cada rota com requisição, respostas de sucesso, erros possíveis e exemplos.
O servidor mock (feature 002), o simulador em memória dos testes e o app seguem exatamente esse
documento, e uma verificação automática acusa qualquer divergência.

**Why this priority**: sem contrato único, servidor, simulador e app divergem, e as features
003–007 não conseguem ser feitas em paralelo.

**Independent Test**: alterar de propósito a resposta de uma rota no simulador e ver a
verificação de contrato falhar, apontando a rota.

**Acceptance Scenarios**:

1. **Given** o contrato, **When** a verificação roda contra o servidor mock, **Then** todas as
   rotas respondem conforme o documento.
2. **Given** o contrato, **When** a verificação roda contra o simulador em memória, **Then** o
   resultado é o mesmo do servidor.
3. **Given** uma resposta fora do contrato, **When** a verificação roda, **Then** ela falha
   indicando a rota, o campo e a diferença.

---

### User Story 3 - Contrato completo para as features do protótipo (Priority: P1)

O contrato cobre, além das rotas atuais, tudo o que as features 002–007 precisam: cadastro,
login por e-mail ou usuário, Google/Apple simulado, confirmação de e-mail, foto de perfil,
grão e índices, tamanhos com ml, avaliações, favoritos, indicação do dia, carrinho, pagamento
com idempotência e estorno, mapa e pontos de entrega, avanço de status e verificação de saúde
do servidor.

**Why this priority**: o contrato vem antes da implementação (constitution, princípio VI).

**Independent Test**: para cada requisito funcional das specs 002–007 que envolve dados,
encontrar a rota correspondente no contrato.

**Acceptance Scenarios**:

1. **Given** as specs 002–007, **When** cada requisito de dados é cruzado com o contrato,
   **Then** 100% têm rota correspondente.
2. **Given** uma rota simulada (Google/Apple, e-mail, pagamento, mapa), **When** a pessoa lê o
   detalhe, **Then** vê a marcação "Simulado", o comportamento e o link para
   `docs/SIMULACOES.md`.

---

### User Story 4 - Evoluir o contrato sem quebrar o app (Priority: P2)

Quando uma rota muda, a pessoa sabe se a mudança é compatível ou não pela versão do contrato e
pelo histórico de mudanças, e o app atual não quebra com mudanças compatíveis.

**Why this priority**: o contrato vai crescer a cada feature.

**Independent Test**: adicionar um campo novo em uma resposta e verificar que o app atual
continua funcionando, que a versão sobe como compatível e que o histórico registra a mudança.

**Acceptance Scenarios**:

1. **Given** um campo novo e opcional, **When** ele é adicionado, **Then** a versão do contrato
   sobe como compatível e o app atual ignora o campo sem erro.
2. **Given** a remoção ou renomeação de um campo ou rota, **When** isso é proposto, **Then** a
   mudança é marcada como incompatível, registrada no histórico e exige aprovação.

### Edge Cases

- Rota usada pelo app mas ausente do contrato: a verificação acusa.
- Rota no contrato sem uso por nenhuma feature: aparece marcada como "não utilizada" no resumo.
- Campo que pode vir nulo: o contrato diz explicitamente quando, e o app trata.
- Leitura que altera estado (hoje `GET /orders/{id}` avança o status): o contrato MUST eliminar
  esse comportamento e oferecer uma operação explícita de demonstração.
- Datas e horários: sempre em um único formato padrão, com fuso explícito.
- Listas grandes (avaliações, pedidos): contrato de paginação definido.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O README MUST ter uma seção "Contrato da API", listada no índice e posicionada
  antes das instruções de execução, contendo: endereço base, autenticação, formato de erro,
  versão atual do contrato e a tabela com todas as rotas (método, caminho, autenticada, usada
  por, link para o detalhe).
- **FR-002**: O detalhe de cada rota MUST continuar em `docs/API.md`, que é a referência
  completa: requisição, respostas, erros, exemplos e regras de negócio.
- **FR-003**: O contrato MUST também existir em formato legível por máquina, padrão de mercado,
  usado pela verificação automática e para gerar documentação navegável.
- **FR-004**: O contrato MUST preservar as 10 rotas atuais e o envelope de erro
  `{ "error": { "code", "message" } }`; qualquer mudança incompatível nelas MUST ser listada no
  histórico de mudanças.
- **FR-005**: O contrato MUST cobrir as capacidades das features 002–007:
  - **Autenticação e conta (004):** cadastro; login por e-mail **ou** nome de usuário;
    login Google/Apple simulado; confirmação de e-mail simulada; perfil; envio, troca e
    remoção da foto de perfil; logout; bloqueio por tentativas (erro próprio com tempo
    restante).
  - **Catálogo (005):** categorias; produtos com grão (nome, origem, ilustração), perfil
    sensorial (amargor, doçura, acidez e corpo, de 0 a 5 em passos de 0,5) e tamanhos com
    volume em ml e preço; promoções; avaliações paginadas com média e total; criar ou
    substituir a própria avaliação; favoritos (listar, adicionar, remover); indicação do dia
    com motivo.
  - **Carrinho e pagamento (006):** carrinho do cliente (ver, adicionar, alterar e remover
    itens); cotação; criar pedido; formas de pagamento; tentativa de pagamento com chave de
    idempotência e estados pendente/aprovado/recusado/estornado; consulta da tentativa.
  - **Entrega e mapa (007):** dados da loja; pontos de entrega de demonstração; validação de
    endereço/área com taxa; rastreio do pedido (posição do entregador, trajeto, tempo
    estimado).
  - **Servidor (002):** verificação de saúde (usada para o aviso de fora do ar); operação
    explícita de demonstração para avançar o status do pedido; restauração dos dados de
    demonstração (apenas em modo de demonstração).
- **FR-006**: Toda rota simulada MUST ser marcada como "Simulado" no contrato e no README, com
  link para `docs/SIMULACOES.md`.
- **FR-007**: Rotas de leitura MUST NOT alterar estado.
- **FR-008**: O contrato MUST ter versão própria com versionamento semântico e um histórico de
  mudanças; mudanças incompatíveis exigem aprovação do dono do repositório.
- **FR-009**: Uma verificação automática MUST comparar o servidor mock e o simulador em memória
  com o contrato, e falhar ao encontrar divergência.
- **FR-010**: A tabela de erros MUST incluir os códigos novos (ex.: conta bloqueada, e-mail ou
  usuário já em uso, senha fraca, pagamento recusado, idempotência conflitante, fora da área,
  avaliação inválida) com HTTP, código e quando ocorre.
- **FR-011**: Os exemplos do contrato MUST usar os dados de demonstração de Palmas-TO (loja na
  Praça dos Girassóis), substituindo os endereços e telefones do Figma.
- **FR-012**: Valores monetários MUST usar **real (R$)**, com 2 casas decimais, exibidos no
  padrão brasileiro (ex.: R$ 12,50). Decisão do usuário em 2026-11-27: substitui o dólar herdado
  do Figma. Preços do seed, exemplos do `docs/API.md` e textos do README MUST ser convertidos, e
  a mudança MUST constar no histórico do contrato como incompatível.
- **FR-013**: Datas MUST seguir um único formato padrão com fuso; listas grandes MUST ter
  paginação definida no contrato.
- **FR-014**: Códigos de tamanho MUST continuar `S`/`M`/`L` no contrato, exibidos ao cliente
  como P/M/G.

### Key Entities

- **Rota**: método, caminho, autenticação, requisição, respostas, erros, exemplos, feature
  dona, marcação de simulação.
- **Envelope de erro**: código estável, mensagem legível e detalhes opcionais (ex.: campos
  inválidos, tempo restante de bloqueio).
- **Versão do contrato**: número, data e mudanças (compatíveis ou incompatíveis).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Uma pessoa nova responde, só lendo o README, 5 perguntas básicas sobre a API (quais
  rotas existem, quais exigem login, formato de erro, versão, onde está o detalhe) em menos de
  5 minutos.
- **SC-002**: 100% das rotas usadas pelo app estão no contrato, e 100% das rotas do contrato
  passam na verificação contra o servidor e o simulador.
- **SC-003**: 100% dos requisitos de dados das specs 002–007 têm rota correspondente.
- **SC-004**: Toda alteração de contrato aparece no histórico com versão e data.
- **SC-005**: 0 rotas de leitura alteram estado.

## Assumptions

- Base: o `docs/API.md` atual (10 rotas, envelope de erro, exemplos) e as specs 002–007.
- O formato legível por máquina adotado será OpenAPI 3, a confirmar no `/speckit-plan`.
- O endereço base segue o já documentado, com o prefixo `/v1`; no servidor local de
  demonstração vale o mesmo prefixo.
- Os nomes exatos das rotas novas são definidos no `/speckit-plan` desta feature, seguindo o
  padrão REST já usado.
- O README continua com o resumo, e o detalhe fica em `docs/API.md` (não duplica exemplos
  longos no README).
