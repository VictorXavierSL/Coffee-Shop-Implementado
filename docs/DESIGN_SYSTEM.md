# Design System — Coffee Shop

Pacote: `packages/design_system` · Sample App: `packages/design_system/example`

Fonte: Figma **"Coffee Shop Mobile App Design (Community)"**
(`JpAfa1wvkvsNYCqNHDupoe`), páginas *Styleguide* e *Visual*.

```dart
import 'package:design_system/design_system.dart';
```

## 1. Tema

### 1.1 Cores — paleta do Figma

Estilos "Color Foundation" do arquivo, em `AppColors`:

| Figma | Hex | `AppColors` |
|---|---|---|
| Brown/Normal | `#C67C4E` | `brownNormal` |
| Brown/Light | `#F9F2ED` | `brownLight` |
| Grey/Normal | `#313131` | `greyNormal` |
| Grey/Normal :hover | `#2A2A2A` | `greyNormalHover` |
| Grey/Normal :active | `#242424` | `greyNormalActive` |
| Grey/Dark :active | `#050505` | `greyDarkActive` |
| Grey/Light :hover | `#909090` | `greyLightHover` |
| Grey/Lighter | `#A2A2A2` | `greyLighter` |
| Surface/White | `#FFFFFF` | `surfaceWhite` |
| Surface/White :active | `#EDEDED` | `surfaceWhiteActive` |
| Surface/Light | `#F9F9F9` | `surfaceLight` |
| Surface/Light :active | `#E3E3E3` | `surfaceLightActive` |
| Surface/Normal :active | `#D8D8D8` | `surfaceNormalActive` |
| Promo (tag do banner) | `#ED5151` | `red` |

### 1.2 Cores — tokens semânticos (o que os componentes usam)

Componentes nunca usam hexadecimal: leem papéis com `context.colors.<papel>`.
O tema escuro é uma **extensão** deste projeto (o Figma só tem o claro).

| Token | Claro | Escuro | Uso |
|---|---|---|---|
| `primary` | `#C67C4E` | `#C67C4E` | Botões, preço, item ativo |
| `onPrimary` | `#FFFFFF` | `#FFFFFF` | Conteúdo sobre `primary` |
| `primaryContainer` | `#F9F2ED` | `#3B2A20` | Chip de tamanho selecionado |
| `onPrimaryContainer` | `#C67C4E` | `#E9B48F` | |
| `background` | `#F9F9F9` | `#141110` | Fundo das telas |
| `surface` | `#FFFFFF` | `#211C19` | Cards, barras, campos |
| `surfaceVariant` | `#EDEDED` | `#2E2723` | Segmented control, chip inativo |
| `textPrimary` | `#242424` | `#F5EDE8` | Títulos |
| `textBody` | `#313131` | `#E3D8D1` | Corpo |
| `textSecondary` | `#A2A2A2` | `#A89C94` | Legendas |
| `textMuted` | `#909090` | `#A89C94` | Rótulos discretos ("Preço") |
| `border` | `#E3E3E3` | `#3D342E` | Bordas e divisores |
| `outline` | `#A2A2A2` | `#A89C94` | Botão outline |
| `heroStart` → `heroEnd` | `#111111` → `#313131` | `#080706` → `#1E1A17` | Gradiente do cabeçalho da Home |
| `heroSurface` | `#2A2A2A` | `#2A2420` | Busca e botões sobre o cabeçalho |
| `onHero` / `onHeroMuted` | `#FFFFFF` / `#D8D8D8` | `#F5EDE8` / `#E3D8D1` | Texto sobre o cabeçalho |
| `danger` | `#ED5151` | `#F07A7A` | Erros |
| `success` | `#3E9B5B` | `#6FC08A` | Sucesso, progresso do pedido |
| `star` | `#FBBE21` | `#FBBE21` | Estrela da avaliação |

### 1.3 Tipografia — Sora

| Token | Tamanho / peso / altura | Exemplo no Figma |
|---|---|---|
| `display` | 32 · SemiBold · 1.5 | "Fall in Love with Coffee..." |
| `bannerTitle` | 32 · SemiBold · 1.25 | "Buy one get one FREE" |
| `headline` | 20 · SemiBold · 1.5 | Nome no Detail |
| `title` | 16 · SemiBold · 1.5 | Títulos de seção, nome no card, botões |
| `titleSmall` | 14 · SemiBold · 1.5 | Endereço, linha de desconto |
| `body` | 14 · Regular · 1.5 | Categorias, resumo |
| `bodyLight` | 14 · Light · 1.5 | Descrição do produto |
| `caption` | 12 · Regular · 1.2 | "Deep Foam", "Location" |
| `captionStrong` | 12 · SemiBold · 1.5 | Valor do pagamento |
| `price` | 18 · SemiBold · 1.5 | "$ 4.53" |
| `button` | 16 · SemiBold · 1.5 | Botões grandes |
| `buttonSmall` | 12 · Regular · 1.2 | Botões outline |
| `tiny` | 8 · SemiBold · 1.5 | Nota no selo de avaliação |

### 1.4 Espaçamento, raios e sombras

- **`AppSpacing`**: `xxs 4 · xs 8 · sm 12 · md 16 · lg 24 · xl 32 · xxl 48`. Margem lateral das telas = `lg` (24).
- **`AppRadius`**: `xs 6` (aba de categoria) · `sm 8` (botão "+", miniatura) · `md 12` (busca, chip de tamanho, foto) · `lg 16` (card, botão principal, banner) · `xl 24` (barra inferior) · `pill`.
- **`AppShadows`**: `card`, `bottomBar`.

## 2. Padrão dos componentes

Cada componente vive em `lib/src/components/<nome>/` com três arquivos:

| Arquivo | Papel |
|---|---|
| `<nome>_view_model.dart` | Classe `@immutable` com os **dados e o estado** de uma instância (texto, habilitado, selecionado...) e os **callbacks delegados** (`onPressed`, `onChanged`...) |
| `<nome>_factory.dart` | **Factory**: métodos estáticos que criam as variantes válidas do Figma (`primary`, `addItem`, `size`...) |
| `<nome>_component.dart` | `Widget` que **só desenha** a ViewModel, lendo cores por `context.colors` |

Fluxo: **ViewModel da cena → Factory → ViewModel do componente → Component → Widget**.

```dart
// Na ViewModel da cena:
ActionButtonViewModel get buyButton => ActionButtonFactory.primary(
      label: 'Comprar agora',
      isEnabled: product.isAvailable,
      onPressed: buyNow, // Delegate: o botão não sabe o que acontece
    );

// Na View:
ActionButtonComponent(viewModel: vm.buyButton)
```

**Primitivas** (`lib/src/primitives/`) são peças visuais pequenas, sem ViewModel:
`ProductImage`, `RatingLabel`, `SectionTitle`, `InsetDivider`, `SectionBreak`.

## 3. Catálogo de componentes

| Componente | Factory → variantes | Figma |
|---|---|---|
| **ActionButton** | `primary`, `secondary`, `outline`, `addItem`, `filter`, `back`, `favorite`, `ghostIcon`, `heroIcon` · estados: habilitado, desabilitado, carregando | Get Started, Buy Now, Order, "+", Filter, Back, Favourite, Edit Address |
| **AppTextField** | `email`, `password` (mostrar/ocultar), `text`, `search` · estado de erro | Search coffee (+ Login, criado com o DS) |
| **SelectableChip** | `category`, `size` · selecionado / normal / desabilitado | All Coffee · Machiato…, S/M/L |
| **CategoryTabs** | `make` (composto de SelectableChip) | Category |
| **SegmentedControl** | `deliveryType`, `options` | Deliver / Pick Up |
| **BottomNavBar** | `coffeeShop` (Home, Favoritos, Sacola com contador, Notificações) | Button Icon |
| **TopBar** | `back`, `detail` | Detail / Order header |
| **ProductCard** | `make`, `unavailable` | Product |
| **PromoBanner** | `make` | Banner |
| **FeatureBadge** | `fastDelivery`, `qualityBean`, `extraMilk`, `fromCode` | Superiority |
| **QuantityStepper** | `cartItem` | Add Item (− 1 +) |
| **CartItemTile** | `make` (contém um QuantityStepper) | Checkout Product |
| **ActionTile** | `discount`, `paymentMethod` | Discount, Payment Method |
| **SummaryRow** | `line`, `discounted`, `total` | Payment Summary |
| **StepProgress** | `orderStatus` | Barra de 4 etapas (Delivery) |
| **StatusCard** | `orderStatus`, `courier` | Delivered your order, Driver |
| **StateView** | `loading`, `empty`, `error` | (estados não felizes) |
| **AppMessage** | `info`, `success`, `error` → `AppMessageComponent.show` | (SnackBar) |

O Sample App (`packages/design_system/example`) mostra todas as variantes e estados
acima, nos dois temas, chamando as mesmas factories que o app usa.

## 4. Como adicionar um componente

1. Crie `lib/src/components/meu_componente/` com os três arquivos.
2. No Component, leia cores só por `context.colors` e tipografia por `AppTypography`.
3. Exporte os três arquivos em `lib/design_system.dart`.
4. Adicione uma seção no Sample App (`example/lib/pages/`).
5. Use na cena pela Factory — nunca montando a ViewModel do componente "na mão".

## 5. Ícones e imagens

- O Figma usa os ícones *Iconly*; o DS usa os equivalentes do **Material Icons**
  (sem dependência extra). Para fidelidade total, exporte os SVGs do Figma e use `flutter_svg`.
- As fotos não são redistribuídas no repositório. Exporte-as do Figma para
  `assets/images/` com os nomes listados em `assets/images/README.md`. Enquanto
  não existirem, `ProductImage` desenha um placeholder com as cores da marca.
