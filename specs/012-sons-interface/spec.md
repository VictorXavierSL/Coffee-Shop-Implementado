# Feature Specification: Sons das Telas de Animação e dos Botões

**Feature Branch**: `012-sons-interface` (sem branch git; diretório `specs/012-sons-interface`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Cada tela de animação deve ter um som, de uma base gratuita
(colocando os créditos no repositório), e cada botão deve ter um som baixo e cativante. Os sons
devem seguir o tema de café (menos os botões e o fora do ar, que terá um som de energia caindo
para a tela e da caneca caindo). Para a tela de 'algo deu errado', colocar uma animação da xícara
caindo e derramando o café."

> **Ordem de implementação:** vem depois de todas (001 → 011 → **012**). Os sons são acrescentados
> sobre as telas e animações prontas da 003 e sobre os botões do Design System.
>
> **Mudança visual na 003:** a animação de "algo deu errado" (`coffee_spilled`) passa a ser a
> **xícara caindo e derramando o café**. O visual continua definido na 003 (registrado lá); esta
> spec define o som que acompanha cada animação.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Cada tela de animação tem o seu som (Priority: P1)

Quando uma tela de animação aparece, um som curto acompanha o que acontece na tela: café sendo
servido, xícara caindo, fumaça subindo. Os sons seguem o tema de café, exceto o do fora do ar.

**Why this priority**: é o pedido principal e dá identidade às telas de estado.

**Independent Test**: provocar cada tela de animação (com os cenários de demonstração da 007 e o
servidor parado) e ouvir o som certo, sincronizado com a animação.

**Acceptance Scenarios**:

1. **Given** cada tela de animação da tabela de sons (FR-002), **When** ela aparece, **Then** toca
   o som indicado, começando junto com a animação.
2. **Given** o fora do ar, **When** a tela aparece, **Then** toca um som de energia desligando e,
   quando a caneca cai do letreiro, o som da caneca caindo.
3. **Given** o erro inesperado, **When** a tela aparece, **Then** a xícara cai e derrama o café, e
   os sons de queda e de líquido derramando acompanham a animação.
4. **Given** a animação de loading (café fumegante) em espera longa, **When** o som termina,
   **Then** ele não fica repetindo durante toda a espera.

---

### User Story 2 - Botões com som baixo e cativante (Priority: P2)

Cada toque em um botão produz um som curto, baixo e agradável, que confirma o toque sem chamar
atenção demais.

**Why this priority**: dá retorno ao toque; o app funciona sem isso.

**Independent Test**: tocar nos botões principais (primário, secundário, "+" do produto, ícones)
e ouvir o som de toque em volume menor que o das telas de animação.

**Acceptance Scenarios**:

1. **Given** qualquer botão ativo, **When** o cliente toca nele, **Then** ouve o som de toque, uma
   vez por toque.
2. **Given** um botão desativado, **When** o cliente toca nele, **Then** nenhum som toca.
3. **Given** toques rápidos seguidos, **When** eles acontecem, **Then** os sons não se acumulam
   nem ficam altos.

---

### User Story 3 - Controlar ou silenciar os sons (Priority: P2)

O cliente desliga os sons no perfil, e o app respeita o modo silencioso do aparelho.

**Why this priority**: som inesperado incomoda; o controle precisa existir desde o início.

**Independent Test**: desligar os sons no perfil, reabrir o app e conferir que nenhuma tela toca
som; com o aparelho no silencioso, conferir o mesmo.

**Acceptance Scenarios**:

1. **Given** a opção "Sons do app" desligada, **When** qualquer animação ou botão é usado,
   **Then** nada toca, e a escolha continua valendo depois de reabrir o app.
2. **Given** o aparelho no modo silencioso, **When** o app está aberto, **Then** nenhum som toca.
3. **Given** uma música ou outro áudio tocando no aparelho, **When** um som do app toca, **Then**
   o outro áudio não é interrompido.

---

### User Story 4 - Créditos e troca dos sons (Priority: P3)

Quem abre o repositório encontra os créditos de cada som (autor, base, licença e link) e
consegue trocar um som só substituindo o arquivo, sem mexer nas telas.

**Why this priority**: os créditos são exigidos pelas licenças das bases gratuitas.

**Independent Test**: conferir que todo arquivo de som tem crédito em `docs/CREDITOS.md` e trocar
um som seguindo `docs/ASSETS.md`.

**Acceptance Scenarios**:

1. **Given** os arquivos de som do app, **When** a pessoa abre `docs/CREDITOS.md`, **Then** cada
   um tem autor, base de origem, licença e link.
2. **Given** um som novo com o mesmo identificador, **When** ele substitui o antigo, **Then** o app
   passa a tocar o novo em todas as telas que o usam.

### Edge Cases

- Arquivo de som ausente ou corrompido: a animação continua normalmente, sem som e sem erro.
- Duas telas de animação seguidas (ex.: loading → resultado do pagamento): o som anterior para
  antes do próximo começar.
- O app vai para segundo plano: os sons param.
- Com "reduzir movimento" ativado, as telas mostram a imagem estática (003) e tocam só o som
  final, curto.
- O cliente toca em um botão que leva a uma tela de animação: o som do botão toca e logo depois
  o da animação, sem sobrepor alto.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Toda tela de animação da spec 003 MUST ter um som próprio, sincronizado com a
  animação, com duração de no máximo 3 segundos e sem repetição contínua.
- **FR-002**: Os sons MUST seguir esta tabela; os identificadores seguem os das animações (003):

  | Tela (animação) | Som | Tema de café |
  |---|---|---|
  | Loading / login (`coffee_steaming`) | Café sendo servido na xícara, suave | Sim |
  | Erro inesperado (`coffee_spilled`) | Xícara caindo, batida e café derramando | Sim |
  | Não encontrado / indisponível (`cup_empty`) | Colher batendo numa xícara vazia | Sim |
  | Fora do ar (`server_down`) | Energia desligando e, em seguida, a caneca caindo do letreiro | Não |
  | Sem internet (`no_internet`) | Chiado de vapor suave que se apaga conforme os arcos do Wi-Fi somem; quando a rede volta, o chiado sobe de novo e se junta ao som do líquido subindo | Sim |
  | Pagamento aprovado (`payment_success`) | Café enchendo e um tilintar curto de xícara | Sim |
  | Pagamento recusado / estornado (`payment_failure`) | Chiado de vapor (fumaça) e um tom grave curto | Sim |
  | Toque em botão | Clique baixo e agradável | Não |

- **FR-003**: Todo botão ativo do Design System MUST tocar o som de toque, uma vez por toque, em
  volume menor que o das telas de animação; botões desativados MUST NOT tocar som.
- **FR-004**: Os sons MUST vir de bases gratuitas com licença que permita o uso no projeto, de
  preferência sem exigência de atribuição, ou com atribuição atendida.
- **FR-005**: Os créditos de cada som (arquivo, autor, base de origem, licença e link) MUST ficar
  em `docs/CREDITOS.md`, citado no README.
- **FR-006**: Cada som MUST ser um recurso separado e identificado, guardado junto das animações e
  listado em `docs/ASSETS.md` com instruções de troca, para ser substituído sem alterar telas.
- **FR-007**: O perfil MUST ter a opção "Sons do app" (ligada por padrão), salva no aparelho, que
  desliga todos os sons.
- **FR-008**: O app MUST respeitar o modo silencioso do aparelho e MUST NOT interromper outro
  áudio que esteja tocando.
- **FR-009**: A falta ou falha de um som MUST NOT impedir a animação nem gerar mensagem de erro.
- **FR-010**: A tela de erro inesperado MUST mostrar a xícara caindo e derramando o café (visual
  registrado na spec 003), e o som MUST acompanhar a queda e o derramamento.
- **FR-011**: Esta feature é uma **exceção ao princípio X** da constitution (só dependências de
  animação), decidida pelo usuário em 2026-11-27: o `/speckit-plan` MUST justificar por escrito o
  pacote de áudio escolhido.

### Key Entities

- **Recurso de som**: identificador (o mesmo da animação ou "toque de botão"), arquivo, duração,
  volume relativo, autor, base de origem, licença e link.
- **Preferência de som**: ligado ou desligado, guardada no aparelho.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% das telas de animação tocam o som da tabela (FR-002) ao aparecer.
- **SC-002**: 100% dos arquivos de som têm crédito completo em `docs/CREDITOS.md`.
- **SC-003**: Com "Sons do app" desligado ou o aparelho no silencioso, 0 sons tocam.
- **SC-004**: Nenhum som passa de 3 segundos; o som de toque dura menos de 0,3 segundo.
- **SC-005**: Trocar um som exige alterar 0 arquivos de tela.
- **SC-006**: Em teste com usuários, 80% acham o som de toque agradável e não incômodo.

## Assumptions

- Depende da 003 (animações) e das telas das features 005–011 (a opção "Sons do app" fica na tela de usuário, 010); por isso vem por último (012).
- Bases gratuitas sugeridas: sons com licença de domínio público (CC0) ou livres de uso, como
  Freesound (filtro CC0), Pixabay e Kenney; a escolha final fica para o plano.
- Volume de referência: toque de botão em cerca de 30% do volume das telas de animação.
- Vibração (retorno tátil) e música de fundo estão fora do escopo.
- O som de "não encontrado" e o de pagamento recusado foram propostos para manter o tema de café;
  podem ser trocados no plano.
