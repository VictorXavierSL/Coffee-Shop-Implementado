# Feature Specification: Cadastro de Cartões de Demonstração

**Feature Branch**: `011-cadastro-cartoes` (sem branch git; diretório `specs/011-cadastro-cartoes`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Tela de cadastro de cartões, simples e direta, seguindo os temas do
app. É apenas teste: não deve confirmar os cartões, apenas exibir um exemplo de cadastro. Acesso
pelo pagamento do pedido e pelo perfil (Meus cartões)."

> **Ordem de implementação:** vem depois da tela de usuário (001 → 010 → **011**). Depende da 005
> (conta logada), da 007 (pagamento com cartão de crédito e débito) e da 010 (perfil, onde fica
> "Meus cartões").

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Cadastrar um cartão de exemplo (Priority: P1)

O cliente abre a tela de cadastro, preenche número, nome impresso, validade e código de
segurança, e salva. O app confere só o formato dos dados, sem consultar banco nenhum, e o cartão
aparece na lista "Meus cartões" com a bandeira e os 4 últimos dígitos.

**Why this priority**: é o fluxo pedido; sem ele a tela não tem função.

**Independent Test**: cadastrar um dos cartões de demonstração documentados e vê-lo na lista,
mascarado, sem nenhuma etapa de confirmação.

**Acceptance Scenarios**:

1. **Given** a tela de cadastro, **When** o cliente preenche dados com formato válido e toca em
   "Salvar cartão", **Then** volta para a origem e o cartão aparece como "Visa •••• 4242", com
   nome e validade.
2. **Given** um número com formato inválido, validade vencida ou código de segurança incompleto,
   **When** o cliente tenta salvar, **Then** o campo com problema é indicado e nada é salvo.
3. **Given** o cadastro salvo, **When** o cliente olha o cartão, **Then** em nenhum lugar aparece
   o número completo nem o código de segurança.
4. **Given** qualquer cartão com formato válido, **When** salvo, **Then** é aceito sem nenhuma
   etapa de confirmação (sem cobrança de teste, código por SMS ou consulta ao banco).

---

### User Story 2 - Ver o cartão tomando forma enquanto digita (Priority: P2)

No topo da tela, uma imagem do cartão mostra o número, o nome e a validade conforme o cliente
digita, com a bandeira reconhecida pelos primeiros dígitos.

**Why this priority**: deixa a tela direta e fácil de conferir; o cadastro funciona sem isso.

**Independent Test**: digitar um número começando por 4 e por 5 e ver a bandeira e os dados
mudarem na imagem do cartão.

**Acceptance Scenarios**:

1. **Given** a tela vazia, **When** o cliente começa a digitar, **Then** a imagem do cartão mostra
   os dados digitados no lugar dos espaços de exemplo.
2. **Given** os primeiros dígitos, **When** a bandeira é reconhecida, **Then** a imagem mostra o
   nome da bandeira; se não for reconhecida, mostra "Cartão".

---

### User Story 3 - Gerenciar "Meus cartões" (Priority: P2)

Pelo perfil, o cliente abre "Meus cartões", vê os cartões cadastrados, adiciona outro ou remove
um que não quer mais.

**Why this priority**: o usuário pediu o acesso pelo perfil além do pagamento.

**Independent Test**: cadastrar dois cartões, remover um e conferir a lista; sem cartões, ver o
estado vazio.

**Acceptance Scenarios**:

1. **Given** cartões cadastrados, **When** o cliente abre "Meus cartões", **Then** vê cada um com
   bandeira, 4 últimos dígitos, nome e validade.
2. **Given** um cartão na lista, **When** o cliente o remove e confirma, **Then** ele some da lista
   e deixa de aparecer no pagamento.
3. **Given** nenhum cartão, **When** a lista é aberta, **Then** aparece o estado vazio com o botão
   "Adicionar cartão".

---

### User Story 4 - Usar um cartão salvo no pagamento (Priority: P2)

No pagamento do pedido, ao escolher crédito ou débito, o cliente escolhe um cartão salvo ou toca
em "Adicionar cartão", cadastra e volta ao pagamento com o novo cartão já escolhido.

**Why this priority**: é o segundo acesso pedido e liga a tela ao fluxo de compra da 007.

**Independent Test**: no pagamento, adicionar um cartão e ver que ele volta selecionado; fazer o
pedido e conferir que o resultado segue as regras da 007.

**Acceptance Scenarios**:

1. **Given** o pagamento com crédito ou débito, **When** o cliente toca em "Adicionar cartão" e
   salva, **Then** volta ao pagamento com esse cartão selecionado.
2. **Given** um cartão salvo selecionado, **When** o cliente confirma o pedido, **Then** o app pede
   só o código de segurança daquela compra, e o resultado segue a simulação da 007.

### Edge Cases

- Cartão já cadastrado (mesma bandeira, 4 últimos dígitos e validade): o app avisa "Este cartão já
  está cadastrado" e não duplica.
- Espaços e traços no número são ignorados; o número aparece agrupado de 4 em 4.
- Validade no mês atual é aceita; mês anterior ao atual é recusado.
- O cliente sai da tela com dados preenchidos: o app pergunta se quer descartar o cadastro.
- Limite de 5 cartões por conta: ao atingir, "Adicionar cartão" fica indisponível com a explicação.
- A tela funciona nos temas claro e escuro.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema MUST oferecer uma tela de cadastro de cartão com os campos número, nome
  impresso, validade (MM/AA) e código de segurança, e um botão "Salvar cartão".
- **FR-002**: O cadastro MUST ser só uma demonstração: o sistema confere apenas o formato (número
  de 13 a 19 dígitos com dígito verificador válido, validade não vencida, código de 3 ou 4
  dígitos) e MUST NOT confirmar o cartão com banco ou gateway, nem por cobrança de teste.
- **FR-003**: O sistema MUST guardar do cartão só os dados mascarados: bandeira, 4 últimos
  dígitos, nome impresso e validade, ligados à conta. O número completo e o código de segurança
  MUST NOT ser guardados nem devolvidos pela API (spec 007, FR-012).
- **FR-004**: O código de segurança MUST ser pedido de novo a cada compra com cartão salvo e
  descartado depois do envio.
- **FR-005**: A tela MUST ser acessível pelo pagamento do pedido ("Adicionar cartão", ao escolher
  crédito ou débito) e pelo perfil ("Meus cartões").
- **FR-006**: "Meus cartões" MUST listar os cartões da conta e permitir adicionar e remover, com
  confirmação antes de remover.
- **FR-007**: A tela MUST mostrar uma imagem do cartão que se atualiza enquanto o cliente digita,
  reconhecendo ao menos Visa, Mastercard e Elo pelos primeiros dígitos.
- **FR-008**: A tela MUST seguir o Design System (tokens, componentes por Factory e temas claro e
  escuro) e usar os componentes existentes de campo de texto e botão.
- **FR-009**: Os cartões de demonstração e o comportamento simulado MUST estar documentados em
  `docs/SIMULACOES.md`, junto com como trocar por uma tokenização real.
- **FR-010**: Erros de formato MUST aparecer no próprio campo; cartão repetido e limite de cartões
  MUST ter mensagens próprias, seguindo o catálogo de inter telas da 004.

### Key Entities

- **Cartão salvo**: conta dona, identificador, bandeira, 4 últimos dígitos, nome impresso,
  validade e data de cadastro. Nunca contém o número completo nem o código de segurança.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Um cliente cadastra um cartão de demonstração em menos de 1 minuto.
- **SC-002**: 0 ocorrências do número completo ou do código de segurança no banco, nas respostas
  da API ou nos registros.
- **SC-003**: 100% dos cadastros com formato válido são aceitos sem etapa de confirmação.
- **SC-004**: 100% dos erros de formato são apontados no campo certo antes de salvar.
- **SC-005**: A tela aparece corretamente nos temas claro e escuro em 100% das verificações.

## Assumptions

- Depende da 005 (conta logada) e da 007 (pagamento); e da 010 (tela de usuário); por isso é a 011.
- "Cadastro de exemplo" foi interpretado como cadastro que salva, mas sem confirmação real. Guardar
  só os dados mascarados mantém a regra da 007 de não armazenar dados de cartão.
- Cartões de demonstração usam números de teste públicos de mercado (ex.: Visa 4242 4242 4242
  4242), listados em `docs/SIMULACOES.md`.
- Limite de 5 cartões por conta e bandeiras reconhecidas (Visa, Mastercard, Elo) são padrões
  adotados e podem ser ajustados no plano.
- Escolher um cartão padrão e editar um cartão salvo estão fora do escopo; para mudar, remove-se e
  cadastra-se de novo.
