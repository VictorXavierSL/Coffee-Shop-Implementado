# Feature Specification: Servidor Mock Separado com Banco de Dados

**Feature Branch**: `002-servidor-mock-postgres` (sem branch git; diretório `specs/002-servidor-mock-postgres`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Ele possui um back-end com uma API mock, atualmente servindo apenas
de demonstração, contendo dados já criados para teste e um banco de dados simples Postgres.
Mock separado do app com o Postgres e adicionar as instruções para rodar ele. Caso a API caia em
qualquer momento, o sistema deve avisar que está fora do ar."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Subir o servidor de demonstração e usar o app com ele (Priority: P1)

Uma pessoa desenvolvedora (ou o professor avaliando o projeto) clona o repositório, segue as
instruções do README, sobe o banco e o servidor de demonstração e abre o app. O app passa a
exibir os dados vindos desse servidor (usuário, categorias, produtos, promoções, pedidos).

**Why this priority**: todas as outras features dependem de um servidor que entregue os dados.
Sem ele nada mais funciona.

**Independent Test**: seguindo apenas o README em uma máquina limpa (com os pré-requisitos
instalados), o servidor sobe com os dados de demonstração e o login de demonstração existente
funciona no app, chegando à Home com produtos.

**Acceptance Scenarios**:

1. **Given** uma máquina com os pré-requisitos instalados, **When** a pessoa executa os passos
   do README, **Then** o banco e o servidor sobem e respondem às rotas documentadas em
   `docs/API.md`.
2. **Given** o servidor rodando, **When** o app é aberto apontando para ele, **Then** todas as
   telas existentes (Launch, Onboarding, Login, Home, Detalhes, Pedido, Acompanhamento)
   funcionam com dados vindos do servidor.
3. **Given** o servidor rodando há algum tempo, **When** ele é reiniciado, **Then** os dados
   criados durante o uso (pedidos, contas, favoritos) continuam lá.

---

### User Story 2 - Restaurar os dados de demonstração (Priority: P2)

Antes de uma apresentação, a pessoa quer voltar o banco ao estado inicial, com os dados de
demonstração originais.

**Why this priority**: as demonstrações precisam ser reproduzíveis.

**Independent Test**: depois de criar pedidos e contas, executar o comando documentado de
restauração e verificar que só restam os dados de demonstração originais.

**Acceptance Scenarios**:

1. **Given** um banco com dados criados durante o uso, **When** a pessoa executa o comando de
   restauração documentado, **Then** o banco volta exatamente ao conjunto de dados de
   demonstração.

---

### User Story 3 - Aviso de servidor fora do ar (Priority: P2)

Com o app aberto, o servidor fica indisponível (parado, sem rede ou com erro interno). O
cliente percebe e vê uma tela clara dizendo que o sistema está fora do ar, com a opção de
tentar de novo.

**Why this priority**: o prototipo exige esse aviso "em qualquer momento". A arte da tela é da
feature 003; aqui fica a detecção e o comportamento.

**Independent Test**: com o app em qualquer tela, parar o servidor e realizar uma ação. O aviso
de fora do ar aparece; ao religar o servidor e tocar em "Tentar novamente", o app volta ao
ponto em que estava.

**Acceptance Scenarios**:

1. **Given** o app em qualquer tela, **When** uma requisição falha por servidor indisponível ou
   erro interno, **Then** o app exibe o aviso de "fora do ar" em vez de um erro técnico.
2. **Given** o aviso exibido, **When** o servidor volta e a pessoa toca em "Tentar novamente",
   **Then** o app repete a operação e segue normalmente.
3. **Given** um erro de negócio (ex.: senha incorreta), **When** a resposta chega, **Then** o
   app mostra a mensagem do erro, e não o aviso de fora do ar.

---

### User Story 4 - Testes continuam rodando sem servidor (Priority: P3)

Os testes automatizados do app continuam rodando sem precisar subir o banco nem o servidor,
usando o simulador em memória que segue o mesmo contrato.

**Why this priority**: a qualidade não pode depender de infraestrutura.

**Independent Test**: executar os testes do app sem servidor rodando e todos passarem.

**Acceptance Scenarios**:

1. **Given** nenhum servidor rodando, **When** os testes do app são executados, **Then** todos
   passam usando o simulador em memória.

### Edge Cases

- O app é aberto antes de o servidor terminar de subir: mostra o aviso de fora do ar e permite
  tentar de novo.
- O servidor demora a responder: após um tempo limite, a requisição é tratada como falha de
  conexão.
- O banco não está disponível quando o servidor inicia: o servidor informa o problema
  claramente e não fica "meio no ar".
- Rota inexistente: resposta 404 no formato padrão de erro.
- O contrato do simulador em memória diverge do servidor: os testes de contrato precisam
  acusar.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema MUST ter um servidor de demonstração separado do app, executado de
  forma independente.
- **FR-002**: O servidor MUST guardar os dados em um banco persistente, que sobrevive a
  reinícios.
- **FR-003**: O servidor MUST criar automaticamente os dados de demonstração (seed) na primeira
  execução: usuários de demonstração, categorias, produtos, promoções, avaliações e histórico
  de pedidos, todos localizados em Palmas-TO, com a loja na Praça dos Girassóis.
- **FR-004**: O servidor MUST oferecer um comando para restaurar o banco ao estado de
  demonstração.
- **FR-005**: O servidor MUST responder todas as rotas já documentadas em `docs/API.md` com os
  mesmos caminhos, códigos e corpos, e toda rota nova das próximas features MUST ser
  documentada antes.
- **FR-006**: O app MUST obter todos os dados de negócio do servidor; nenhum dado de negócio
  fica fixo no app.
- **FR-007**: O endereço do servidor MUST ser configurável sem alterar código de tela, com
  valores padrão que funcionem no emulador Android, no simulador iOS e na web.
- **FR-008**: O app MUST distinguir falha de conexão ou erro interno do servidor (que geram o
  aviso de fora do ar) de erros de negócio (que mostram a mensagem do erro).
- **FR-009**: O app MUST oferecer "Tentar novamente" no aviso de fora do ar, repetindo a
  operação que falhou.
- **FR-010**: O simulador em memória MUST continuar disponível para os testes automatizados e
  seguir o mesmo contrato do servidor.
- **FR-011**: O README MUST conter instruções passo a passo para subir o banco, aplicar os dados
  de demonstração, iniciar o servidor, apontar o app para ele e restaurar os dados.
- **FR-012**: Requisições de leitura MUST NOT alterar dados. O avanço de status do pedido, hoje
  feito por uma leitura, MUST passar para uma operação explícita documentada.
- **FR-013**: Configurações sensíveis (senha do banco etc.) MUST vir de variáveis de ambiente,
  com um arquivo de exemplo versionado e o arquivo real fora do versionamento.

### Key Entities

- **Usuário**: conta com nome de usuário, e-mail, senha protegida, foto opcional, endereço em
  Palmas-TO e data de cadastro.
- **Categoria**: agrupamento de produtos (ex.: Machiato, Latte, Americano).
- **Produto**: café com nome, descrição, foto, categoria, tamanhos (P/M/G com volume e preço) e
  atributos de grão (detalhados na feature 005).
- **Promoção**: banner promocional exibido na Home.
- **Pedido**: itens, tipo de entrega, endereço, pagamento, resumo de valores e status.
- **Sessão**: token de acesso vinculado a um usuário, com validade.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Uma pessoa sem conhecimento prévio do projeto sobe banco e servidor e faz login no
  app em até 15 minutos seguindo só o README.
- **SC-002**: 100% das rotas documentadas em `docs/API.md` respondem conforme o documento.
- **SC-003**: Dados criados durante o uso permanecem após reiniciar o servidor em 100% das
  verificações.
- **SC-004**: A restauração dos dados de demonstração leva menos de 1 minuto.
- **SC-005**: Ao derrubar o servidor, o aviso de fora do ar aparece em até 10 segundos após a
  próxima ação, em qualquer tela.
- **SC-006**: Os testes automatizados do app passam sem nenhum servidor rodando.

## Assumptions

- Conforme a constitution (princípio V), o servidor é escrito em Dart (shelf) com Postgres, e o
  banco roda via Docker Compose. Os detalhes ficam para o `/speckit-plan`.
- O simulador em memória (`MockApiClient`) continua em `packages/core`, só para testes.
- Não há requisito de hospedagem em nuvem; tudo roda localmente.
- O endereço do Figma ("Jl. Kpg Sutoyo") é substituído por endereços simulados em Palmas-TO, e o
  README deve ser atualizado (governança da constitution).
- A arte e a animação do aviso de fora do ar são definidas na feature 003; aqui só se garante o
  comportamento.
