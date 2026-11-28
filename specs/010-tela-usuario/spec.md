# Feature Specification: Tela de Usuário (Perfil) com Histórico de Compras

**Feature Branch**: `010-tela-usuario` (sem branch git; diretório `specs/010-tela-usuario`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Tela de usuário, onde o usuário pode ver seus dados e editar. A
imagem que ele colocou fica ao centro, como dentro de uma caneca, e as informações ficam abaixo,
junto com um histórico de compras."

> **Ordem de implementação:** 001 → 009 → **010** → 011 → 012. Entrou como 010 (decisão do
> usuário em 2026-11-27) porque as features 011 (cadastro de cartões, acesso por "Meus cartões")
> e 012 (opção "Sons do app") dependem desta tela; as antigas 010 e 011 viraram 011 e 012.
> Depende da 005 (conta e foto de perfil), da 007 (pedidos) e da 008 (escolher endereço no mapa).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Ver o próprio perfil com a foto na caneca (Priority: P1)

O cliente abre a tela de usuário e vê, no centro, a sua foto como se estivesse dentro de uma
caneca de café, vista de cima. Abaixo ficam o nome, o nome de usuário, o e-mail, o endereço de
entrega padrão e a data de cadastro.

**Why this priority**: é a entrada da tela e o pedido principal.

**Independent Test**: entrar com o usuário de demonstração com foto e com outro sem foto, abrir o
perfil e conferir a foto (ou as iniciais) dentro da caneca e os dados abaixo.

**Acceptance Scenarios**:

1. **Given** um cliente com foto, **When** ele abre o perfil, **Then** a foto aparece no centro,
   recortada em círculo no lugar da superfície do café, dentro da borda e com a alça da caneca.
2. **Given** um cliente sem foto, **When** ele abre o perfil, **Then** a caneca mostra as
   iniciais do nome sobre a superfície do café (avatar padrão da spec 005).
3. **Given** o perfil aberto, **When** o cliente olha abaixo da caneca, **Then** vê nome, nome de
   usuário, e-mail, endereço de entrega padrão e "Cliente desde" com mês e ano.
4. **Given** uma conta criada pelo Google ou pela Apple, **When** o perfil é aberto, **Then**
   aparece a indicação do provedor ao lado do e-mail.

---

### User Story 2 - Editar os dados (Priority: P1)

O cliente toca em "Editar perfil" e altera nome, nome de usuário, foto, endereço de entrega
padrão, e-mail ou senha. Cada alteração passa pelas mesmas validações do cadastro.

**Why this priority**: o usuário pediu explicitamente ver **e editar** os dados.

**Independent Test**: alterar cada campo com o usuário de demonstração, sair, entrar de novo e
conferir os valores novos.

**Acceptance Scenarios**:

1. **Given** a edição aberta, **When** o cliente muda nome ou nome de usuário e salva, **Then** os
   dados novos aparecem no perfil; um nome de usuário já em uso é recusado com mensagem no campo.
2. **Given** a caneca, **When** o cliente toca nela (ou em "Trocar foto"), **Then** pode escolher
   da galeria, tirar com a câmera ou remover a foto, com as regras da 005 (JPG ou PNG até 5 MB).
3. **Given** a edição do endereço, **When** o cliente escolhe um ponto no mapa (008) ou um dos
   endereços de demonstração em Palmas-TO, **Then** ele vira o endereço padrão dos próximos
   pedidos; um ponto fora da área de entrega é recusado.
4. **Given** a troca de e-mail, **When** o cliente informa um e-mail novo e válido, **Then** passa
   pela confirmação simulada da 005 (sem código) e o e-mail novo passa a valer para o login.
5. **Given** a troca de senha, **When** o cliente informa a senha atual correta e uma nova que
   segue as regras da 005, **Then** a senha muda; com a senha atual errada, nada muda e aparece
   "Senha atual incorreta".
6. **Given** alterações não salvas, **When** o cliente tenta sair da edição, **Then** o app
   pergunta se quer descartá-las.

---

### User Story 3 - Histórico de compras (Priority: P1)

Abaixo dos dados, o cliente vê o histórico de compras: os pedidos mais recentes primeiro, cada um
com data, itens, total em R$ e status. Tocar em um pedido abre o detalhe.

**Why this priority**: o usuário pediu o histórico junto com as informações.

**Independent Test**: com o usuário de demonstração que já tem pedidos, conferir a lista, abrir um
pedido entregue e um em andamento.

**Acceptance Scenarios**:

1. **Given** um cliente com pedidos, **When** ele rola até "Histórico de compras", **Then** vê os
   pedidos do mais recente ao mais antigo, com data, resumo dos itens (ex.: "Caffe Mocha M ×2 +
   1 item"), total (ex.: R$ 25,90) e status.
2. **Given** um pedido em andamento, **When** o cliente toca nele, **Then** vai para o
   acompanhamento da entrega (008).
3. **Given** um pedido concluído, recusado ou estornado, **When** o cliente toca nele, **Then** vê
   o detalhe: itens, tamanhos, valores, forma de pagamento (com os 4 últimos dígitos, se cartão),
   endereço e status final.
4. **Given** mais de 10 pedidos, **When** o cliente chega ao fim da lista, **Then** os próximos são
   carregados aos poucos, com o loading compacto (004).
5. **Given** um cliente sem pedidos, **When** ele abre o histórico, **Then** aparece o estado vazio
   "Você ainda não fez pedidos" com o botão "Ver cardápio".

---

### User Story 4 - Atalhos da conta (Priority: P2)

A tela de usuário reúne os atalhos da conta: Favoritos (006), Meus cartões (011), Sons do app
(012), tema claro/escuro e Sair.

**Why this priority**: as features 011 e 012 precisam deste lugar; o perfil funciona sem eles.

**Independent Test**: tocar em cada atalho disponível e chegar ao destino; tocar em "Sair" e
voltar ao login.

**Acceptance Scenarios**:

1. **Given** o perfil, **When** o cliente toca em um atalho, **Then** vai para a tela
   correspondente ou a opção muda na hora (tema, sons).
2. **Given** o perfil, **When** o cliente toca em "Sair" e confirma, **Then** a sessão é encerrada
   e ele volta ao login.
3. **Given** uma feature de atalho ainda não implementada (ex.: 011 ou 012), **When** o perfil é
   exibido, **Then** o atalho dela não aparece.

### Edge Cases

- Foto com proporção diferente de 1:1: é recortada no centro para caber no círculo da caneca.
- Falha ao carregar a foto: a caneca mostra as iniciais, sem erro em tela inteira.
- Falha só no histórico: os dados do perfil continuam visíveis e o histórico mostra o erro
  compacto com "Tentar novamente" (004, FR-011).
- E-mail novo já usado por outra conta: recusado com "Este e-mail já está em uso."
- Conta criada pelo Google ou Apple: não tem senha local; a opção "Alterar senha" é substituída
  por "Criar senha", que não pede senha atual.
- Toques repetidos em "Salvar" não geram envios duplicados.
- A tela funciona nos temas claro e escuro, e a caneca acompanha o tema.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema MUST ter uma tela de usuário acessível pela navegação principal, com a
  foto do cliente ao centro, dentro da ilustração de uma caneca de café vista de cima (a foto
  ocupa a superfície do café, com a borda e a alça da caneca em volta).
- **FR-002**: Sem foto, a caneca MUST mostrar as iniciais do nome (avatar padrão da 005).
- **FR-003**: Abaixo da caneca, a tela MUST mostrar nome, nome de usuário, e-mail (com o provedor,
  se Google ou Apple), endereço de entrega padrão e "Cliente desde".
- **FR-004**: O cliente MUST poder editar nome, nome de usuário, foto, endereço de entrega padrão,
  e-mail e senha.
- **FR-005**: As edições MUST seguir as regras da 005: nome de usuário e e-mail únicos, e-mail com
  confirmação simulada (sem código), senha com no mínimo 8 caracteres, uma letra e um número, e
  foto JPG ou PNG de até 5 MB, da galeria ou da câmera.
- **FR-006**: A troca de senha MUST exigir a senha atual (exceto ao criar a primeira senha de uma
  conta Google ou Apple) e MUST encerrar as outras sessões abertas da conta.
- **FR-007**: O endereço padrão MUST estar em Palmas-TO, dentro da área de entrega, e poder ser
  escolhido no mapa da 008 ou entre os endereços de demonstração.
- **FR-008**: A tela MUST mostrar o histórico de compras do cliente, do mais recente ao mais
  antigo, com data, resumo dos itens, total em R$ (padrão brasileiro) e status, carregando 10
  pedidos por vez.
- **FR-009**: Tocar em um pedido em andamento MUST abrir o acompanhamento (008); tocar em um
  pedido encerrado MUST abrir o detalhe dele, sem dados de cartão além dos 4 últimos dígitos.
- **FR-010**: A tela MUST reunir os atalhos da conta: Favoritos, Meus cartões, Sons do app, tema
  claro/escuro e Sair, mostrando só os das features já implementadas.
- **FR-011**: Todos os dados do perfil e do histórico MUST vir do servidor (constitution,
  princípio V); as rotas novas (editar perfil, trocar e-mail, trocar senha, listar pedidos com
  paginação, detalhe do pedido) MUST entrar no contrato da 001 antes de serem implementadas.
- **FR-012**: A ilustração da caneca MUST ficar em local separado e identificado (`profile_mug`),
  listada em `docs/ASSETS.md`, para poder ser trocada sem alterar a tela.
- **FR-013**: Erros seguem o catálogo da 004: erros de validação no próprio campo; falha no
  histórico só no histórico.

### Key Entities

- **Perfil**: nome, nome de usuário, e-mail, provedor de origem, foto opcional, endereço de
  entrega padrão e data de cadastro (estende o Usuário da 005).
- **Endereço de entrega padrão**: rótulo, endereço em Palmas-TO e coordenadas (pontos da 008).
- **Pedido no histórico**: identificador, data, resumo dos itens, total, status, forma de
  pagamento e 4 últimos dígitos do cartão, quando houver (Pedido da 007).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: O cliente encontra os próprios dados e o último pedido em menos de 10 segundos após
  abrir a tela de usuário.
- **SC-002**: Uma alteração de nome, nome de usuário ou endereço é concluída em menos de 1 minuto.
- **SC-003**: 100% das alterações salvas continuam valendo depois de sair e entrar de novo.
- **SC-004**: 100% dos pedidos da conta aparecem no histórico, na ordem certa e com o total igual
  ao cobrado.
- **SC-005**: Em teste com usuários, 90% reconhecem a própria foto dentro da caneca sem
  explicação.

## Assumptions

- Depende da 005 (conta, foto e regras de validação), da 007 (pedidos) e da 008 (mapa e pontos de
  entrega).
- A caneca é vista de cima, com a foto no lugar do café; a arte é original do projeto e só usa os
  tokens do Design System.
- Histórico com 10 pedidos por vez e resumo de itens no formato "Produto Tamanho ×Qtd + N itens"
  são padrões adotados, ajustáveis no plano.
- "Pedir de novo", excluir a conta e exportar os dados estão fora do escopo.
- A tela substitui a área de perfil citada nas specs 005, 011 e 012.
