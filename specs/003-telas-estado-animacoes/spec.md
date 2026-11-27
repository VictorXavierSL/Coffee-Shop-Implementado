# Feature Specification: Telas de Estado e Animações Substituíveis

**Feature Branch**: `003-telas-estado-animacoes` (sem branch git; diretório `specs/003-telas-estado-animacoes`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "As inter telas serão: de login, uma animação de café fumegante; de
erro, um café derramado dizendo que algo deu errado; caso o café não exista ou a página não
exista, um copo vazio dizendo que a página não existe ou que o café está indisponível. Caso o
pagamento seja confirmado, sobe uma animação de café subindo e aparece um certo dizendo que a
confirmação foi feita; caso não seja confirmado, sobe uma fumaça vermelha dizendo que não foi
possível realizar a transação. Caso a API caia em qualquer momento, o sistema deve avisar que
está fora do ar com um símbolo de café de Java desligado caído de um letreiro. Pode criar as
animações simples, mas deixe elas separadas e identificadas para que seja possível trocar no
futuro."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Telas de erro e de "não encontrado" (Priority: P1)

Quando algo dá errado, o cliente vê uma tela ilustrada e amigável em vez de uma mensagem
técnica: café derramado para erro inesperado e copo vazio para página inexistente ou café
indisponível, cada uma com uma ação para seguir.

**Why this priority**: os erros acontecem em todos os fluxos, e esta tela os torna
compreensíveis.

**Independent Test**: provocar um erro inesperado e abrir um café inexistente; conferir a
ilustração, o texto e a ação de cada tela.

**Acceptance Scenarios**:

1. **Given** um erro inesperado, **When** ele ocorre, **Then** aparece o café derramado com "Algo
   deu errado" e "Tentar novamente".
2. **Given** um café inexistente ou indisponível, **When** o cliente tenta abri-lo, **Then**
   aparece o copo vazio com "Este café está indisponível" e "Voltar ao cardápio".
3. **Given** uma página que não existe, **When** o cliente chega nela, **Then** aparece o copo
   vazio com "Esta página não existe" e "Ir para o início".

---

### User Story 2 - Aviso de sistema fora do ar (Priority: P1)

Se o servidor cair em qualquer momento, o cliente vê o letreiro de café com a xícara desligada
caindo e a mensagem de que o sistema está fora do ar, com "Tentar novamente".

**Why this priority**: o protótipo exige esse aviso em qualquer momento; o comportamento é da
feature 002.

**Independent Test**: parar o servidor e realizar qualquer ação; ver a animação e a mensagem;
religar e tentar novamente.

**Acceptance Scenarios**:

1. **Given** o servidor fora do ar, **When** o cliente faz qualquer ação, **Then** vê a
   animação da xícara desligada caindo do letreiro e "Estamos fora do ar. Tente novamente em
   instantes."
2. **Given** o servidor de volta, **When** o cliente toca em "Tentar novamente", **Then** o app
   segue normalmente.

---

### User Story 3 - Resultado do pagamento (Priority: P1)

Depois do pagamento, o cliente vê uma animação clara do resultado: café subindo e um "certo"
para aprovado; fumaça vermelha subindo e "Não foi possível realizar a transação" para recusado
ou estornado.

**Why this priority**: o resultado do pagamento precisa ser inequívoco.

**Independent Test**: usar os produtos de demonstração "sempre aprova" e "sempre recusa"
(feature 006) e ver cada animação.

**Acceptance Scenarios**:

1. **Given** um pagamento aprovado, **When** o resultado chega, **Then** a animação do café
   subindo termina em um "certo" com "Pagamento confirmado".
2. **Given** um pagamento recusado, **When** o resultado chega, **Then** a fumaça vermelha sobe
   com "Não foi possível realizar a transação".
3. **Given** um pagamento estornado, **When** o resultado chega, **Then** a fumaça vermelha sobe
   com "Não foi possível concluir o pedido. O valor foi estornado."

---

### User Story 4 - Transição do login (Priority: P2)

Enquanto o login está sendo processado (e na entrada no app), aparece a animação do café
fumegante.

**Why this priority**: é um encantamento; o login funciona sem ela.

**Independent Test**: fazer login e ver o café fumegante durante a espera.

**Acceptance Scenarios**:

1. **Given** o login enviado, **When** a resposta está pendente, **Then** aparece o café
   fumegante animado.
2. **Given** uma resposta muito rápida, **When** o login termina, **Then** a animação aparece por
   um tempo mínimo curto, para não "piscar".

---

### User Story 5 - Trocar uma animação sem mexer nas telas (Priority: P3)

Uma pessoa designer substitui a animação do café derramado por uma nova arte (ex.: um arquivo de
animação profissional) só trocando o arquivo no local indicado, sem alterar telas.

**Why this priority**: o usuário pediu explicitamente que as animações sejam substituíveis.

**Independent Test**: seguir `docs/ASSETS.md` para trocar uma animação e ver a nova no app, sem
alterar nenhuma cena.

**Acceptance Scenarios**:

1. **Given** o catálogo `docs/ASSETS.md`, **When** a pessoa troca uma animação seguindo as
   instruções, **Then** a nova animação aparece em todas as telas que a usam.

### Edge Cases

- Com a opção de reduzir movimento ativada no aparelho, as animações são substituídas por
  imagens estáticas com o mesmo texto.
- As animações funcionam nos temas claro e escuro.
- Se um arquivo de animação faltar ou estiver corrompido, aparece uma ilustração estática
  padrão, sem quebrar a tela.
- Erros consecutivos não empilham várias telas de erro.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema MUST ter as telas de estado: carregando/login (café fumegante), erro
  (café derramado), não encontrado/indisponível (copo vazio), fora do ar (xícara desligada
  caindo do letreiro), pagamento aprovado (café subindo + certo) e pagamento recusado/estornado
  (fumaça vermelha).
- **FR-002**: Cada tela de estado MUST ter ilustração ou animação, título, mensagem e ação
  principal.
- **FR-003**: As telas de estado MUST ser componentes reutilizáveis do Design System, com
  variantes criadas por Factory, presentes no Sample App.
- **FR-004**: Cada animação MUST ser um recurso separado e identificado por nome (ex.:
  `coffee_steaming`, `coffee_spilled`, `cup_empty`, `server_down`, `payment_success`,
  `payment_failure`), listado em `docs/ASSETS.md` com instruções de troca.
- **FR-005**: As animações iniciais MUST ser simples e feitas para o projeto; somente
  dependências de animação são permitidas.
- **FR-006**: O sistema MUST respeitar a preferência de reduzir movimento do aparelho.
- **FR-007**: Os textos das telas de estado MUST ser definidos pela ViewModel da cena, e não
  dentro da animação.
- **FR-008**: As telas de estado MUST funcionar nos temas claro e escuro, usando os tokens do
  Design System.

### Key Entities

- **Tipo de estado**: carregando, erro, não encontrado, indisponível, fora do ar, pagamento
  aprovado, pagamento recusado, estornado.
- **Recurso de animação**: identificador, arquivo, versão estática alternativa e descrição.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% dos erros mostrados ao cliente usam uma das telas de estado, nunca texto
  técnico.
- **SC-002**: Trocar uma animação exige alterar 0 arquivos de cena.
- **SC-003**: Em teste com usuários, 90% entendem corretamente o que aconteceu em cada tela de
  estado sem ler o texto todo.
- **SC-004**: As animações rodam sem travamentos perceptíveis nos aparelhos de teste.

## Assumptions

- Vem logo depois do servidor (002) porque as telas de estado são componentes do Design System
  usados pelas features 004–007. Usa a detecção de fora do ar da 002. As telas de pagamento
  são entregues como componentes prontos e ligadas aos resultados reais quando a 006 for
  implementada; até lá, são exercitadas com estados simulados no Sample App.
- O componente `StateView` existente no Design System é a base a ser estendida.
- "Café de Java desligado" foi interpretado como uma xícara de café estilizada, apagada, caindo
  de um letreiro luminoso, em arte original do projeto, sem uso de logotipos de terceiros.
- O tempo mínimo da animação de login é de 600 ms.
