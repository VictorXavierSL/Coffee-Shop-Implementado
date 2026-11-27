# Feature Specification: Esteira de Testes dos Fluxos do Protótipo

**Feature Branch**: `009-esteira-testes-fluxos` (sem branch git; diretório `specs/009-esteira-testes-fluxos`)

**Created**: 2026-11-27

**Status**: Draft (planejada para depois das features 002–008)

**Input**: User description: "Marque para depois uma esteira de testes para testar os fluxos do
protótipo."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Rodar todos os fluxos com um comando (Priority: P1)

Uma pessoa desenvolvedora executa um único comando que sobe o ambiente de demonstração, roda os
fluxos principais do protótipo de ponta a ponta e mostra um relatório de quais passaram e quais
falharam.

**Why this priority**: garante que nenhuma feature quebre as outras.

**Independent Test**: executar o comando em uma máquina com os pré-requisitos e obter o
relatório.

**Acceptance Scenarios**:

1. **Given** o repositório, **When** a pessoa roda o comando documentado, **Then** os fluxos
   rodam e o relatório indica sucesso ou falha de cada um.
2. **Given** um fluxo quebrado, **When** a esteira roda, **Then** o relatório aponta o fluxo e o
   passo que falhou.

---

### User Story 2 - Rodar a esteira automaticamente a cada envio (Priority: P2)

A cada envio de código para o repositório, a esteira roda sozinha e marca o envio como aprovado
ou reprovado.

**Why this priority**: evita depender da memória das pessoas para rodar os testes.

**Independent Test**: enviar uma alteração que quebra um fluxo e ver o envio reprovado.

**Acceptance Scenarios**:

1. **Given** um envio para o repositório, **When** a esteira termina, **Then** o resultado
   aparece no envio.

### Edge Cases

- Resultados aleatórios (pagamento, popup) precisam ser controláveis nos testes para não gerar
  falhas intermitentes.
- O ambiente de testes sempre começa com os dados de demonstração restaurados.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A esteira MUST cobrir no mínimo estes fluxos: login por e-mail, login por nome de
  usuário, login Google/Apple simulado, criação de conta, bloqueio por tentativas, Home →
  detalhes com índices, favoritar, avaliações, carrinho lateral → completo, pagamento aprovado,
  recusado e estornado, mapa de entrega, telas de erro, não encontrado e fora do ar.
- **FR-002**: A esteira MUST incluir as análises e os testes já existentes (análise estática,
  ViewModels, contrato).
- **FR-003**: A esteira MUST restaurar os dados de demonstração antes de rodar.
- **FR-004**: Comportamentos aleatórios MUST poder ser fixados durante os testes.
- **FR-005**: A esteira MUST rodar localmente com um comando e automaticamente a cada envio ao
  repositório.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% dos fluxos listados em FR-001 têm teste automatizado.
- **SC-002**: A esteira completa roda em menos de 15 minutos.
- **SC-003**: 0 falhas intermitentes em 10 execuções seguidas sem alterações.

## Assumptions

- Depende das features 002 a 008; seu `/speckit-plan` só deve ser executado depois delas.
- Os testes de ViewModel e de contrato continuam sendo entregues por cada feature (constitution,
  princípio IX); esta esteira os integra e acrescenta os testes de ponta a ponta.
