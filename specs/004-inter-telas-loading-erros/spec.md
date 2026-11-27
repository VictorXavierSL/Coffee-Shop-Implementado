# Feature Specification: Inter Telas: Loading e Erros Previstos

**Feature Branch**: `004-inter-telas-loading-erros` (sem branch git; diretório `specs/004-inter-telas-loading-erros`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Adicionar as inter telas como uma nova spec: telas de loading com
a animação de café fumegante e as telas de erro previstas."

> **Divisão com a spec 003** (decisão do usuário em 2026-11-27): a **003** define o **visual**
> (os componentes de tela de estado e as animações substituíveis). Esta **004** define **onde e
> quando** cada inter tela aparece: em qual fluxo, disparada por qual situação ou código de erro
> do contrato (001), com qual texto e qual ação. Nada do visual é redefinido aqui.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Loading padronizado com o café fumegante (Priority: P1)

Sempre que o cliente espera por algo que bloqueia a tela (abrir o app, entrar, criar conta,
carregar a Home, abrir um café, enviar o pedido, processar o pagamento), aparece o mesmo loading
do café fumegante, com uma frase do contexto ("Entrando…", "Preparando seu cardápio…",
"Processando pagamento…").

**Why this priority**: o loading aparece em todos os fluxos; padronizar evita telas em branco e
spinners diferentes em cada lugar.

**Independent Test**: percorrer os fluxos da tabela de loading (FR-002) com o servidor lento de
propósito e conferir em cada um o café fumegante e a frase certa.

**Acceptance Scenarios**:

1. **Given** uma espera que bloqueia a tela, **When** ela passa de 300 ms, **Then** aparece o
   loading do café fumegante com a frase do contexto.
2. **Given** uma resposta em menos de 300 ms, **When** ela chega, **Then** nenhum loading
   aparece (para não "piscar").
3. **Given** o loading exibido, **When** a resposta chega, **Then** ele fica visível por no
   mínimo 600 ms no total, para a transição ser suave.
4. **Given** uma atualização parcial (ex.: recalcular o resumo do pedido, carregar mais
   avaliações), **When** ela acontece, **Then** aparece a versão compacta do café fumegante só
   naquela área, sem bloquear a tela inteira.

---

### User Story 2 - Cada erro previsto tem sua inter tela (Priority: P1)

Quando algo dá errado, o cliente vê a resposta certa para a situação: tela inteira para o que
impede seguir (fora do ar, café inexistente, erro inesperado), mensagem no próprio campo para
erros de digitação, aviso para sessão expirada. A resposta de cada erro previsto está no
catálogo (FR-005).

**Why this priority**: sem um catálogo, cada tela trata os erros de um jeito, e alguns acabam
sem tratamento nenhum.

**Independent Test**: provocar cada erro da tabela do catálogo (com os dados de demonstração e
o servidor) e conferir o tipo de inter tela, o texto e a ação.

**Acceptance Scenarios**:

1. **Given** cada código de erro do contrato, **When** o servidor o devolve, **Then** o app
   mostra exatamente a inter tela, o texto e a ação definidos no catálogo.
2. **Given** um erro que não está no catálogo, **When** ele ocorre, **Then** aparece a tela de
   erro inesperado (café derramado).
3. **Given** um erro de campo (validação), **When** ele ocorre, **Then** a mensagem aparece no
   campo, e não em tela inteira.

---

### User Story 3 - Prioridade e recuperação (Priority: P2)

Se vários problemas acontecem juntos, o cliente vê só o mais importante, e toda inter tela de
erro tem uma ação que leva de volta a um ponto útil, repetindo a operação ou voltando para uma
tela segura.

**Why this priority**: evita telas de erro empilhadas e becos sem saída.

**Independent Test**: com o servidor fora do ar e a sessão expirada ao mesmo tempo, ver só o
aviso de fora do ar; ao religar, tocar em "Tentar novamente" e cair no login por sessão
expirada.

**Acceptance Scenarios**:

1. **Given** dois erros ao mesmo tempo, **When** eles ocorrem, **Then** aparece só o de maior
   prioridade (FR-008).
2. **Given** uma inter tela de erro, **When** o cliente toca na ação, **Then** a operação é
   repetida ou ele vai para o destino definido no catálogo, sem perder o carrinho.
3. **Given** a mesma falha repetida, **When** o cliente tenta de novo várias vezes, **Then** a
   inter tela não se duplica e a ação continua disponível.

### Edge Cases

- O erro chega enquanto o loading ainda está no tempo mínimo: o loading termina e o erro
  aparece em seguida, sem sobreposição.
- O cliente sai da tela durante o loading: a resposta tardia é descartada e nenhuma inter tela
  aparece em outra tela.
- Falha em uma parte não essencial (avaliações, indicação do dia, foto do entregador): só aquela
  parte mostra o erro compacto (ou fica oculta), e o resto da tela funciona.
- O popup da indicação do dia falha: não aparece nada (falha silenciosa).
- Erro durante o pagamento: segue o resultado do pagamento (recusado/estornado), nunca o erro
  genérico, para não deixar dúvida se houve cobrança.
- O mapa não carrega: o endereço e o status aparecem em texto (fallback da spec 008).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Todo loading que bloqueia a tela MUST usar a animação `coffee_steaming` (spec
  003) com uma frase de contexto; atualizações parciais MUST usar a versão compacta.
- **FR-002**: O loading MUST aparecer nos fluxos abaixo, com estas frases:

  | Fluxo | Quando | Frase | Tipo |
  |---|---|---|---|
  | Launch | Verificando a sessão | "Preparando seu café…" | Tela inteira |
  | Login / Google / Apple | Enviando credenciais | "Entrando…" | Tela inteira |
  | Criar conta | Criando e confirmando o e-mail | "Confirmando e-mail…" | Tela inteira |
  | Home | Primeira carga do cardápio | "Preparando seu cardápio…" | Tela inteira |
  | Home | Trocar categoria ou buscar | — | Compacto na grade |
  | Detalhes | Abrir um café | "Moendo os grãos…" | Tela inteira |
  | Detalhes | Carregar mais avaliações | — | Compacto na lista |
  | Carrinho / Pedido | Recalcular o resumo | — | Compacto no resumo |
  | Pedido | Enviar o pedido | "Enviando seu pedido…" | Tela inteira |
  | Pagamento | Aguardando o banco | "Processando pagamento…" | Tela inteira |
  | Mapa | Carregar o mapa ou o rastreio | "Localizando seu pedido…" | Tela inteira |
  | Perfil | Enviar a foto | — | Compacto no avatar |

- **FR-003**: O loading MUST NOT aparecer em esperas de menos de 300 ms e, quando aparecer, MUST
  ficar visível por no mínimo 600 ms.
- **FR-004**: Esperas acima do tempo limite (15 s) MUST ser tratadas como falha de conexão
  (aviso de fora do ar).
- **FR-005**: O app MUST seguir este catálogo de erros previstos. Os códigos vêm do contrato
  (spec 001), e os nomes finais são confirmados no plano dele:

  | Situação / código | Inter tela | Texto | Ação |
  |---|---|---|---|
  | Sem conexão, tempo esgotado, `5xx`, `network_error` | Tela inteira **fora do ar** (`server_down`) | "Estamos fora do ar. Tente novamente em instantes." | Tentar novamente (repete) |
  | `401 unauthorized` (sessão inválida/expirada) | Aviso e ida ao Login | "Sua sessão expirou. Entre novamente." | Ir para o Login |
  | `401 invalid_credentials` | Mensagem no formulário | "Usuário ou senha incorretos." | — |
  | Conta bloqueada por tentativas | Mensagem no formulário | "Muitas tentativas. Tente novamente em X minutos." | — |
  | `400 validation_error`, senha fraca | Mensagem no campo | Texto do campo | — |
  | E-mail ou usuário já em uso | Mensagem no campo | "Este e-mail/usuário já está em uso." | — |
  | `404 product_not_found` / café indisponível | Tela inteira **copo vazio** (`cup_empty`) | "Este café está indisponível." | Voltar ao cardápio |
  | Rota/página inexistente (`404 not_found`) | Tela inteira **copo vazio** | "Esta página não existe." | Ir para o início |
  | `404 order_not_found` | Tela inteira **copo vazio** | "Não encontramos este pedido." | Ir para o início |
  | `400 empty_cart` | Estado vazio do carrinho | "Seu carrinho está vazio." | Ver cardápio |
  | `422 invalid_item` / `invalid_size` | Mensagem no carrinho, com o item destacado | "Este item não está mais disponível nesse tamanho." | Remover ou trocar |
  | `422 address_required` / fora da área | Mensagem no endereço | "Informe um endereço dentro da área de entrega." | Escolher no mapa |
  | Pagamento recusado | **Resultado do pagamento** (`payment_failure`) | "Não foi possível realizar a transação." | Tentar outra forma |
  | Pagamento estornado | **Resultado do pagamento** (`payment_failure`) | "Não foi possível concluir o pedido. O valor foi estornado." | Voltar ao carrinho |
  | Foto de perfil inválida ou grande demais | Mensagem no avatar | "Use uma foto JPG ou PNG de até 5 MB." | Escolher outra |
  | Qualquer outro erro não previsto | Tela inteira **erro** (`coffee_spilled`) | "Algo deu errado." | Tentar novamente |

- **FR-006**: Todo código de erro do contrato (spec 001) MUST ter uma linha no catálogo; um
  código novo no contrato MUST atualizar o catálogo na mesma entrega.
- **FR-007**: Textos técnicos (código HTTP, stack, nomes internos) MUST NOT aparecer ao cliente.
- **FR-008**: Prioridade quando há mais de um erro: fora do ar > sessão expirada > resultado de
  pagamento > não encontrado > erro de campo/formulário > erro parcial.
- **FR-009**: Inter telas de erro MUST NOT se empilhar; um erro novo substitui o anterior.
- **FR-010**: Toda inter tela de erro em tela inteira MUST ter uma ação que repete a operação ou
  leva a um destino seguro, sem descartar o carrinho nem a sessão válida.
- **FR-011**: Falhas em partes não essenciais (avaliações, indicação do dia, foto do
  entregador) MUST ficar restritas àquela parte.
- **FR-012**: Os textos das inter telas MUST vir da ViewModel da cena (constitution, princípio
  II) e ficar reunidos em um único lugar, para revisão.
- **FR-013**: O catálogo de loading e de erros MUST estar documentado em `docs/INTER_TELAS.md` e
  citado no README e no `docs/API.md` (coluna "inter tela" na tabela de erros).

### Key Entities

- **Inter tela de loading**: fluxo, gatilho, frase, tipo (tela inteira ou compacto).
- **Erro previsto**: situação ou código do contrato, tipo de inter tela, texto, ação,
  prioridade.
- **Ação de recuperação**: repetir a operação ou navegar para um destino seguro.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% dos códigos de erro do contrato têm entrada no catálogo.
- **SC-002**: 100% dos fluxos da tabela de loading mostram o café fumegante com a frase certa.
- **SC-003**: 0 telas em branco ou spinners fora do padrão durante esperas nos fluxos do
  protótipo.
- **SC-004**: 0 mensagens técnicas visíveis ao cliente em uma rodada provocando todos os erros
  do catálogo.
- **SC-005**: Em teste com usuários, 90% sabem o que fazer em seguida em cada tela de erro sem
  ajuda.
- **SC-006**: Nenhuma inter tela de erro aparece empilhada sobre outra em 100% dos cenários de
  erro combinado.

## Assumptions

- Depende da 001 (códigos de erro), da 002 (detecção de fora do ar) e da 003 (componentes e
  animações). As features 005–008 usam este catálogo ao implementar seus fluxos.
- Os limites de 300 ms (não mostrar), 600 ms (mínimo) e 15 s (tempo limite) seguem padrões de
  mercado e as specs 002/003, e podem ser ajustados no plano.
- Os códigos novos (bloqueio, e-mail em uso, fora da área etc.) são nomeados no plano da 001; o
  catálogo usa as situações e é atualizado com os nomes finais.
- O processamento do pagamento passa a usar o café fumegante (FR-001), em vez do spinner
  mostrado na prévia `visual-nao-implementado-01`.
