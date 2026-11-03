import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../catalog_scaffold.dart';

void _noop() {}

// ============================================================ Action Button

class ActionButtonPage extends StatelessWidget {
  const ActionButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogScaffold(
      title: 'Action Button',
      children: [
        ShowcaseSection(
          title: 'Primary',
          description: 'Ação principal da tela: "Começar", "Comprar agora", "Fazer pedido".',
          wrap: false,
          items: [
            ShowcaseItem(caption: 'Habilitado', child: ActionButtonComponent(viewModel: ActionButtonFactory.primary(label: 'Comprar agora', onPressed: _noop))),
            ShowcaseItem(caption: 'Carregando', child: ActionButtonComponent(viewModel: ActionButtonFactory.primary(label: 'Comprar agora', isLoading: true, onPressed: _noop))),
            ShowcaseItem(caption: 'Desabilitado', child: ActionButtonComponent(viewModel: ActionButtonFactory.primary(label: 'Indisponível', isEnabled: false))),
          ],
        ),
        ShowcaseSection(
          title: 'Secondary',
          wrap: false,
          items: [
            ShowcaseItem(caption: 'Habilitado', child: ActionButtonComponent(viewModel: ActionButtonFactory.secondary(label: 'Atualizar status', onPressed: _noop))),
          ],
        ),
        ShowcaseSection(
          title: 'Outline',
          description: 'Pílula pequena com ícone ("Edit Address", "Add Note").',
          items: [
            ShowcaseItem(caption: 'Com ícone', child: ActionButtonComponent(viewModel: ActionButtonFactory.outline(label: 'Editar endereço', icon: Icons.edit_outlined, onPressed: _noop))),
            ShowcaseItem(caption: 'Só texto', child: ActionButtonComponent(viewModel: ActionButtonFactory.outline(label: 'Adicionar nota', onPressed: _noop))),
          ],
        ),
        ShowcaseSection(
          title: 'Ícone',
          description: 'O botão de adicionar item ("+") é um botão de ícone primary pequeno.',
          items: [
            ShowcaseItem(caption: 'Adicionar (+)', child: ActionButtonComponent(viewModel: ActionButtonFactory.addItem(onPressed: _noop))),
            ShowcaseItem(caption: '+ desabilitado', child: ActionButtonComponent(viewModel: ActionButtonFactory.addItem(isEnabled: false))),
            ShowcaseItem(caption: 'Filtro', child: ActionButtonComponent(viewModel: ActionButtonFactory.filter(onPressed: _noop))),
            ShowcaseItem(caption: 'Voltar', child: ActionButtonComponent(viewModel: ActionButtonFactory.back(onPressed: _noop))),
            ShowcaseItem(caption: 'Favorito', child: ActionButtonComponent(viewModel: ActionButtonFactory.favorite(isFavorite: true, onPressed: _noop))),
            ShowcaseItem(
              caption: 'Hero (sobre fundo escuro)',
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                color: context.colors.heroStart,
                child: ActionButtonComponent(
                  viewModel: ActionButtonFactory.heroIcon(icon: Icons.logout_rounded, semanticLabel: 'Sair', onPressed: _noop),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================== Text Field

class TextFieldPage extends StatelessWidget {
  const TextFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogScaffold(
      title: 'Text Field',
      children: [
        ShowcaseSection(
          title: 'Formulário',
          wrap: false,
          items: [
            ShowcaseItem(caption: 'E-mail', child: AppTextFieldComponent(viewModel: AppTextFieldFactory.email())),
            ShowcaseItem(caption: 'Senha (com mostrar/ocultar)', child: AppTextFieldComponent(viewModel: AppTextFieldFactory.password())),
            ShowcaseItem(caption: 'Erro de validação', child: AppTextFieldComponent(viewModel: AppTextFieldFactory.email(initialValue: 'ana@', errorText: 'E-mail inválido.'))),
            ShowcaseItem(caption: 'Desabilitado', child: AppTextFieldComponent(viewModel: AppTextFieldFactory.email(initialValue: 'ana@coffee.dev', isEnabled: false))),
          ],
        ),
        ShowcaseSection(
          title: 'Busca',
          description: 'Variante escura usada no cabeçalho da Home.',
          wrap: false,
          items: [
            ShowcaseItem(
              caption: 'Search',
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.heroStart,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: AppTextFieldComponent(viewModel: AppTextFieldFactory.search()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================== Selection

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  String _size = 'M';
  int _category = 0;
  bool _delivery = true;

  @override
  Widget build(BuildContext context) {
    const categories = ['Todos', 'Machiato', 'Latte', 'Americano'];
    return CatalogScaffold(
      title: 'Selection',
      children: [
        ShowcaseSection(
          title: 'Chip de tamanho (interativo)',
          items: [
            for (final s in const ['S', 'M', 'L'])
              ShowcaseItem(
                caption: s == _size ? 'Selecionado' : 'Normal',
                child: SelectableChipComponent(
                  viewModel: SelectableChipFactory.size(
                    label: s,
                    isSelected: s == _size,
                    onSelected: () => setState(() => _size = s),
                  ),
                ),
              ),
          ],
        ),
        ShowcaseSection(
          title: 'Chip de categoria (interativo)',
          items: [
            for (var i = 0; i < categories.length; i++)
              ShowcaseItem(
                caption: i == _category ? 'Ativo' : 'Inativo',
                child: SelectableChipComponent(
                  viewModel: SelectableChipFactory.category(
                    label: categories[i],
                    isSelected: i == _category,
                    onSelected: () => setState(() => _category = i),
                  ),
                ),
              ),
            ShowcaseItem(
              caption: 'Desabilitado',
              child: SelectableChipComponent(
                viewModel: SelectableChipFactory.category(label: 'Mocha', isSelected: false, isEnabled: false),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Segmented control',
          wrap: false,
          items: [
            ShowcaseItem(
              caption: _delivery ? 'Entregar' : 'Retirar',
              child: SegmentedControlComponent(
                viewModel: SegmentedControlFactory.deliveryType(
                  isDelivery: _delivery,
                  onChanged: (i) => setState(() => _delivery = i == 0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================== Navigation

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _category = 0;
  CoffeeTab _tab = CoffeeTab.home;

  @override
  Widget build(BuildContext context) {
    return CatalogScaffold(
      title: 'Navigation',
      children: [
        ShowcaseSection(
          title: 'Top bar',
          wrap: false,
          items: [
            ShowcaseItem(caption: 'Voltar + título', child: TopBarComponent(viewModel: TopBarFactory.back(title: 'Pedido', onBack: _noop))),
            ShowcaseItem(caption: 'Detalhe com favorito', child: TopBarComponent(viewModel: TopBarFactory.detail(title: 'Detalhes', isFavorite: false, onBack: _noop, onFavorite: _noop))),
          ],
        ),
        ShowcaseSection(
          title: 'Category tabs',
          description: 'Componente composto por Selectable Chips.',
          wrap: false,
          items: [
            ShowcaseItem(
              caption: 'Rolagem horizontal',
              child: CategoryTabsComponent(
                padding: EdgeInsets.zero,
                viewModel: CategoryTabsFactory.make(
                  labels: const ['Todos', 'Machiato', 'Latte', 'Americano', 'Mocha'],
                  selectedIndex: _category,
                  onSelected: (i) => setState(() => _category = i),
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Bottom nav bar',
          wrap: false,
          items: [
            ShowcaseItem(
              caption: 'Aba ativa com "dot"; sacola com contador',
              child: BottomNavBarComponent(
                viewModel: BottomNavBarFactory.coffeeShop(
                  selected: _tab,
                  bagCount: 2,
                  onSelected: (t) => setState(() => _tab = t),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ================================================================= Product

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogScaffold(
      title: 'Product',
      children: [
        ShowcaseSection(
          title: 'Product card',
          description: '156×238 no Figma. A foto usa placeholder até as imagens serem exportadas.',
          items: [
            ShowcaseItem(
              caption: 'Disponível',
              child: SizedBox(
                width: 156,
                height: 238,
                child: ProductCardComponent(
                  viewModel: ProductCardFactory.make(
                    title: 'Caffe Mocha',
                    subtitle: 'Deep Foam',
                    priceLabel: r'$ 4.53',
                    rating: 4.8,
                    onTap: _noop,
                    onAdd: _noop,
                  ),
                ),
              ),
            ),
            ShowcaseItem(
              caption: 'Indisponível',
              child: SizedBox(
                width: 156,
                height: 238,
                child: ProductCardComponent(
                  viewModel: ProductCardFactory.unavailable(
                    title: 'Iced Latte',
                    subtitle: 'Indisponível',
                    priceLabel: r'$ 4.10',
                    rating: 4.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Promo banner',
          wrap: false,
          items: [
            ShowcaseItem(caption: 'Promoção', child: PromoBannerComponent(viewModel: PromoBannerFactory.make(title: 'Leve 2, pague 1'))),
          ],
        ),
        ShowcaseSection(
          title: 'Feature badge e Rating',
          items: [
            ShowcaseItem(caption: 'Entrega rápida', child: FeatureBadgeComponent(viewModel: FeatureBadgeFactory.fastDelivery)),
            ShowcaseItem(caption: 'Grão selecionado', child: FeatureBadgeComponent(viewModel: FeatureBadgeFactory.qualityBean)),
            ShowcaseItem(caption: 'Leite extra', child: FeatureBadgeComponent(viewModel: FeatureBadgeFactory.extraMilk)),
            const ShowcaseItem(caption: 'Rating inline', child: RatingLabel.inline(rating: 4.8, reviewCount: 230)),
            ShowcaseItem(
              caption: 'Rating badge',
              child: Container(
                width: 80,
                height: 40,
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const RatingLabel.badge(rating: 4.8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ================================================================ Checkout

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return CatalogScaffold(
      title: 'Checkout',
      children: [
        ShowcaseSection(
          title: 'Cart item tile (interativo)',
          description: 'Composição: o tile contém um Quantity Stepper.',
          wrap: false,
          items: [
            ShowcaseItem(
              caption: 'Quantidade $_quantity',
              child: CartItemTileComponent(
                viewModel: CartItemTileFactory.make(
                  title: 'Caffe Mocha',
                  subtitle: 'Deep Foam · M',
                  quantity: _quantity,
                  onIncrement: () => setState(() => _quantity++),
                  onDecrement: () => setState(() => _quantity--),
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Action tile',
          wrap: false,
          items: [
            ShowcaseItem(caption: 'Desconto (com borda)', child: ActionTileComponent(viewModel: ActionTileFactory.discount(text: '1 desconto aplicado', onTap: _noop))),
            ShowcaseItem(caption: 'Forma de pagamento', child: ActionTileComponent(viewModel: ActionTileFactory.paymentMethod(method: 'Dinheiro/Carteira', amountLabel: r'$ 5.53', onTap: _noop))),
          ],
        ),
        ShowcaseSection(
          title: 'Summary row',
          wrap: false,
          items: [
            ShowcaseItem(caption: 'Linha simples', child: SummaryRowComponent(viewModel: SummaryRowFactory.line(label: 'Preço', value: r'$ 4.53'))),
            ShowcaseItem(caption: 'Com desconto', child: SummaryRowComponent(viewModel: SummaryRowFactory.discounted(label: 'Taxa de entrega', value: r'$ 1.00', previousValue: r'$ 2.00'))),
            ShowcaseItem(caption: 'Total', child: SummaryRowComponent(viewModel: SummaryRowFactory.total(label: 'Total', value: r'$ 5.53'))),
          ],
        ),
      ],
    );
  }
}

// ================================================================ Feedback

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogScaffold(
      title: 'Feedback',
      children: [
        ShowcaseSection(
          title: 'Step progress',
          wrap: false,
          items: [
            for (var step = 1; step <= 4; step++)
              ShowcaseItem(caption: 'Etapa $step de 4', child: StepProgressComponent(viewModel: StepProgressFactory.orderStatus(completedSteps: step))),
          ],
        ),
        ShowcaseSection(
          title: 'Status card',
          wrap: false,
          items: [
            ShowcaseItem(caption: 'Status do pedido', child: StatusCardComponent(viewModel: StatusCardFactory.orderStatus(title: 'Saiu para entrega', message: 'Vamos entregar no menor tempo possível.'))),
            ShowcaseItem(caption: 'Entregador', child: StatusCardComponent(viewModel: StatusCardFactory.courier(name: 'Brooklyn Simmons', role: 'Entregador parceiro', onCall: _noop))),
          ],
        ),
        ShowcaseSection(
          title: 'State view',
          wrap: false,
          items: [
            ShowcaseItem(caption: 'Vazio', child: StateViewComponent(viewModel: StateViewFactory.empty(title: 'Sua sacola está vazia', message: 'Escolha um café no cardápio.', actionLabel: 'Ver cardápio', onAction: _noop))),
            ShowcaseItem(caption: 'Erro', child: StateViewComponent(viewModel: StateViewFactory.error(message: 'Sem conexão.', onRetry: _noop))),
          ],
        ),
        ShowcaseSection(
          title: 'App message (SnackBar)',
          items: [
            for (final (label, vm) in [
              ('Info', AppMessageFactory.info('Nenhuma notificação por enquanto.')),
              ('Sucesso', AppMessageFactory.success('Caffe Mocha adicionado à sacola.')),
              ('Erro', AppMessageFactory.error('E-mail ou senha incorretos.')),
            ])
              ShowcaseItem(
                caption: 'Toque para ver',
                child: ActionButtonComponent(
                  viewModel: ActionButtonFactory.outline(
                    label: label,
                    onPressed: () => AppMessageComponent.show(context, vm),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
