---
name: linha-do-tempo
description: Linha do tempo do projeto Coffee Shop (Mobile II), com tudo o que foi feito, decidido e o que falta. Use quando o usuário pedir a linha do tempo, o histórico, o "onde paramos", ou quiser registrar um novo passo.
argument-hint: "Vazio para ver a linha do tempo; ou 'adicionar: <o que aconteceu>' para registrar um novo passo"
user-invocable: true
---

# Linha do tempo — Coffee Shop (Mobile II)

## Como usar esta skill

- **Sem argumento:** mostre ao usuário a linha do tempo abaixo, de forma resumida: as etapas,
  as decisões vigentes, o estado atual e o próximo passo. Ofereça detalhar qualquer etapa.
- **`adicionar: <texto>`:** acrescente uma nova entrada ao final de "Etapas", com a data de hoje
  (AAAA-MM-DD). Se houver decisões novas, atualize também "Decisões vigentes" e "Estado atual".
  Não apague entradas antigas; se uma decisão mudar, marque a antiga como ~~substituída~~ e diga
  por qual.
- Antes de afirmar algo do "Estado atual", confira no repositório (git status, arquivos), porque
  esta anotação pode estar desatualizada.
- Regras permanentes do usuário: o **README.md prevalece** sobre o que ele escrever. Sempre que
  houver divergência, pergunte. Dúvidas ou decisões importantes também se perguntam, nunca se
  decidem sozinho.

---

## Etapas

### 2026-11-27 — 1. Repositório trazido para a máquina
- A pasta `C:\Users\joaov\Downloads\projecto` estava vazia (git sem commits).
- O repositório `VictorXavierSL/Designer-Systen-model-viwer-Aulas-Mobile-2` foi ligado como
  `origin`, e o branch `main` foi baixado. O remoto também tem o branch
  `teste/telas-de-estado-e-testes`.
- Conteúdo: app Flutter MVVM (`lib/`), `packages/design_system` (tokens + 18 componentes +
  Sample App) e `packages/core` (modelos, `ApiClient`, servidor mock em memória, repositórios).

### 2026-11-27 — 2. Primeira tentativa de instalar o spec-kit (bloqueada)
- A máquina não tinha Python nem `uv`. O instalador do `uv` via `irm | iex` e o download do
  binário portátil foram bloqueados pelas permissões da sessão.
- O spec-kit 1.4.5 não publica mais zips de template (vêm embutidos no CLI).

### 2026-11-27 — 3. Esboço da constitution
- Criado `docs/CONSTITUTION_ESBOCO.md` a partir do README, `docs/ARQUITETURA.md` e
  `docs/DESIGN_SYSTEM.md`: 7 princípios (camadas, cenas MVVM, tokens, componentes, contrato de
  API, testabilidade, simplicidade).
- Pedido do usuário: o backend é um **servidor mock** e o front recebe todos os dados dele.
  Virou o princípio V (não negociável).

### 2026-11-27 — 4. Separação em dois repositórios
- Primeiro foram criadas pastas locais `coffee-shop-design-system` e `coffee-shop-app`. O app
  chegou a buscar o DS pelo git, mas o usuário esclareceu que o repositório do DS é **só uma
  cópia** e o app continua com `packages/design_system`. Essa mudança foi desfeita.
- Resultado final, enviado ao GitHub:
  - **`VictorXavierSL/Coffee-Shop-Implementado`**: implementação completa (app + core + DS +
    docs + esboço da constitution). O commit inicial do GitHub (README de uma linha) foi
    mesclado mantendo o nosso README.
  - **`VictorXavierSL/Designer-Systen-model-viwer-Aulas-Mobile-2`**: agora só o Design System
    (`lib/`, `example/`, `pubspec.yaml`, `docs/DESIGN_SYSTEM.md`, README avisando que é cópia).
    Commits `7017cb2` e `b77bf0b`, sem reescrever histórico (o app antigo segue no `a2597f5`).
- A pasta `projecto` foi limpa e passou a conter o **Coffee-Shop-Implementado**. As pastas
  auxiliares foram apagadas.

### 2026-11-27 — 5. Análise do código da API
- Linguagem: **Dart**. Contrato `ApiClient.send(ApiRequest) → ApiResponse`; servidor em memória
  `MockApiClient` + `MockDatabase` (latência de 450 ms, JSON serializado); `AuthorizedApiClient`
  (Decorator do token); 10 rotas em `docs/API.md`; 8 testes de contrato.
- Pontos de atenção: `GET /orders/{id}` altera o pedido; dados e sessão só em memória; token
  sem expiração; senha em texto puro; sem cliente HTTP real; contrato só em Markdown.

### 2026-11-27 — 6. Regra de trabalho registrada
- O README prevalece; divergências e dúvidas importantes são perguntadas; esperar o comando do
  usuário quando ele pedir. Gravado também na memória do Claude.

### 2026-11-27 — 7. Spec-kit instalado e configurado para o Claude
- `uv` 0.13.10 instalado via **winget**; `specify-cli` **1.4.5** (versão estável) instalado com
  `uv tool install ... @v1.4.5`.
- `specify init --here --integration claude --script ps` criou `.specify/` (templates, scripts
  PowerShell, memória) e as skills `/speckit-*` em `.claude/skills/`.
- `.gitignore` recebeu `.claude/settings.local.json` e `.env`.

### 2026-11-27 — 8. Protótipo (`prototipo.txt`) e respostas do usuário
O usuário escreveu o protótipo e respondeu 15 perguntas, mais 3 de arquitetura:
1. Backend: servidor mock **separado do app**, com **Postgres** e instruções para rodar.
2. Login: aceitar **e-mail e nome de usuário**, com um exemplo de cada já pronto.
3. Endereços: todos simulados em **Palmas-TO**.
4. Tamanhos: manter P/M/G, cada um com seu **ml**, trocando de um para outro.
5. Dependências: integrações simuladas **sem pacotes extras**, exceto os de animação; a
   integração real fica "a definir".
6. Google/Apple: só **botão que simula**, mas o back pronto para a implementação real.
7. Loja: **Praça dos Girassóis**.
8. Pagamento: esperar a resposta do banco e, se falhar, já pedir o **estorno**. Recomendação
   aceita: pendente → aprovado/recusado → estornado, com chave de idempotência.
9. Resultado do pagamento: **aleatório**, mas com produtos que sempre falham e outros que
   sempre aprovam (aprovar é a prioridade); documentar e explicar como remover.
10. E-mail: validar o formato e **sempre aprovar**, sem código; documentar e explicar como
    remover.
11. Segurança: proteções **mais comuns do mercado**, e uma esteira de testes marcada para
    depois.
12. Animações simples, **separadas e identificadas** para serem trocadas no futuro.
13. Popup da indicação do dia: **aleatório**.
14. Carrinho lateral: aparece **sempre que possível, menos no mapa interativo**, e leva à
    tela completa.
15. Dividir em features e deixar pronto para os outros comandos do spec-kit.
- Arquitetura: servidor em **Dart (shelf)**; o `MockApiClient` em memória fica **só para
  testes**; fluxo de pagamento com estorno aprovado.

### 2026-11-27 — 9. Constitution 1.0.0
- Criada em `.specify/memory/constitution.md` pela skill `speckit-constitution`, com 10
  princípios: I camadas · II cenas MVVM · III tokens/Figma · IV componentes · V servidor mock
  separado como única fonte de dados · VI contrato de API primeiro · VII integrações simuladas,
  documentadas e substituíveis · VIII segurança de mercado · IX testabilidade · X dependências
  mínimas.

### 2026-11-27 — 10. Especificações criadas e clarificadas
- Specs escritas pela skill `speckit-specify`, cada uma com `checklists/requirements.md`.
- Respostas às clarificações: foto de perfil da **galeria/câmera** (exceção ao princípio X, a
  justificar no plano); **qualquer cliente avalia qualquer café** (uma avaliação por café,
  editável); o mapa serve para **acompanhar a entrega e escolher o endereço**.

### 2026-11-27 — 11. Spec do contrato da API e moeda
- Nova spec do contrato, que precisa ficar **evidente no README** (seção "Contrato da API" com
  a tabela de rotas) e ter versão legível por máquina (OpenAPI 3, a confirmar no plano).
- Moeda: **real (R$)**, obrigatório.

### 2026-11-27 — 12. Renumeração e constitution 1.1.0
- As specs foram renumeradas na ordem de implementação (abaixo) e `.specify/feature.json` foi
  apontado para `specs/001-contrato-api`.
- Constitution **1.1.0**: real (R$) obrigatório em app, API, seed e documentação.

### 2026-11-27 — 13. Esta skill criada
- `.claude/skills/linha-do-tempo/SKILL.md`.

### 2026-11-27 — 14. Configuração portátil e commit
- Criado o `CLAUDE.md` com as regras de trabalho, que antes estavam só na memória local do
  Claude e não iam para outra máquina.
- Commit `32bbfdb`, enviado ao Coffee-Shop-Implementado: spec-kit, constitution, specs,
  `prototipo.txt`, esta skill, `CLAUDE.md` e `.gitignore`.
- Ficam fora do git, de propósito: `.claude/settings.local.json` (permissões) e
  `.specify/feature.json` (feature ativa, recriada em cada máquina).

### 2026-11-27 — 15. Branch `dev` e regra de pull request
- Criada a branch **`dev`** a partir da `main` (`0c31b7e`) e enviada ao GitHub.
- Regra nova: todo trabalho acontece na `dev`; **nunca** commitar ou fazer merge direto na
  `main`; quando o usuário pedir, abrir um pull request `dev` → `main`, e o merge fica com ele.
  Registrada no `CLAUDE.md`.

---

## Decisões vigentes

| Tema | Decisão |
|---|---|
| Fonte de verdade | README.md; divergência ou dúvida importante → perguntar |
| Branches | Trabalho na `dev`; para a `main` só por PR, e o merge é do usuário |
| Repositórios | Coffee-Shop-Implementado = app completo; Designer-Systen-… = cópia só do DS |
| Backend | Servidor mock separado, Dart (shelf) + Postgres (Docker Compose), com seed |
| Mock em memória | `MockApiClient` só para testes |
| Contrato | Primeiro o contrato; evidente no README; detalhe em `docs/API.md`; OpenAPI a confirmar |
| Login | E-mail **ou** nome de usuário; bloqueio após 5 erros por 15 min; sessão de 24 h; hash |
| Google/Apple | Simulado com botão; ponto de extensão pronto no servidor |
| Confirmação de e-mail | Valida o formato e aprova sempre (documentado em `docs/SIMULACOES.md`) |
| Foto de perfil | Galeria/câmera, opcional; exceção ao princípio X a justificar no plano |
| Pagamento | Pix, crédito, débito, dinheiro; pendente → aprovado/recusado → estornado; idempotência |
| Cenários de pagamento | Produtos "sempre aprova" e "sempre recusa"; demais com 80% de aprovação |
| Moeda | Real (R$), obrigatório |
| Dados de demonstração | Palmas-TO; loja na Praça dos Girassóis |
| Tamanhos | P/M/G na tela (códigos S/M/L na API), cada um com ml e preço |
| Grão | Nome, origem, saco de grão; amargor, doçura, acidez e corpo de 0 a 5 em grãos claro → escuro |
| Avaliações | Qualquer cliente avalia qualquer café; uma por café, editável |
| Popup do dia | Aleatório (50%); baseado nos pedidos ou no mais consumido |
| Carrinho lateral | Em todas as telas de compra, menos no mapa |
| Mapa | Desenhado no app, sem pacote; acompanha a entrega e escolhe o endereço |
| Dependências | Só de animação (exceto a foto de perfil) |
| Animações | Separadas e identificadas (`docs/ASSETS.md`) |

## Ordem das specs (ordem de implementação)

| # | Pasta | Feature |
|---|---|---|
| 001 | `specs/001-contrato-api` | Contrato da API evidente e único |
| 002 | `specs/002-servidor-mock-postgres` | Servidor mock separado com banco + aviso de fora do ar |
| 003 | `specs/003-telas-estado-animacoes` | Telas de estado e animações substituíveis |
| 004 | `specs/004-autenticacao-contas` | Login, cadastro, Google/Apple, foto, segurança |
| 005 | `specs/005-catalogo-detalhes-produto` | Home, grão e índices, ml, avaliações, favoritos, indicação do dia |
| 006 | `specs/006-carrinho-pagamento` | Carrinho lateral e completo, pagamento simulado com estorno |
| 007 | `specs/007-mapa-entrega` | Mapa simulado de Palmas |
| 008 | `specs/008-esteira-testes-fluxos` | Esteira de testes dos fluxos (planejada para depois) |

## Estado atual (em 2026-11-27)

- Feature ativa: `specs/001-contrato-api` (`.specify/feature.json`).
- Nenhum código de feature foi implementado ainda.
- Tudo commitado e enviado ao GitHub. Ficam fora do git só `.claude/settings.local.json` e
  `.specify/feature.json`.
- O README ainda precisa receber as decisões novas (backend separado, login por e-mail ou
  usuário, Palmas-TO, R$, seção "Contrato da API"), o que deve acontecer na primeira feature
  implementada.

## Próximos passos

1. `/speckit-plan` na 001 → `/speckit-tasks` → (`/speckit-analyze`) → `/speckit-implement`.
2. Para cada feature seguinte, trocar `.specify/feature.json` e repetir o ciclo, na ordem
   001 → 008.
