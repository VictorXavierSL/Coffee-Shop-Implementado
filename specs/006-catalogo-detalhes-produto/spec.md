# Feature Specification: Catálogo, Detalhes do Grão, Avaliações, Favoritos e Indicação do Dia

**Feature Branch**: `006-catalogo-detalhes-produto` (sem branch git; diretório `specs/006-catalogo-detalhes-produto`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Tela de início com os produtos evidentes, semelhante ao modelo do
Figma. Cada produto, ao clicar, terá os índices de amargor, tipo de grão e ml; o grão terá o nome
e o desenho do saco de grão (mostrando índices como amargor e doçura, só a ideia). O método será
um grão em cor clara para indicar índice nulo, que vai escurecendo, semelhante às estrelas de
avaliação. No final da página haverá um índice de estrelas para reviews de usuários. Caixa de
favoritos. Ao abrir o app, aparece um popup aleatório com uma indicação do dia baseada nos
últimos pedidos e, caso não haja dados, exibe o mais consumido. Ml: manter os tamanhos padrão,
apenas trocar de um para outro."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Ver os detalhes do café com índices de grão (Priority: P1)

Na Home (como no Figma), o cliente toca em um produto e vê os detalhes: foto, nome, descrição,
nome do grão com a ilustração do saco de grão, os índices (amargor, doçura, acidez e corpo) em
uma escala de 0 a 5 grãos (claro = nulo, escuro = máximo, como estrelas) e o volume em ml do
tamanho selecionado.

**Why this priority**: é o diferencial principal do protótipo.

**Independent Test**: abrir os detalhes de dois cafés diferentes e conferir índices, grão e ml
distintos, vindos do servidor.

**Acceptance Scenarios**:

1. **Given** a Home com produtos, **When** o cliente toca em um produto, **Then** vê o nome do
   grão, a ilustração do saco de grão e os índices de amargor, doçura, acidez e corpo, cada um
   com 5 grãos preenchidos conforme o valor.
2. **Given** um índice com valor 0, **When** os detalhes são exibidos, **Then** os 5 grãos
   aparecem em cor clara.
3. **Given** os tamanhos P/M/G, **When** o cliente alterna entre eles, **Then** o volume em ml e
   o preço mudam para o tamanho escolhido.
4. **Given** um índice fracionado (ex.: 3,5), **When** exibido, **Then** aparecem 3 grãos
   escuros e 1 grão pela metade.

---

### User Story 2 - Avaliações de usuários (Priority: P2)

No final da página de detalhes, o cliente vê a nota média do café em estrelas, a quantidade de
avaliações e os comentários mais recentes.

**Why this priority**: ajuda na escolha e é pedido explicitamente no protótipo.

**Independent Test**: abrir um café com avaliações de demonstração e conferir média, quantidade
e lista.

**Acceptance Scenarios**:

1. **Given** um café com avaliações, **When** o cliente rola até o fim dos detalhes, **Then** vê
   a média (0 a 5 estrelas, com uma casa decimal), o total de avaliações e as avaliações mais
   recentes com nome, nota, data e comentário.
2. **Given** um café sem avaliações, **When** exibido, **Then** aparece "Ainda sem avaliações".
3. **Given** o cliente logado, **When** ele envia uma nota de 1 a 5 estrelas (com comentário
   opcional) para **qualquer café**, mesmo sem tê-lo pedido, **Then** a avaliação aparece na
   lista e a média é recalculada.
4. **Given** um cliente que já avaliou o café, **When** ele avalia de novo, **Then** a avaliação
   anterior é substituída (uma por cliente por café).
5. **Given** um comentário vazio ou só com espaços, **When** ele envia, **Then** a avaliação é
   salva só com a nota; um comentário acima de 500 caracteres é recusado com mensagem clara.

---

### User Story 3 - Favoritos (Priority: P2)

O cliente favorita cafés (na Home ou nos detalhes) e acessa a caixa de favoritos com todos
eles. Os favoritos ficam salvos na conta, no servidor.

**Why this priority**: o app já tem favoritos em memória; agora eles precisam persistir.

**Independent Test**: favoritar dois cafés, sair, entrar de novo e encontrá-los na caixa de
favoritos.

**Acceptance Scenarios**:

1. **Given** um café não favorito, **When** o cliente toca no coração, **Then** ele vai para a
   caixa de favoritos.
2. **Given** a caixa de favoritos, **When** o cliente desfavorita um café, **Then** ele some da
   lista.
3. **Given** favoritos salvos, **When** o cliente entra em outro aparelho com a mesma conta,
   **Then** vê os mesmos favoritos.
4. **Given** nenhum favorito, **When** a caixa é aberta, **Then** aparece o estado vazio com uma
   sugestão para explorar o cardápio.

---

### User Story 4 - Popup de indicação do dia (Priority: P3)

Ao abrir o app (já logado), aparece de forma aleatória um popup com a "indicação do dia": um
café sugerido com base nos últimos pedidos do cliente ou, sem histórico, o café mais consumido
da loja. Pelo popup dá para ver os detalhes ou fechar.

**Why this priority**: é um encantamento, não bloqueia o uso.

**Independent Test**: com o usuário de demonstração com histórico, abrir o app várias vezes e
ver a indicação baseada nos pedidos; com uma conta nova, ver o mais consumido.

**Acceptance Scenarios**:

1. **Given** um cliente com pedidos, **When** o popup aparece, **Then** sugere um café
   relacionado aos últimos pedidos (mesma categoria ou mesmo grão), de preferência um que ele
   ainda não pediu.
2. **Given** um cliente sem pedidos, **When** o popup aparece, **Then** sugere o café mais
   consumido da loja.
3. **Given** a abertura do app, **When** o sorteio não escolhe mostrar o popup, **Then** o app
   segue direto para a Home.
4. **Given** o popup aberto, **When** o cliente toca em "Ver café", **Then** vai para os
   detalhes daquele café.

### Edge Cases

- Café indisponível ou removido: abrir os detalhes mostra o estado "café indisponível"
  (feature 003).
- Índice ausente para um café: o índice é ocultado, e não mostrado como 0.
- Falha ao carregar avaliações não impede ver o resto dos detalhes.
- Falha ao calcular a indicação do dia: o popup não aparece, sem erro para o cliente.
- O popup nunca aparece sobre uma tela de erro nem durante o login.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A Home MUST seguir o layout do Figma (localização, busca, filtro, banner,
  categorias, grade de produtos), com dados do servidor.
- **FR-002**: Cada produto MUST ter um grão com nome, origem e ilustração do saco de grão.
- **FR-003**: Cada produto MUST ter os índices de amargor, doçura, acidez e corpo, de 0 a 5, em
  passos de 0,5.
- **FR-004**: Os índices MUST ser exibidos como 5 grãos que vão do claro (nulo) ao escuro
  (máximo), no mesmo modelo visual das estrelas, como componente reutilizável do Design System.
- **FR-005**: Cada tamanho (P/M/G) MUST ter volume em ml e preço próprios; trocar o tamanho
  atualiza os dois.
- **FR-006**: O fim da página de detalhes MUST mostrar a média em estrelas, o total de
  avaliações e as avaliações mais recentes (até 5, com opção de ver mais).
- **FR-006a**: Qualquer cliente logado MUST poder avaliar qualquer café (nota de 1 a 5 e
  comentário opcional de até 500 caracteres), com uma avaliação por cliente por café,
  editável. A média e o total MUST ser calculados pelo servidor.
- **FR-007**: Favoritos MUST ser salvos por conta no servidor e listados em uma caixa de
  favoritos.
- **FR-008**: Ao abrir o app logado, o sistema MUST sortear se mostra o popup de indicação do
  dia.
- **FR-009**: A indicação MUST ser calculada no servidor: baseada nos últimos pedidos do cliente
  ou, sem histórico, no café mais consumido.
- **FR-010**: As ilustrações (saco de grão, grãos dos índices) MUST ficar em local separado e
  identificado, para poderem ser trocadas sem alterar as telas.

### Key Entities

- **Grão**: nome, origem e ilustração.
- **Perfil sensorial**: amargor, doçura, acidez e corpo (0 a 5) de um produto.
- **Tamanho**: código (P/M/G), volume em ml e preço.
- **Avaliação**: cliente, produto, nota (1 a 5), comentário opcional e data.
- **Favorito**: vínculo cliente ↔ produto.
- **Indicação do dia**: produto sugerido e motivo ("baseado nos seus pedidos" ou "mais pedido
  da loja").

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Em teste com usuários, 90% identificam corretamente qual de dois cafés é mais
  amargo só olhando os grãos.
- **SC-002**: A troca de tamanho atualiza ml e preço instantaneamente (sem espera perceptível).
- **SC-003**: Favoritos permanecem após sair e entrar de novo em 100% dos casos.
- **SC-004**: Ao longo de 10 aberturas do app, o popup aparece pelo menos 1 vez e não aparece
  sempre.
- **SC-005**: Para um cliente com histórico, 100% das indicações têm relação com os pedidos
  (categoria ou grão).

## Assumptions

- Depende das features 002 (servidor) e 005 (conta logada).
- Índices adicionais ao amargor (doçura, acidez, corpo) foram adotados a partir da ideia
  "amargura, doce e outros" do protótipo.
- Probabilidade padrão do popup: 50% por abertura do app, no máximo uma vez por abertura.
- Volumes padrão: P = 150 ml, M = 250 ml, G = 350 ml, ajustáveis por produto.
- O conceito visual do índice é original (grãos claros/escuros); não reproduz arte de jogos
  existentes.
