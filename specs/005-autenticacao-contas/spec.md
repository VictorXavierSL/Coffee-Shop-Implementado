# Feature Specification: Autenticação e Criação de Conta

**Feature Branch**: `005-autenticacao-contas` (sem branch git; diretório `specs/005-autenticacao-contas`)

**Created**: 2026-11-27

**Status**: Draft

**Input**: User description: "Telas de login e criação de conta, usando os métodos de login de
nome e senha (verificar erros e fragilidades comuns) e confirmação de e-mail (sem validar de
verdade), e os logins automatizados do Google e da Apple. É possível colocar uma foto de perfil,
mas é opcional. Aceitar e-mail e nome de usuário, com um exemplo de cada já feito. Google/Apple
são só um botão que simula, mas o back fica pronto para uma implementação real. A confirmação de
e-mail verifica se o e-mail é válido e sempre aprova, sem pedir código, e isso fica documentado
junto com como remover. Aplicar as proteções de login mais comuns do mercado."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Entrar com e-mail ou nome de usuário (Priority: P1)

Um cliente com conta digita seu e-mail **ou** seu nome de usuário e a senha e entra no app.

**Why this priority**: sem login não há acesso às demais funcionalidades.

**Independent Test**: com os dois usuários de demonstração documentados no README, entrar uma
vez com o e-mail e outra com o nome de usuário; os dois chegam à Home.

**Acceptance Scenarios**:

1. **Given** o usuário de demonstração por e-mail, **When** ele informa e-mail e senha corretos,
   **Then** entra e vê a Home.
2. **Given** o usuário de demonstração por nome de usuário, **When** ele informa o nome de
   usuário e a senha corretos, **Then** entra e vê a Home.
3. **Given** credenciais incorretas, **When** ele tenta entrar, **Then** vê a mensagem genérica
   "Usuário ou senha incorretos", sem revelar qual dos dois está errado.
4. **Given** campos vazios ou mal formatados, **When** ele tenta entrar, **Then** o app indica o
   campo com problema antes de enviar.
5. **Given** um login bem-sucedido, **When** o app é fechado e reaberto dentro da validade da
   sessão, **Then** ele entra direto, sem novo login.

---

### User Story 2 - Criar conta com confirmação de e-mail simulada (Priority: P1)

Um novo cliente informa nome, nome de usuário, e-mail e senha (e, se quiser, uma foto). O app
verifica se o e-mail é válido, mostra a etapa de confirmação de e-mail, que é aprovada
automaticamente, e a conta fica pronta para uso.

**Why this priority**: permite que qualquer avaliador experimente o app com a própria conta.

**Independent Test**: criar uma conta nova, passar pela confirmação automática e entrar com ela
por e-mail e por nome de usuário.

**Acceptance Scenarios**:

1. **Given** dados válidos e únicos, **When** o cliente cria a conta, **Then** vê a etapa
   "Confirmando e-mail" seguida de "E-mail confirmado", sem precisar digitar código, e fica
   logado.
2. **Given** um e-mail com formato inválido, **When** ele tenta criar a conta, **Then** vê
   "E-mail inválido" e a conta não é criada.
3. **Given** um e-mail ou nome de usuário que já existe, **When** ele tenta criar a conta,
   **Then** vê uma mensagem indicando qual campo já está em uso.
4. **Given** uma senha fraca, **When** ele tenta criar a conta, **Then** vê quais requisitos
   faltam.
5. **Given** o cadastro sem foto, **When** a conta é criada, **Then** o perfil mostra um avatar
   padrão com as iniciais.

---

### User Story 3 - Entrar com Google ou Apple (simulado) (Priority: P2)

O cliente toca em "Continuar com Google" ou "Continuar com Apple". O app simula a autorização
do provedor e o cliente entra com uma conta de demonstração vinculada àquele provedor.

**Why this priority**: o protótipo exige os botões; a integração real fica para depois.

**Independent Test**: tocar em cada botão e chegar à Home com a conta de demonstração do
provedor; conferir em `docs/SIMULACOES.md` como trocar pela integração real.

**Acceptance Scenarios**:

1. **Given** a tela de login, **When** o cliente toca em "Continuar com Google", **Then** vê uma
   etapa de autorização simulada e entra com a conta de demonstração Google.
2. **Given** a tela de login, **When** o cliente toca em "Continuar com Apple", **Then** o mesmo
   acontece com a conta de demonstração Apple.
3. **Given** a autorização simulada, **When** o cliente cancela, **Then** volta ao login sem
   erro.

---

### User Story 4 - Proteção contra tentativas repetidas (Priority: P2)

Depois de várias senhas erradas seguidas, a conta fica temporariamente bloqueada para novas
tentativas.

**Why this priority**: é a fragilidade mais comum em logins (força bruta).

**Independent Test**: errar a senha 5 vezes seguidas e verificar o bloqueio temporário com a
mensagem de quanto tempo falta.

**Acceptance Scenarios**:

1. **Given** 5 tentativas erradas seguidas para a mesma conta, **When** o cliente tenta de
   novo, **Then** vê "Muitas tentativas. Tente novamente em X minutos", mesmo com a senha certa.
2. **Given** o bloqueio expirado, **When** o cliente informa a senha certa, **Then** entra
   normalmente e o contador zera.

### Edge Cases

- Espaços antes ou depois do e-mail ou do nome de usuário são ignorados; e-mail não diferencia
  maiúsculas de minúsculas.
- Nome de usuário com caracteres não permitidos é rejeitado com mensagem clara.
- Sessão expirada durante o uso leva ao login com a mensagem "Sessão expirada".
- Perda de conexão durante o login ou o cadastro mostra o aviso de fora do ar (feature 002), e
  não "senha incorreta".
- Toques repetidos no botão de entrar ou criar conta não geram envios duplicados.
- Foto de perfil grande demais ou em formato não suportado é recusada com mensagem clara.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema MUST permitir login com **e-mail ou nome de usuário** + senha.
- **FR-002**: O sistema MUST ter ao menos um usuário de demonstração pronto para login por
  e-mail e outro por nome de usuário, ambos listados no README.
- **FR-003**: O sistema MUST permitir criar conta com nome, nome de usuário, e-mail, senha e
  confirmação de senha; a foto de perfil é opcional.
- **FR-004**: O sistema MUST validar o formato do e-mail e a unicidade do e-mail e do nome de
  usuário.
- **FR-005**: A confirmação de e-mail MUST ser simulada: o formato é verificado e a confirmação
  é sempre aprovada, sem envio de código. Isso MUST estar documentado em `docs/SIMULACOES.md`,
  com instruções para ligar uma verificação real.
- **FR-006**: Os botões "Continuar com Google" e "Continuar com Apple" MUST simular a
  autorização e entrar com contas de demonstração específicas de cada provedor.
- **FR-007**: O servidor MUST tratar os provedores de login externo por um ponto de extensão
  próprio, de modo que uma integração real possa substituir a simulação sem mudar as telas nem
  o contrato da API.
- **FR-008**: Senhas MUST ser guardadas apenas de forma protegida (hash com salt) e nunca
  devolvidas pela API.
- **FR-009**: A senha MUST ter no mínimo 8 caracteres, com ao menos uma letra e um número.
- **FR-010**: Credenciais inválidas MUST gerar a mensagem genérica "Usuário ou senha
  incorretos".
- **FR-011**: Após 5 tentativas erradas seguidas, a conta MUST ficar bloqueada para login por
  15 minutos.
- **FR-012**: A sessão MUST expirar (validade padrão de 24 horas) e o logout MUST invalidá-la no
  servidor.
- **FR-013**: Entradas MUST ser validadas no app (retorno imediato) e no servidor (fonte de
  verdade).
- **FR-014**: A foto de perfil, opcional, MUST poder ser escolhida da **galeria ou tirada com a
  câmera** do aparelho, e pode ser trocada ou removida depois. A foto é enviada ao servidor e
  ligada à conta, em formato JPG ou PNG de até 5 MB, redimensionada antes do envio. Decisão do
  usuário em 2026-11-27: é uma exceção ao princípio X da constitution (só dependências de
  animação), e o `/speckit-plan` MUST justificar por escrito o pacote de galeria/câmera
  escolhido.
- **FR-015**: Mensagens de erro MUST NOT expor detalhes técnicos (stack, SQL, nomes internos).

### Key Entities

- **Usuário**: nome, nome de usuário (único), e-mail (único), senha protegida, foto opcional,
  provedor de origem (senha, Google, Apple), e-mail confirmado (sim/não), tentativas falhas e
  bloqueio até.
- **Sessão**: token, usuário, data de criação e validade.
- **Identidade externa**: vínculo entre usuário e provedor (Google/Apple) com o identificador
  do provedor.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Um novo cliente cria a conta e chega à Home em menos de 2 minutos.
- **SC-002**: 100% das tentativas com credenciais inválidas mostram a mesma mensagem genérica.
- **SC-003**: A 6ª tentativa errada seguida é sempre bloqueada, e o bloqueio termina em 15
  minutos.
- **SC-004**: Nenhuma senha aparece em texto legível no banco, nas respostas da API ou nos
  registros.
- **SC-005**: Os quatro caminhos de login (e-mail, nome de usuário, Google, Apple) funcionam com
  os dados de demonstração na primeira tentativa.

## Assumptions

- Depende da feature 002 (servidor mock com banco).
- Os números de bloqueio (5 tentativas, 15 min) e de sessão (24 h) são padrões de mercado
  adotados e podem ser ajustados no plano.
- A tela de login atual (`lib/scenes/login`) é estendida; a tela de criação de conta é uma cena
  nova.
- Recuperação de senha está fora do escopo.
- A animação de transição do login (café fumegante) é da feature 003.
