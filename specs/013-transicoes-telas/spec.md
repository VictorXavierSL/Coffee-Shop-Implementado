# Feature Specification: Animações de Transição entre Telas (Bônus)

**Feature Branch**: `013-transicoes-telas` (sem branch git; diretório `specs/013-transicoes-telas`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Animações de transição de telas. Para mudar de cada tela deve ter
uma animação simples, para deixar fluido e dinâmico (usando também os sons). Este é um requisito
não necessário para o projeto, apenas um plus."

> **Requisito opcional (bônus):** decisão do usuário em 2026-11-27. O projeto é considerado
> completo sem esta feature; ela só é implementada depois de todas as outras (001 → 012 →
> **013**) e pode ser deixada de fora sem afetar nenhuma outra spec. Usa os sons da 012.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Navegar com transições suaves (Priority: P1)

Ao ir de uma tela para outra, o cliente vê uma animação curta e simples que mostra de onde veio e
para onde foi: a tela nova entra pela direita e, ao voltar, sai pela direita.

**Why this priority**: é o núcleo do pedido; sem ele não há transição.

**Independent Test**: percorrer Home → Detalhes → Pedido e voltar, conferindo que cada troca tem
uma animação curta e que voltar faz o movimento inverso.

**Acceptance Scenarios**:

1. **Given** uma tela qualquer, **When** o cliente avança para outra, **Then** a nova entra pela
   direita enquanto a anterior recua levemente para a esquerda.
2. **Given** uma tela aberta, **When** o cliente volta, **Then** o movimento é o inverso do de
   entrada.
3. **Given** qualquer transição, **When** ela acontece, **Then** termina em até 350 ms e o cliente
   pode tocar na tela nova logo depois.

---

### User Story 2 - Cada tipo de troca tem seu movimento (Priority: P2)

Os movimentos combinam com o tipo de tela: abas trocam com um esmaecer rápido, painéis e janelas
sobem de baixo, e o produto da Home "cresce" até virar a tela de detalhes.

**Why this priority**: deixa o app dinâmico; o básico da US1 já atende o pedido.

**Independent Test**: trocar de aba, abrir o popup da indicação do dia, abrir o carrinho lateral e
tocar em um produto, conferindo o movimento de cada caso na tabela de transições (FR-002).

**Acceptance Scenarios**:

1. **Given** a navegação por abas, **When** o cliente troca de aba, **Then** o conteúdo esmaece de
   uma para a outra, sem deslizar.
2. **Given** um popup ou janela de confirmação, **When** ele abre, **Then** sobe de baixo com um
   leve esmaecer do fundo; ao fechar, desce.
3. **Given** um produto na Home, **When** o cliente toca nele, **Then** a foto do produto cresce
   até a posição da foto nos detalhes.

---

### User Story 3 - Transições com som (Priority: P3)

As trocas de tela principais têm um som muito baixo e curto, que acompanha o movimento, seguindo
as regras de som da 012.

**Why this priority**: o usuário pediu o uso dos sons, mas é o detalhe mais opcional do bônus.

**Independent Test**: com "Sons do app" ligado, navegar entre telas e ouvir o som de transição;
desligado, não ouvir nada.

**Acceptance Scenarios**:

1. **Given** "Sons do app" ligado, **When** o cliente muda de tela, **Then** toca um som de
   transição curto, mais baixo que o de toque dos botões.
2. **Given** um toque em botão que muda de tela, **When** a transição começa, **Then** toca só o
   som de transição, e não o de toque junto (um som por ação).
3. **Given** "Sons do app" desligado ou o aparelho no silencioso, **When** o cliente navega,
   **Then** nenhum som toca.

### Edge Cases

- Com "reduzir movimento" ativado no aparelho, as transições viram um esmaecer instantâneo (ou
  nenhuma animação), sem deslizar nem crescer.
- Toques rápidos em sequência (ex.: voltar duas vezes): a transição em andamento é concluída ou
  cortada, sem telas sobrepostas nem som duplicado.
- As transições especiais já definidas na 003 (resultado do pagamento e sem internet, com o
  líquido subindo) têm prioridade e não são substituídas pelas desta spec.
- O loading de tela inteira (004) aparece sem transição extra por cima, para não atrasar.
- O gesto de voltar do sistema acompanha o dedo e completa ou cancela a transição.
- Aparelhos mais lentos: se a transição travar, ela é encurtada, e a navegação nunca espera por
  ela.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Toda troca de tela do app MUST ter uma animação de transição simples, com duração
  entre 200 e 350 ms.
- **FR-002**: As transições MUST seguir esta tabela:

  | Tipo de troca | Movimento | Som |
  |---|---|---|
  | Avançar para uma tela | Entra pela direita; a anterior recua levemente | Sim |
  | Voltar | Inverso do avanço | Sim |
  | Trocar de aba | Esmaecer cruzado | Não |
  | Abrir popup, janela ou confirmação | Sobe de baixo, fundo escurece | Sim |
  | Carrinho lateral | Desliza da lateral (já definido na 007) | Sim |
  | Produto da Home → Detalhes | A foto do produto cresce até a posição nos detalhes | Sim |
  | Login → Home, Launch → Home | Esmaecer com leve aproximação | Não |
  | Resultado do pagamento e sem internet | Passagem do líquido definida na 003 (sem mudança) | Da 012 |

- **FR-003**: Voltar MUST fazer o movimento inverso do avanço, inclusive pelo gesto do sistema.
- **FR-004**: As transições MUST respeitar a preferência de reduzir movimento do aparelho.
- **FR-005**: O som de transição MUST ser curto (menos de 0,4 s) e mais baixo que o som de toque
  dos botões; quando a troca vem de um toque, MUST tocar só o som de transição.
- **FR-006**: Os sons de transição MUST seguir as regras da 012: base gratuita com créditos em
  `docs/CREDITOS.md`, opção "Sons do app", modo silencioso e falha sem erro.
- **FR-007**: As transições MUST ficar definidas em um único lugar, com identificadores (ex.:
  `push`, `pop`, `tab_fade`, `sheet_up`, `product_hero`), listadas em `docs/ASSETS.md`, para
  poderem ser trocadas sem alterar as telas.
- **FR-008**: As transições MUST NOT atrasar a navegação: a tela nova responde a toques assim que a
  transição termina, e a navegação nunca espera por um som.
- **FR-009**: Como bônus, esta feature MUST poder ser desligada ou deixada sem implementar sem
  quebrar nenhum fluxo das features 001–012.

### Key Entities

- **Transição**: identificador, tipo de troca, movimento, duração, versão com movimento reduzido e
  som associado (opcional).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% das trocas de tela da tabela (FR-002) têm a transição definida.
- **SC-002**: Nenhuma transição passa de 350 ms.
- **SC-003**: Com "reduzir movimento" ativado, 0 transições deslizam ou crescem.
- **SC-004**: Em teste com usuários, 80% descrevem a navegação como "fluida".
- **SC-005**: As transições rodam sem travamentos perceptíveis nos aparelhos de teste.
- **SC-006**: Desligar esta feature não faz nenhum teste das features 001–012 falhar.

## Assumptions

- É opcional: a esteira de testes (009) não depende dela, e o README a lista como bônus.
- Depende da 012 (sons e opção "Sons do app"); usa só dependências de animação, permitidas pelo
  princípio X.
- Sentido "entra pela direita" segue o padrão de navegação dos aparelhos; durações de 200–350 ms
  seguem padrões de mercado.
- Os sons de transição são suaves (um "fuu" de vapor curto, no tema de café), mas a escolha final
  fica para o plano.
