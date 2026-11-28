# CLAUDE.md — Coffee Shop (Mobile II)

Instruções para o Claude Code neste repositório. Valem em qualquer máquina.

## Regras de trabalho (do dono do repositório)

- O **README.md é a fonte de verdade**. O que já está nele vale mais do que um pedido novo.
- Quando um pedido **divergir** do README (ou da constitution), aponte a divergência e
  **pergunte antes de agir**. Não escolha um lado sozinho.
- **Dúvidas ou decisões importantes:** pergunte; não decida sozinho.
- Quando o usuário pedir para aguardar um comando, não comece o trabalho antes.
- Toda decisão nova que mude o projeto precisa ser refletida no README.

## Branches e pull requests (OBRIGATÓRIO)

- Todo trabalho é feito na branch **`dev`**.
- **Nunca** commitar, dar push ou fazer merge direto na `main`.
- Quando o usuário pedir, abrir um **pull request `dev` → `main`** e parar aí. O merge é sempre
  feito pelo usuário.
- Antes de começar, confira se a branch atual é `dev` (`git status -sb`).

## Contexto

- Este repositório (**Coffee-Shop-Implementado**) é a implementação completa: app em `lib/`,
  dados em `packages/core` e Design System em `packages/design_system`.
- O repositório `Designer-Systen-model-viwer-Aulas-Mobile-2` é **só uma cópia** do Design
  System. O app **não** busca o DS de lá, e a cópia não se atualiza sozinha.
- Histórico e decisões: rode **`/linha-do-tempo`**. Para registrar um passo novo, rode
  `/linha-do-tempo adicionar: <o que aconteceu>`.
- Prévia visual do app planejado (não implementada): **`/visual-nao-implementado-01`**.

## Spec-kit

- Constitution: `.specify/memory/constitution.md`. Ela prevalece sobre preferências e deve ser
  checada em todo plano.
- Specs em `specs/`, numeradas **na ordem de implementação**:
  001 contrato da API → 002 servidor mock → 003 telas de estado (visual) →
  004 inter telas (onde e quando aparecem) → 005 autenticação → 006 catálogo →
  007 carrinho e pagamento → 008 mapa → 009 esteira de testes →
  010 tela de usuário (perfil) → 011 cadastro de cartões (demonstração) →
  012 sons das telas e dos botões → 013 transições de tela (bônus, opcional).
- Feature ativa: `.specify/feature.json`. Esse arquivo fica **fora do git** (padrão do
  spec-kit, porque vale só para a máquina). Numa máquina nova, crie-o com
  `{ "feature_directory": "specs/<pasta-da-feature>" }`, usando a próxima feature não
  implementada.
- Ciclo: `/speckit-plan` → `/speckit-tasks` → (`/speckit-analyze`) → `/speckit-implement`.
- Os scripts são PowerShell (`.specify/scripts/powershell`). Em Mac ou Linux, instale o
  PowerShell ou rode `specify init --here --integration claude --script sh`.

## Comandos

```bash
flutter pub get
flutter analyze
flutter test                         # ViewModels do app
cd packages/core && flutter test     # contrato do servidor mockado
```
