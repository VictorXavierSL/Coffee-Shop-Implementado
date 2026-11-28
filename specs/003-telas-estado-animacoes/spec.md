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

> **Divisão com a spec 004** (decisão do usuário em 2026-11-27): esta spec define o **visual**
> (os componentes de tela de estado e as animações substituíveis). **Onde e quando** cada inter
> tela aparece (fluxos, códigos de erro, textos, ações e prioridade) é definido na spec **004**
> (inter telas: loading e erros previstos). Em caso de conflito sobre quando exibir, vale a 004.

## Clarifications

### Session 2026-11-27

- Q: Como devem ser as telas de resultado do pagamento? → A: Tela inteira, como se o celular
  fosse a xícara. Aprovado: um líquido marrom (café) sobe do fundo até encher a tela, e aparece um
  "certo" branco desenhado como leite (latte art), com o texto de compra concluída. Não concluído
  (recusado ou estornado): uma fumaça vermelha sobe e cobre a tela inteira, e um X branco aparece
  no meio, com o texto de que não foi possível realizar.
- Q: Qual deve ser o título exato da tela de pagamento aprovado? → A: Título "Compra concluída!"
  e mensagem "Seu pagamento foi confirmado e o pedido já está sendo preparado."
- Q: O que acontece depois que a animação de pagamento aprovado termina? → A: A tela espera a
  escolha do cliente em dois botões simples, "Acompanhar pedido" (rastreio) e "Voltar ao
  cardápio" (menu), sem avançar sozinha. Depois do toque, a saída continua a animação: o
  conteúdo da tela (líquido e "certo") desliza para cima e sai. A fumaça vermelha sai do mesmo
  jeito depois do toque em um dos botões da tela de falha.
- Q: Quais botões a tela de pagamento não concluído (fumaça vermelha) deve ter? → A: Dois
  botões. Recusado: "Tentar outra forma" + "Voltar ao cardápio". Estornado: "Voltar ao
  carrinho" + "Voltar ao cardápio". O carrinho é mantido nos dois casos.
- Q: Como a animação de entrada se liga à de saída? → A: É um único movimento contínuo, como se
  o líquido (ou a fumaça) passasse pela tela. Na entrada, ele sobe do fundo com a frente
  ondulada até cobrir a tela; nada aparece de uma vez. Na saída, o inverso: ele continua subindo
  e sai pelo topo, e a borda de trás, também ondulada, vai revelando o destino de baixo para
  cima. A tela não sai como um bloco rígido.
- Q: Como deve ser a animação de "algo deu errado"? → A: A xícara cai, tomba e derrama o café
  (pedido do usuário na spec 012, que define os sons). O identificador continua
  `coffee_spilled`.
- Q: Qual animação deve aparecer quando o aparelho do cliente estiver sem internet? → A: Uma
  tela própria, diferente do fora do ar: uma xícara cujo vapor desenha o símbolo de Wi-Fi; os
  arcos vão sumindo um a um até restar só a xícara. Texto "Sem conexão com a internet" /
  "Verifique o Wi-Fi ou os dados móveis." Identificador `no_internet`.
- Q: Quando a internet do aparelho voltar, o app deve continuar sozinho ou esperar o cliente? →
  A: Continua sozinho. O vapor redesenha os arcos do Wi-Fi, mostrando o sinal voltando, e a tela
  sai subindo como o líquido do pagamento aprovado (passagem contínua, borda de trás ondulada),
  revelando a tela que o cliente tentava abrir. "Tentar novamente" continua disponível enquanto
  a rede não volta.
- Q: Com o aparelho sem internet e outro erro ao mesmo tempo, qual tela aparece primeiro? → A: Sem
  internet vem antes de tudo: sem internet > fora do ar > sessão expirada > resultado de
  pagamento > não encontrado > erro de campo > erro parcial (registrado na 004, FR-008).
- Q: Qual som deve acompanhar a tela de sem internet? → A: Chiado de vapor suave que se apaga
  conforme os arcos somem; quando a rede volta, o chiado sobe de novo e se junta ao som do
  líquido subindo (registrado na tabela de sons da 012, FR-002).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Telas de erro e de "não encontrado" (Priority: P1)

Quando algo dá errado, o cliente vê uma tela ilustrada e amigável em vez de uma mensagem
técnica: xícara caindo e derramando o café para erro inesperado e copo vazio para página inexistente ou café
indisponível, cada uma com uma ação para seguir.

**Why this priority**: os erros acontecem em todos os fluxos, e esta tela os torna
compreensíveis.

**Independent Test**: provocar um erro inesperado e abrir um café inexistente; conferir a
ilustração, o texto e a ação de cada tela.

**Acceptance Scenarios**:

1. **Given** um erro inesperado, **When** ele ocorre, **Then** a xícara cai, tomba e derrama o
   café, e aparece "Algo deu errado" com "Tentar novamente".
2. **Given** um café inexistente ou indisponível, **When** o cliente tenta abri-lo, **Then**
   aparece o copo vazio com "Este café está indisponível" e "Voltar ao cardápio".
3. **Given** uma página que não existe, **When** o cliente chega nela, **Then** aparece o copo
   vazio com "Esta página não existe" e "Ir para o início".

---

### User Story 2 - Aviso de sistema fora do ar e de aparelho sem internet (Priority: P1)

Se o servidor cair em qualquer momento, o cliente vê o letreiro de café com a xícara desligada
caindo e a mensagem de que o sistema está fora do ar, com "Tentar novamente". Se o problema for a
internet do próprio aparelho, ele vê outra tela: a xícara com o vapor em forma de Wi-Fi sumindo.

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
3. **Given** o aparelho sem internet (Wi-Fi e dados móveis desligados), **When** o cliente faz
   qualquer ação, **Then** vê a xícara com o vapor em forma de Wi-Fi, cujos arcos somem um a um,
   e "Sem conexão com a internet" / "Verifique o Wi-Fi ou os dados móveis.", e não a tela de
   fora do ar.
4. **Given** a tela sem internet, **When** a conexão do aparelho volta, **Then** o vapor
   redesenha os arcos do Wi-Fi e a tela sai subindo, como o líquido do pagamento aprovado,
   revelando a tela que o cliente tentava abrir, sem ele tocar em nada.

---

### User Story 3 - Resultado do pagamento (Priority: P1)

Depois do pagamento, o resultado ocupa a tela inteira, como se o celular fosse a xícara. Se for
aprovado, um líquido marrom (café) sobe do fundo até encher a tela, e um "certo" branco
desenhado como leite (latte art) aparece sobre ele. Se for recusado ou estornado, uma fumaça
vermelha sobe e cobre a tela inteira, e um X branco aparece no meio.

**Why this priority**: o resultado do pagamento precisa ser inequívoco.

**Independent Test**: usar os produtos de demonstração "sempre aprova" e "sempre recusa"
(feature 007) e ver cada animação.

**Acceptance Scenarios**:

1. **Given** um pagamento aprovado, **When** o resultado chega, **Then** o líquido marrom sobe
   do fundo até encher a tela inteira e, ao final, aparece o "certo" branco em latte art com o
   título "Compra concluída!" e a mensagem "Seu pagamento foi confirmado e o pedido já está
   sendo preparado.", junto com os botões "Acompanhar pedido" e "Voltar ao cardápio". A tela
   não avança sozinha.
2. **Given** a tela de aprovado, **When** o cliente toca em um dos dois botões, **Then** o
   líquido continua subindo e sai pelo topo levando o "certo", e a borda de trás, ondulada,
   revela o rastreio ou o cardápio de baixo para cima, conforme o botão.
3. **Given** a tela de falha, **When** o cliente toca em um dos botões dela, **Then** a fumaça
   vermelha continua subindo e sai pelo topo levando o X, revelando o destino do mesmo jeito.
4. **Given** um pagamento recusado, **When** o resultado chega, **Then** a fumaça vermelha sobe
   até cobrir a tela inteira e, ao final, aparece o X branco no meio com "Não foi possível
   realizar a transação", junto com os botões "Tentar outra forma" e "Voltar ao cardápio".
5. **Given** um pagamento estornado, **When** o resultado chega, **Then** a mesma fumaça
   vermelha com o X branco aparece, com "Não foi possível concluir o pedido. O valor foi
   estornado.", junto com os botões "Voltar ao carrinho" e "Voltar ao cardápio".

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
  (xícara caindo e derramando o café), não encontrado/indisponível (copo vazio), fora do ar (xícara desligada
  caindo do letreiro), sem internet (vapor em forma de Wi-Fi sumindo), pagamento aprovado (líquido marrom enchendo a tela + "certo" branco em
  latte art) e pagamento recusado/estornado (fumaça vermelha cobrindo a tela + X branco no
  meio).
- **FR-001a**: As telas de resultado do pagamento MUST ocupar a tela inteira (sem barra de
  navegação, cabeçalho ou carrinho lateral visíveis), com a metáfora de o celular ser a xícara.
  O símbolo final ("certo" ou X) e o texto MUST aparecer só depois que o líquido ou a fumaça
  cobrir a tela.
- **FR-001b**: As telas de resultado do pagamento MUST NOT avançar sozinhas. A tela de aprovado
  MUST ter dois botões simples, "Acompanhar pedido" e "Voltar ao cardápio". A de recusado MUST
  ter "Tentar outra forma" e "Voltar ao cardápio", e a de estornado MUST ter "Voltar ao
  carrinho" e "Voltar ao cardápio"; nenhuma delas descarta o carrinho. Depois do toque em
  qualquer botão, a animação de saída MUST continuar a de entrada, como um único movimento:
  o líquido (ou a fumaça) segue subindo, sai pelo topo levando o símbolo e o texto, e a borda de
  trás, irregular como a da frente, revela o destino de baixo para cima. A saída MUST NOT ser um
  corte nem um deslizamento de bloco rígido.
- **FR-002**: Cada tela de estado MUST ter ilustração ou animação, título, mensagem e ação
  principal.
- **FR-003**: As telas de estado MUST ser componentes reutilizáveis do Design System, com
  variantes criadas por Factory, presentes no Sample App.
- **FR-001c**: A tela sem internet MUST ter animação de retorno: quando a conexão volta, o vapor
  redesenha os arcos do Wi-Fi e a tela sai com a mesma passagem contínua para cima do resultado
  do pagamento (FR-001b), revelando a tela de destino.
- **FR-004**: Cada animação MUST ser um recurso separado e identificado por nome (ex.:
  `coffee_steaming`, `coffee_spilled`, `cup_empty`, `server_down`, `no_internet`,
  `payment_success`, `payment_failure`), listado em `docs/ASSETS.md` com instruções de troca.
- **FR-005**: As animações iniciais MUST ser simples e feitas para o projeto; somente
  dependências de animação são permitidas.
- **FR-006**: O sistema MUST respeitar a preferência de reduzir movimento do aparelho.
- **FR-007**: Os textos das telas de estado MUST ser definidos pela ViewModel da cena, e não
  dentro da animação.
- **FR-008**: As telas de estado MUST funcionar nos temas claro e escuro, usando os tokens do
  Design System.

### Key Entities

- **Tipo de estado**: carregando, erro, não encontrado, indisponível, fora do ar, sem internet, pagamento
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
  usados pelas features 004–008. Usa a detecção de fora do ar da 002. As telas de pagamento
  são entregues como componentes prontos e ligadas aos resultados reais quando a 007 for
  implementada; até lá, são exercitadas com estados simulados no Sample App.
- O componente `StateView` existente no Design System é a base a ser estendida.
- "Café de Java desligado" foi interpretado como uma xícara de café estilizada, apagada, caindo
  de um letreiro luminoso, em arte original do projeto, sem uso de logotipos de terceiros.
- O tempo mínimo da animação de login é de 600 ms.
- Tempos de referência do resultado do pagamento (da prévia `visual-nao-implementado-02`,
  ajustáveis no plano): cerca de 1,5 s para o líquido ou a fumaça cobrir a tela, o símbolo logo
  depois, e cerca de 0,8 s para a passagem de saída.
