# Feature Specification: Carrinho Lateral, Carrinho Completo e Pagamento Simulado

**Feature Branch**: `007-carrinho-pagamento` (sem branch git; diretório `specs/007-carrinho-pagamento`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Um painel de carrinho lateral e um completo, suporte a pagamentos
diversos (apenas o fluxo de confirmação, sem uso de gateway de pagamento real). O painel lateral
deve aparecer sempre que possível, menos no mapa interativo, com botão para a tela completa. Na
confirmação de pagamento, se a solicitação for enviada ao banco, a API deve esperar até o
banco/gateway devolver a resposta para exibir o resultado e, se der problema, já solicitar o
reembolso. O resultado é aleatório, mas alguns produtos sempre dão erro para demonstrar e outros
sempre dão certo (o certo é a prioridade); isso fica na documentação, junto com como tirar."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Pagar e receber a confirmação do banco (Priority: P1)

Na tela completa do pedido, o cliente escolhe a forma de pagamento e toca em "Fazer pedido". O
app mostra "Processando pagamento" enquanto aguarda a resposta do banco simulado. Se aprovado, o
pedido é confirmado e segue para o acompanhamento; se recusado, o cliente vê o motivo e pode
tentar de novo ou trocar a forma de pagamento.

**Why this priority**: fecha o fluxo de compra, que é o coração do app.

**Independent Test**: com um produto de demonstração "sempre aprova", concluir um pedido; com um
"sempre recusa", ver a recusa e nenhum pedido confirmado.

**Acceptance Scenarios**:

1. **Given** um carrinho com itens, **When** o cliente confirma o pagamento, **Then** vê
   "Processando pagamento" até a resposta do banco simulado.
2. **Given** a resposta "aprovado", **When** ela chega, **Then** o pedido é confirmado, a
   confirmação de sucesso aparece e o cliente segue para o acompanhamento.
3. **Given** a resposta "recusado", **When** ela chega, **Then** a mensagem de falha aparece,
   nenhum pedido é confirmado e o carrinho é mantido.
4. **Given** o banco aprovou mas a confirmação do pedido falhou depois, **When** isso acontece,
   **Then** o servidor solicita o estorno automaticamente e o cliente vê "Não foi possível
   concluir o pedido. O valor foi estornado."

---

### User Story 2 - Carrinho lateral sempre à mão (Priority: P1)

Em qualquer tela de compra (Home, Detalhes, Favoritos...), o cliente abre um painel lateral com
os itens do carrinho, ajusta quantidades, remove itens e vê o subtotal. Pelo painel ele vai à
tela completa do pedido. O painel não aparece no mapa interativo.

**Why this priority**: o protótipo pede explicitamente o carrinho lateral.

**Independent Test**: adicionar itens na Home, abrir o painel, alterar quantidades e ir para a
tela completa com os mesmos itens.

**Acceptance Scenarios**:

1. **Given** itens no carrinho, **When** o cliente abre o painel lateral, **Then** vê itens,
   quantidades, tamanhos e subtotal calculado pelo servidor.
2. **Given** o painel aberto, **When** o cliente altera a quantidade ou remove um item, **Then**
   o subtotal é recalculado.
3. **Given** o painel aberto, **When** o cliente toca em "Ver carrinho completo", **Then** vai
   para a tela completa do pedido.
4. **Given** o mapa interativo aberto, **When** o cliente procura o painel, **Then** ele não
   está disponível.
5. **Given** o carrinho vazio, **When** o painel é aberto, **Then** mostra o estado vazio.

---

### User Story 3 - Formas de pagamento diversas (Priority: P2)

O cliente escolhe entre Pix, cartão de crédito, cartão de débito e dinheiro na entrega. Para
cartão, informa dados fictícios de demonstração; para Pix, vê um código fictício para "pagar".

**Why this priority**: o protótipo pede pagamentos diversos, mesmo que só o fluxo.

**Independent Test**: concluir um pedido com cada forma de pagamento usando os dados de
demonstração documentados.

**Acceptance Scenarios**:

1. **Given** a tela de pagamento, **When** o cliente escolhe uma forma, **Then** vê só os campos
   ou instruções daquela forma.
2. **Given** dados de cartão com formato inválido, **When** ele confirma, **Then** vê qual campo
   está errado antes de enviar.
3. **Given** "dinheiro na entrega", **When** ele confirma, **Then** o pedido é confirmado sem
   etapa de banco, com o campo opcional "troco para".

---

### User Story 4 - Cenários de demonstração previsíveis (Priority: P2)

Para apresentar o app, existem produtos de demonstração que sempre têm o pagamento aprovado e
outros que sempre têm o pagamento recusado. Os demais têm resultado aleatório, com aprovação
mais provável.

**Why this priority**: torna as demonstrações de sucesso e de erro reproduzíveis.

**Independent Test**: seguir `docs/SIMULACOES.md` para disparar aprovação, recusa e estorno; e
seguir as instruções de remoção para desligar a simulação.

**Acceptance Scenarios**:

1. **Given** um carrinho com um produto "sempre recusa", **When** o cliente paga, **Then** o
   pagamento é recusado.
2. **Given** um carrinho só com produtos "sempre aprova", **When** o cliente paga, **Then** o
   pagamento é aprovado.
3. **Given** só produtos comuns, **When** o cliente paga várias vezes, **Then** a maioria é
   aprovada e algumas são recusadas.

### Edge Cases

- O cliente toca em "Fazer pedido" várias vezes ou perde a conexão e tenta de novo: a mesma
  tentativa nunca gera duas cobranças (identificador único por tentativa).
- O banco simulado não responde dentro do tempo limite: o pagamento fica "não confirmado", o
  servidor estorna o que tiver sido aprovado e o cliente é informado.
- O carrinho tem um produto que ficou indisponível: o servidor recusa o pedido antes do
  pagamento, indicando o item.
- O preço mudou entre o carrinho e o pagamento: vale o valor recalculado pelo servidor, mostrado
  antes da confirmação.
- O carrinho com produto "sempre recusa" e produto "sempre aprova" ao mesmo tempo: a recusa
  prevalece.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema MUST oferecer um painel lateral de carrinho em todas as telas de compra,
  exceto no mapa interativo, com acesso à tela completa do pedido.
- **FR-002**: O carrinho MUST ser mantido no servidor por conta; valores (subtotal, taxas,
  descontos, total) MUST ser calculados pelo servidor.
- **FR-003**: O sistema MUST suportar Pix, cartão de crédito, cartão de débito e dinheiro na
  entrega, todos simulados, sem gateway real.
- **FR-004**: O pedido MUST ser confirmado somente após a resposta do banco simulado.
- **FR-005**: O pagamento MUST seguir os estados: pendente → aprovado ou recusado; aprovado →
  estornado quando algo falha depois da aprovação.
- **FR-006**: Se a confirmação do pedido falhar após a aprovação, o servidor MUST solicitar o
  estorno automaticamente e informar o cliente.
- **FR-007**: Cada tentativa de pagamento MUST ter um identificador único, e reenvios da mesma
  tentativa MUST NOT gerar nova cobrança.
- **FR-008**: O resultado simulado MUST seguir esta ordem: produto "sempre recusa" → recusado;
  todos os produtos "sempre aprova" → aprovado; caso contrário, aleatório com 80% de aprovação.
- **FR-009**: Os produtos de demonstração de cada cenário, a probabilidade e **como remover ou
  trocar a simulação** MUST estar documentados em `docs/SIMULACOES.md`.
- **FR-010**: O banco simulado MUST ficar atrás de um ponto de extensão no servidor, para que um
  gateway real o substitua sem mudar o app nem o contrato da API.
- **FR-011**: O app MUST exibir telas distintas para processando, aprovado, recusado e estornado;
  as animações são da feature 003.
- **FR-012**: Dados de cartão MUST NOT ser armazenados; só a forma de pagamento e os 4 últimos
  dígitos podem ser guardados no pedido. Exceção da spec 011 (decisão do usuário em
  2026-11-27): cartões de demonstração salvos na conta guardam só bandeira, 4 últimos dígitos,
  nome impresso e validade; número completo e código de segurança continuam proibidos.

### Key Entities

- **Carrinho**: itens (produto, tamanho, quantidade) de um cliente.
- **Pedido**: itens, entrega, endereço, resumo de valores, status do pedido e pagamento.
- **Tentativa de pagamento**: identificador, pedido, forma, valor, estado
  (pendente/aprovado/recusado/estornado), motivo e datas.
- **Estorno**: tentativa de origem, valor, motivo e data.
- **Cenário de demonstração**: marcação do produto como "sempre aprova", "sempre recusa" ou
  comum.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: O cliente conclui um pedido do carrinho à confirmação em menos de 1 minuto.
- **SC-002**: 0 cobranças duplicadas em 100 reenvios da mesma tentativa.
- **SC-003**: 100% das aprovações seguidas de falha geram estorno registrado e aviso ao cliente.
- **SC-004**: Os produtos "sempre aprova" e "sempre recusa" se comportam assim em 100% das
  tentativas; os comuns ficam entre 70% e 90% de aprovação em 100 tentativas.
- **SC-005**: Uma pessoa consegue desligar a simulação aleatória seguindo apenas
  `docs/SIMULACOES.md`.

## Assumptions

- Depende das features 002 (servidor) e 005 (conta logada) e usa o catálogo da 006.
- Formas de pagamento adotadas: Pix, crédito, débito e dinheiro (padrão no Brasil).
- Tempo simulado de resposta do banco: 1 a 3 segundos; tempo limite: 15 segundos.
- A tela completa do pedido estende a cena `order` existente (entrega/retirada, endereço,
  itens, desconto, resumo).
- O fluxo de estorno foi recomendado e aprovado pelo usuário em 2026-11-27.
