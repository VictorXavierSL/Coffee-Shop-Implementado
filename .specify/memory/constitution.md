<!--
Sync Impact Report
- Version change: 1.0.0 → 1.1.0 (MINOR: nova restrição obrigatória de moeda)
- Histórico: (template sem valores) → 1.0.0 em 2026-11-27 (adoção inicial)
- Princípios adotados (todos novos):
  I. Separação em Camadas · II. Cenas MVVM com Cinco Papéis ·
  III. Design System Guiado por Tokens e Fiel ao Figma ·
  IV. Componentes = ViewModel + Factory + Component ·
  V. Servidor Mock Separado como Única Fonte de Dados ·
  VI. Contrato de API Primeiro · VII. Integrações Simuladas, Documentadas e Substituíveis ·
  VIII. Segurança por Padrão de Mercado · IX. Testabilidade por Interfaces ·
  X. Simplicidade, Dependências Mínimas e Propósito Didático
- Seções adicionadas: Restrições Técnicas e de Dados; Fluxo de Trabalho e Portões de Qualidade
- Seções removidas: nenhuma
- Templates (.specify/templates/*): plan-template.md possui "Constitution Check" genérico,
  que lê esta constitution em tempo de execução — nenhuma alteração necessária.
- Divergências com o README.md que DEVEM ser refletidas nele na primeira feature implementada:
  backend separado (Dart/shelf + Postgres) em vez de mock em memória no app; login por e-mail
  OU nome de usuário; dados de demonstração em Palmas-TO em vez do endereço do Figma;
  valores em real (R$) em vez de dólar.
- TODOs adiados: nenhum.
-->

# Coffee Shop Constitution

## Core Principles

### I. Separação em Camadas (NÃO NEGOCIÁVEL)

O sistema é composto por partes independentes, cada uma com uma única responsabilidade:

- **Design System** (`packages/design_system`): tokens, tema e componentes. MUST NOT conhecer
  regra de negócio nem modelos de domínio (`Product`, `Order`...); recebe texto já formatado.
- **Core** (`packages/core`): modelos, contrato `ApiClient`, repositórios, sessão e stores.
  MUST NOT conhecer telas.
- **App** (`lib/`): única parte que junta Design System e Core em cenas.
- **Servidor mock** (pasta própria, fora do app): MUST NOT depender de Flutter nem do Design
  System.

As dependências fluem apenas `app → design_system` e `app → core`; os pacotes não dependem
entre si nem do app.

**Racional:** isolar responsabilidades torna cada parte testável e substituível e é o objeto
de estudo da disciplina.

### II. Cenas MVVM com Cinco Papéis

Toda tela MUST ser uma cena em `lib/scenes/<cena>/` com cinco arquivos:

- `<cena>_factory.dart`: `make()` monta server → coordinator → viewModel → view.
- `<cena>_view.dart`: só desenha e repassa eventos. MUST NOT conter regra de negócio.
- `<cena>_view_model.dart`: estado e ações (`ChangeNotifier`). MUST NOT usar `BuildContext`
  nem `Navigator`.
- `<cena>_coordinator.dart`: navegação e mensagens. MUST NOT guardar estado.
- `<cena>_server.dart`: interface do servidor da cena e sua implementação padrão.

Telas de estado (carregando, erro, vazio, sem conexão, sucesso/falha de pagamento) MUST ser
componentes reutilizáveis do Design System, acionados pela ViewModel, e não lógica espalhada
nas Views.

### III. Design System Guiado por Tokens e Fiel ao Figma

- Componentes MUST NOT usar cor hexadecimal: leem papéis por `context.colors.<papel>` e
  tipografia por `AppTypography`.
- Espaçamentos (4/8/12/16/24/32/48) e raios (6/8/12/16/24) MUST vir dos tokens.
- O Figma *Coffee Shop Mobile App Design* é a fonte da verdade do tema claro; o tema escuro é
  extensão do projeto, e todo componente MUST funcionar nos dois temas.

### IV. Componentes = ViewModel + Factory + Component

- Cada componente em `lib/src/components/<nome>/` MUST ter `<nome>_view_model.dart`
  (`@immutable`, estado + callbacks delegados), `<nome>_factory.dart` (variantes válidas) e
  `<nome>_component.dart` (só desenha).
- Cenas MUST criar componentes pela Factory, nunca montando a ViewModel "na mão".
- Todo componente novo MUST ser exportado em `design_system.dart` e ganhar uma seção no Sample
  App (`example/`).

### V. Servidor Mock Separado como Única Fonte de Dados (NÃO NEGOCIÁVEL)

- O backend é um **servidor mock separado do app**, escrito em **Dart (shelf)**, com banco
  **Postgres** simples e dados de demonstração criados por seed.
- O app MUST receber **todos** os dados desse servidor via HTTP (`HttpApiClient implements
  ApiClient`): usuário, catálogo, avaliações, indicação do dia, carrinho/pedido, pagamento e
  status de entrega. Nenhuma cena ou componente MAY conter dados de negócio fixos (produtos,
  preços, totais, status).
- Regras de negócio de dados (validação de login, preços por tamanho, descontos, totais,
  pagamento, estorno, avanço de status, recomendação) MUST ficar no servidor.
- O fluxo de dados é sempre `Cena → Server da cena → Repository → ApiClient → servidor`.
- O `MockApiClient` em memória de `packages/core` MUST ser mantido apenas para testes
  automatizados e MUST seguir o mesmo contrato do servidor.
- O servidor MUST ter instruções de execução documentadas (subir o Postgres, aplicar o seed,
  iniciar o servidor e apontar o app para ele).

**Racional:** o app precisa demonstrar um consumo real de API sem depender de um backend de
produção.

### VI. Contrato de API Primeiro

- Toda rota, código HTTP, corpo ou erro novo MUST ser documentado em `docs/API.md` **antes**
  de ser implementado no servidor, no `MockApiClient` ou no app.
- Erros seguem o formato único `{ "error": { "code": "...", "message": "..." } }`.
- Requisições `GET` MUST NOT alterar estado; mudanças de estado usam `POST`/`PUT`/`DELETE`.
- O token é injetado apenas pelo `AuthorizedApiClient` (Decorator).
- Trocar a implementação do `ApiClient` MUST exigir mudança apenas em
  `lib/app/app_dependencies.dart` (ou configuração equivalente).

### VII. Integrações Simuladas, Documentadas e Substituíveis

Login Google/Apple, verificação de e-mail, gateway de pagamento e mapa de entrega são
**simulados** nesta fase. Para cada simulação:

- O servidor MUST expor a integração por trás de uma interface (ex.: `OAuthProvider`,
  `EmailVerifier`, `PaymentGateway`), com uma implementação `Simulated*`, de modo que uma
  implementação real possa ser ligada sem alterar o app nem o contrato da API.
- O comportamento simulado MUST estar documentado em `docs/SIMULACOES.md`: o que é simulado,
  onde está, quais dados de demonstração disparam cada resultado e **como remover ou trocar**.
- Pagamento: o pedido só é confirmado após a resposta do gateway (estados
  `pending → approved | declined`, e `approved → refunded` quando algo falha após a
  aprovação, com estorno automático). Toda tentativa MUST ter chave de idempotência.

### VIII. Segurança por Padrão de Mercado

- Senhas MUST ser armazenadas com hash forte e salt (ex.: bcrypt/argon2), nunca em texto puro.
- Login MUST usar mensagem genérica para credenciais inválidas, limitar tentativas
  (bloqueio temporário) e validar entrada no servidor e no app.
- Tokens MUST expirar; sessão expirada leva ao login.
- Segredos e credenciais MUST NOT ser versionados; configurações vêm de variáveis de ambiente
  com exemplo em `.env.example`.

### IX. Testabilidade por Interfaces

- ViewModels MUST depender de interfaces (Server, Coordinator, SessionStore) e ser testadas
  com fakes em `test/scenes/`.
- Toda mudança de contrato MUST atualizar os testes de contrato (`packages/core/test` e os
  testes do servidor).
- Uma esteira de testes dos fluxos do protótipo (ponta a ponta) está planejada como feature
  própria; até lá, cada feature MUST entregar testes de ViewModel e de contrato.

### X. Simplicidade, Dependências Mínimas e Propósito Didático

- Novas dependências do app MUST se limitar a bibliotecas de **animação**; mapa, OAuth e
  demais integrações são simulados sem pacotes extras. No servidor, apenas o necessário para
  HTTP (shelf), Postgres e hash de senha, com justificativa no plano.
- Animações e imagens MUST ficar em local separado e identificado (ex.: `assets/animations/`,
  com catálogo em `docs/ASSETS.md`) para poderem ser substituídas sem alterar código de cena.
- Estado com `ChangeNotifier`; ícones do Material.
- O código MUST deixar explícito o padrão de projeto aplicado; padrões novos são registrados
  em `docs/ARQUITETURA.md`.

## Restrições Técnicas e de Dados

- **Stack:** Flutter ≥ 3.27, Dart ≥ 3.6, `flutter_lints`; servidor Dart (shelf) + Postgres
  executado via Docker Compose.
- **Idioma:** documentação e textos de interface em português; identificadores de código em
  inglês.
- **Dados de demonstração:** endereços, loja e entregadores simulados em **Palmas-TO**, com a
  loja na **Praça dos Girassóis**. Toda conta, produto ou cenário de demonstração MUST estar
  listado na documentação.
- **Login:** aceita e-mail **ou** nome de usuário + senha; ao menos um usuário de demonstração
  pronto para cada forma, documentado no README.
- **Moeda (OBRIGATÓRIO):** todos os valores monetários MUST ser em **real (R$)**, com 2 casas
  decimais, exibidos no padrão brasileiro (ex.: R$ 12,50), no app, na API, no seed e na
  documentação. Nenhum outro símbolo ou moeda MAY aparecer (substitui o dólar herdado do Figma).
- **Tamanhos:** produtos mantêm os tamanhos padrão (P/M/G), cada um com seu volume em ml e seu
  preço; o usuário alterna entre eles.
- **Estado global:** apenas nos stores observáveis (`CartStore`, `FavoritesStore`,
  `ThemeController`...) e no composition root `AppDependencies.instance`.

## Fluxo de Trabalho e Portões de Qualidade

- Features são desenvolvidas pelo fluxo Spec Kit: `/speckit-specify` → (`/speckit-clarify`) →
  `/speckit-plan` → `/speckit-tasks` → (`/speckit-analyze`) → `/speckit-implement`.
- Uma feature só está pronta quando:
  1. `flutter analyze` não tem avisos e `flutter test` está verde (app e pacotes);
  2. os testes do servidor estão verdes;
  3. `docs/API.md`, `docs/SIMULACOES.md`, `docs/ASSETS.md`, `docs/ARQUITETURA.md`,
     `docs/DESIGN_SYSTEM.md` e o README estão atualizados conforme o que mudou;
  4. componentes novos aparecem no Sample App.
- O plano de cada feature MUST passar pelo "Constitution Check" e justificar por escrito
  qualquer exceção.

## Governance

- O **README.md é a fonte de verdade** do projeto. Quando um pedido ou documento divergir dele,
  o agente MUST apontar a divergência e perguntar antes de agir; dúvidas ou decisões
  importantes também MUST ser perguntadas, nunca decididas sozinho.
- Toda decisão que mude o projeto MUST ser refletida no README na mesma entrega.
- Esta constitution prevalece sobre preferências individuais e sobre os demais documentos de
  processo; exceções exigem justificativa no plano da feature.
- **Emendas:** propostas por escrito, aprovadas pelo dono do repositório e registradas com
  data e versão.
- **Versionamento semântico:** MAJOR quando remove ou redefine um princípio; MINOR quando
  adiciona um princípio/seção ou expande materialmente uma regra; PATCH para ajustes de texto.
- **Revisão de conformidade:** todo plano (`/speckit-plan`) e toda análise (`/speckit-analyze`)
  MUST verificar esta constitution.

**Version**: 1.1.0 | **Ratified**: 2026-11-27 | **Last Amended**: 2026-11-27
