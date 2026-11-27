# Esboço para a Constitution — Coffee Shop (Flutter · MVVM)

> Texto de entrada para `/speckit-constitution`. Resume o que o projeto é e os
> princípios que toda feature nova deve respeitar.

## Contexto do projeto

- **O que é:** projeto acadêmico da disciplina **Mobile II**. Reconstrói em Flutter o
  Design System do Figma *Coffee Shop Mobile App Design (Community)* e usa esse DS para
  construir um app de cafeteria completo.
- **Objetivo:** demonstrar os padrões de projeto do semestre (MVVM, Factory, Coordinator,
  Delegate, Strategy, Decorator, Repository, Observer, Singleton, Composite).
- **Stack:** Flutter ≥ 3.27, Dart ≥ 3.6, `flutter_lints`, Material Icons, fonte Sora.
- **Estrutura (monorepo com 3 partes independentes):**
  - `packages/design_system` — tokens, tema claro/escuro, 18 componentes e Sample App (`example/`).
  - `packages/core` — modelos, contrato `ApiClient`, servidor mockado, sessão, carrinho, repositórios.
  - `lib/` — o app, organizado em cenas MVVM (Launch, Onboarding, Login, Home, Detalhes,
    Pedido, Acompanhamento).
- **Backend:** é um **servidor mock** (`MockApiClient` + `MockDatabase` em `packages/core`).
  Ele responde a API REST em JSON documentada em `docs/API.md`, e o front recebe dele
  todos os seus dados.

## Princípios propostos

### I. Separação em três camadas (NÃO NEGOCIÁVEL)
- O **Design System** não conhece regra de negócio nem modelos de domínio (`Product`,
  `Order`); recebe texto já formatado.
- O **Core** não conhece telas; só dados, contrato da API e implementações.
- O **App** é o único que junta DS e Core.
- Dependências só fluem `app → design_system` e `app → core`. Nunca o contrário, e os
  pacotes não dependem um do outro.

### II. Toda tela é uma cena MVVM com cinco papéis
Cada cena fica em `lib/scenes/<cena>/` com `factory`, `view`, `view_model`, `coordinator`
e `server`.
- A **View** só desenha e repassa eventos, sem regra de negócio.
- A **ViewModel** (`ChangeNotifier`) guarda estado e ações e não conhece `BuildContext`
  nem `Navigator`.
- O **Coordinator** cuida da navegação e das mensagens e não guarda estado.
- O **Server** é uma interface com implementação padrão.
- A **Factory** (`make()`) monta server → coordinator → viewModel → view.

### III. Design System guiado por tokens e fiel ao Figma
- Os componentes nunca usam hexadecimal: leem papéis por `context.colors.<papel>` e a
  tipografia por `AppTypography`.
- Espaçamentos (4/8/12/16/24/32/48) e raios (6/8/12/16/24) vêm só dos tokens.
- O Figma é a fonte da verdade do tema claro. O tema escuro é extensão do projeto e todo
  componente deve funcionar nos dois.

### IV. Componentes = ViewModel + Factory + Component
- Cada componente tem `<nome>_view_model.dart` (`@immutable`, com estado e callbacks
  delegados), `<nome>_factory.dart` (as variantes válidas do Figma) e
  `<nome>_component.dart` (só desenha).
- As cenas criam componentes **sempre pela Factory**, nunca montando a ViewModel na mão.
- Componente novo é exportado em `design_system.dart` e ganha uma seção no Sample App.

### V. Backend é um servidor mock e o front só consome dados dele (NÃO NEGOCIÁVEL)
- O backend do projeto é um **servidor mock** (`MockApiClient` + `MockDatabase` em
  `packages/core`). Ele simula um servidor real, com rotas, códigos HTTP, corpos JSON e
  erros.
- O front recebe **todos** os dados desse servidor: usuário, categorias, produtos,
  promoções, cálculo do pedido e status de acompanhamento. Nenhuma cena ou componente
  guarda dados de negócio fixos no código (listas de produtos, preços, totais, status).
- Toda regra de negócio de dados fica no servidor mock (validação de login, preço por
  tamanho, desconto e resumo do pedido, avanço de status). O front só exibe e envia
  requisições.
- O fluxo é sempre `Cena → Server da cena → Repository → ApiClient → servidor mock`.
  Nenhuma camada pode pular esse caminho para ler o `MockDatabase` direto.
- Toda comunicação passa por `ApiClient` (Strategy). Trocar mock por HTTP real não pode
  exigir mudança nas cenas, só em `app_dependencies.dart`.
- Rota, código HTTP ou corpo novo é documentado em `docs/API.md` **antes** de ser
  implementado no mock.
- O token é injetado só pelo `AuthorizedApiClient` (Decorator).

### VI. Testabilidade por interfaces
- As ViewModels dependem de interfaces (Server, Coordinator, SessionStore) para poderem
  ser testadas com fakes.
- Cena nova com lógica ganha testes de ViewModel em `test/scenes/`.
- Mudança de contrato atualiza os testes em `packages/core/test`.
- `flutter analyze` sem avisos e `flutter test` verde são obrigatórios.

### VII. Simplicidade e propósito didático
- Sem dependências externas sem justificativa: estado com `ChangeNotifier`, ícones do
  Material.
- O código deve deixar claro qual padrão de projeto está sendo aplicado. Padrão novo é
  registrado em `docs/ARQUITETURA.md`.

## Restrições e fluxo de trabalho
- Documentação em português (README, `docs/`). Nomes de código em inglês.
- Estado global só nos stores observáveis (`CartStore`, `FavoritesStore`,
  `ThemeController`) e no composition root `AppDependencies.instance`.
- Sessão: a Launch valida a chave `coffee.session` com `GET /me`. O logout apaga a
  sessão, limpa o carrinho e faz `resetTo` para o Login.
- Antes de considerar uma feature pronta: analyze e testes passando, docs atualizadas
  (API, DS ou Arquitetura) e, se for componente, Sample App atualizado.

## Governança
- A constitution prevalece sobre preferências individuais. Uma exceção precisa de
  justificativa escrita no plano da feature.
- Versionamento semântico da constitution: MAJOR quando remove ou muda um princípio,
  MINOR quando adiciona um, PATCH para ajustes de texto.
