---
name: visual-nao-implementado-02
description: Prévia visual nº 02 do Coffee Shop, NÃO implementada. Página HTML com as telas atuais e as planejadas nas specs 001–009. Use quando o usuário quiser ver, abrir, revisar ou comparar o visual planejado.
argument-hint: "Vazio para abrir a prévia; ou o nome de uma tela/grupo para comentar"
user-invocable: true
---

# Visual não implementado — versão 02

Prévia **só visual** do app, criada em 2026-11-27 a partir da versão 01.

## O que mudou da 01 para a 02

- **Resultado do pagamento em tela inteira** (spec 003, clarificação de 2026-11-27): o celular é a
  xícara. Aprovado: o café sobe e enche a tela, e um ✓ branco é desenhado como leite (latte art),
  com "Compra concluída!" e os botões "Acompanhar pedido" e "Voltar ao cardápio". Recusado ou
  estornado: uma fumaça vermelha cobre a tela, com o X branco no meio e dois botões. Ao tocar em
  um botão, o líquido ou a fumaça continua subindo e passa pela tela (borda de trás ondulada),
  revelando o destino. É um movimento só, da entrada à saída.
- **Processando pagamento** agora usa o café fumegante (spec 004), e não mais o spinner.
- O resto é igual à 01, inclusive as etiquetas com a numeração antiga das specs.
 **Não é código do app** e não implementa
nenhuma spec. Serve para enxergar o resultado esperado antes de rodar o `/speckit-plan` e o
`/speckit-implement`.

- Arquivo: `.claude/skills/visual-nao-implementado-02/index.html` (uma página, sem dependências;
  a fonte Sora vem do Google Fonts e cai para a fonte do sistema se não houver internet).
- Abrir no Windows: `Start-Process .claude/skills/visual-nao-implementado-02/index.html`
  (macOS: `open`; Linux: `xdg-open`).

## Como usar esta skill

- **Sem argumento:** abra o `index.html` no navegador do usuário e resuma o que ele mostra
  (os grupos abaixo).
- **Com o nome de uma tela ou grupo:** explique o que a tela mostra, de qual spec vem e o que é
  ilustrativo.
- **Para mudar o visual:** NÃO edite esta versão. Copie para `visual-nao-implementado-03`
  (pasta e `name` novos) e registre a mudança na `/linha-do-tempo`. Assim as versões ficam
  comparáveis.
- Os dados desta prévia **não são decisões**. Se algo daqui for para o código, confirme antes
  com o usuário e registre nas specs (regra do `CLAUDE.md`).

## O que a página mostra

Cada tela tem a etiqueta **Atual** (já existe no código) ou **Planejado** (com o número da spec).

| Grupo | Telas | Specs |
|---|---|---|
| 1 · Entrada e conta | Launch (café fumegante), Onboarding, Login (e-mail ou usuário, Google/Apple simulado), Criar conta (foto opcional, confirmação de e-mail automática) | 003, 005 |
| 2 · Catálogo | Home com endereço em Palmas e carrinho lateral, popup da indicação do dia, Detalhes (saco de grão, índices em grãos, P/M/G com ml e R$, avaliações), Favoritos | 006, 007 |
| 3 · Carrinho e pagamento | Pedido completo (Pix, crédito, débito, dinheiro) e Resultado (processando, aprovado, recusado, estornado) | 003, 007 |
| 4 · Entrega | Mapa acompanhando a entrega (loja na Praça dos Girassóis), Mapa escolhendo o endereço, Acompanhamento | 002, 008 |
| 5 · Telas de estado | Erro (café derramado), Não encontrado/indisponível (copo vazio), Fora do ar (xícara desligada caindo do letreiro) | 002, 003, 004 |

> Numeração atualizada em 2026-11-27: a spec 004 (inter telas) foi criada e as antigas
> 004–008 viraram 005–009. As etiquetas **dentro** do `index.html` mostram a numeração antiga
> (002–008) e ficam assim de propósito, para a versão 01 não ser alterada. Para converter:
> 004→005, 005→006, 006→007, 007→008. Diferença conhecida: a spec 004 define que o
> "processando pagamento" usa o café fumegante, mas esta prévia mostra um spinner.

**O que responde a cliques:** "+" adiciona ao carrinho; ♡ favorita; a sacola abre o painel
lateral (com controle de quantidade); P/M/G troca o ml e o preço; os botões ✅ ❌ ↩ e
"Fazer pedido" simulam o pagamento (o último sorteia, com 80% de aprovação); 🌙 alterna o tema
escuro.

## O que é só ilustrativo (não decidido)

- Preços em R$ e valores dos índices.
- Nomes de demonstração inventados: usuário `bruno.palmas`, entregador "Rafael Lima",
  "Arábica Cerrado Mineiro" e os endereços de exemplo.
- Fotos de café em CSS e animações simples em SVG/CSS, com os ids de animação planejados na
  spec 003 (`coffee_steaming`, `coffee_spilled`, `cup_empty`, `server_down`,
  `payment_success`, `payment_failure`).
- O mapa é um esquema simplificado de Palmas, sem fidelidade cartográfica.

Os valores reais virão do seed do servidor (spec 002).
