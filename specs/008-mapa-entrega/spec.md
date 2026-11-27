# Feature Specification: Mapa de Entrega Simulado em Palmas-TO

**Feature Branch**: `008-mapa-entrega` (sem branch git; diretório `specs/008-mapa-entrega`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Mapa de delivery (usar um mapa gratuito de localização de ponto,
colocando a loja no meio da Praça dos Girassóis). Todos os endereços simulados em Palmas-TO.
Criar apenas uma simulação, sem usar outras dependências além das de animação, e deixar a
integração real como a definir."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Acompanhar a entrega no mapa (Priority: P1)

Depois de confirmar um pedido com entrega, o cliente abre o mapa interativo e vê a loja na Praça
dos Girassóis, o endereço de entrega e o entregador se movendo pelo caminho conforme o status do
pedido avança.

**Why this priority**: é o uso principal do mapa no protótipo.

**Independent Test**: fazer um pedido com entrega para um endereço de demonstração, abrir o mapa
e ver loja, destino e entregador avançando até "entregue".

**Acceptance Scenarios**:

1. **Given** um pedido com entrega em andamento, **When** o cliente abre o mapa, **Then** vê o
   marcador da loja na Praça dos Girassóis, o marcador do destino e o entregador.
2. **Given** o status do pedido avança, **When** o mapa está aberto, **Then** o entregador se
   move pelo trajeto e o tempo estimado diminui.
3. **Given** o pedido entregue, **When** o mapa é aberto, **Then** o entregador aparece no
   destino com o status "Entregue".
4. **Given** um pedido para retirada, **When** o cliente abre o mapa, **Then** vê só a loja, com
   a indicação "Retire aqui".

---

### User Story 2 - Escolher o endereço de entrega no mapa (Priority: P2)

Na tela do pedido, o cliente toca em "Alterar endereço", vê o mapa simulado de Palmas e escolhe
um dos pontos de entrega de demonstração (ou um ponto no mapa dentro da área atendida).

**Why this priority**: o usuário decidiu (2026-11-27) que o mapa serve para os dois usos:
acompanhar a entrega e escolher o endereço. Escolher vem depois de acompanhar, porque o pedido
já tem um endereço padrão.

**Independent Test**: escolher um endereço no mapa e vê-lo aplicado ao pedido, com a taxa de
entrega recalculada pelo servidor.

**Acceptance Scenarios**:

1. **Given** a tela do pedido, **When** o cliente escolhe um ponto de demonstração no mapa,
   **Then** o endereço do pedido é atualizado.
2. **Given** um ponto fora da área atendida, **When** ele tenta escolher, **Then** vê "Fora da
   área de entrega".

### Edge Cases

- O mapa não carrega: o app mostra o endereço em texto e o status do pedido, sem travar.
- Destino muito próximo da loja: o trajeto continua visível, com zoom adequado.
- Rotação da tela e telas pequenas: loja e destino continuam visíveis.
- O painel lateral do carrinho (feature 007) não aparece no mapa.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema MUST exibir um mapa simulado da região central de Palmas-TO, desenhado
  pelo próprio app, sem serviços de mapa externos ou pacotes extras, com a loja na Praça dos
  Girassóis.
- **FR-002**: O mapa MUST mostrar loja, destino e entregador, com o trajeto entre a loja e o
  destino.
- **FR-003**: A posição do entregador e o tempo estimado MUST vir do servidor, conforme o status
  do pedido.
- **FR-004**: Todos os endereços, pontos e entregadores de demonstração MUST estar em Palmas-TO e
  listados na documentação.
- **FR-005**: O servidor MUST expor a localização por um ponto de extensão, para que um serviço
  de mapas ou de rastreio real substitua a simulação no futuro.
- **FR-006**: A simulação, os pontos de demonstração e **como trocar por um mapa real** (marcado
  como "a definir") MUST estar documentados em `docs/SIMULACOES.md`.
- **FR-007**: O mapa interativo MUST permitir aproximar, afastar e arrastar.
- **FR-008**: O painel lateral do carrinho MUST NOT ser exibido no mapa interativo.
- **FR-009**: O cliente MUST poder escolher o endereço de entrega no mapa, tanto entre os pontos
  de demonstração quanto tocando em um ponto dentro da área atendida; o servidor valida a área e
  recalcula a taxa de entrega.
- **FR-010**: Um ponto escolhido fora da área atendida MUST ser recusado com a mensagem "Fora da
  área de entrega".

### Key Entities

- **Loja**: nome, endereço e coordenadas (Praça dos Girassóis).
- **Ponto de entrega**: nome, endereço em Palmas-TO e coordenadas.
- **Entregador**: nome, foto e posição atual.
- **Trajeto**: sequência de pontos entre a loja e o destino.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% dos pedidos com entrega mostram loja, destino e entregador no mapa.
- **SC-002**: A posição do entregador acompanha o status do pedido em 100% das atualizações.
- **SC-003**: Em teste com usuários, 90% localizam a loja e o destino no mapa em menos de 10
  segundos.
- **SC-004**: O app não ganha nenhuma dependência de mapa.

## Assumptions

- Depende das features 002 (servidor) e 007 (pedido).
- "Palácio de Palmas" = Praça dos Girassóis (onde fica o Palácio Araguaia), confirmado pelo
  usuário.
- O mapa é uma ilustração simplificada e esquemática de Palmas (avenidas principais e praça),
  em coordenadas reais aproximadas; não tem fidelidade cartográfica.
- O avanço do entregador é simulado a partir do status do pedido; a operação explícita de
  avançar status vem da feature 002 (FR-012).
