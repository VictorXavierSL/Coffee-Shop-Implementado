import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../app/safe_change_notifier.dart';
import 'order_coordinator.dart';
import 'order_server.dart';

class OrderViewModel extends ChangeNotifier with SafeChangeNotifier {
  OrderViewModel({
    required OrderServer server,
    required OrderCoordinator coordinator,
    required CartStore cartStore,
  })  : _server = server,
        _coordinator = coordinator,
        _cart = cartStore,
        _address = server.defaultAddress {
    _cart.addListener(_onCartChanged);
  }

  final OrderServer _server;
  final OrderCoordinator _coordinator;
  final CartStore _cart;

  static const paymentMethod = 'Dinheiro/Carteira';

  DeliveryType _deliveryType = DeliveryType.deliver;
  final Address? _address;
  PriceSummary? _summary;
  String? _quoteError;
  bool _isQuoting = false;
  bool _isPlacing = false;
  int _quoteId = 0;

  DeliveryType get deliveryType => _deliveryType;
  bool get isDelivery => _deliveryType == DeliveryType.deliver;
  Address? get address => _address;
  PriceSummary? get summary => _summary;
  String? get quoteError => _quoteError;
  bool get isQuoting => _isQuoting;
  bool get isPlacing => _isPlacing;
  bool get isEmpty => _cart.isEmpty;
  List<CartItem> get items => _cart.items;

  // ------------------------------------------------------------- ações

  Future<void> start() => _requote();

  void selectDeliveryType(int index) {
    final type = index == 0 ? DeliveryType.deliver : DeliveryType.pickUp;
    if (type == _deliveryType) return;
    _deliveryType = type;
    notifyListeners();
    _requote();
  }

  void increment(String key) => _cart.increment(key);

  void decrement(String key) => _cart.decrement(key);

  void editAddress() => _info('Edição de endereço chega na próxima versão.');

  void addNote() => _info('Observações para o pedido chegam na próxima versão.');

  void openDiscounts() => _info('Desconto de entrega aplicado automaticamente.');

  void choosePayment() => _info('Nesta demonstração, apenas $paymentMethod.');

  Future<void> placeOrder() async {
    if (_isPlacing || _cart.isEmpty) return;
    if (isDelivery && _address == null) {
      _coordinator.showMessage(AppMessageFactory.error('Cadastre um endereço de entrega.'));
      return;
    }
    _isPlacing = true;
    notifyListeners();
    try {
      final order = await _server.place(
        deliveryType: _deliveryType,
        items: _cart.items,
        paymentMethod: paymentMethod,
        address: isDelivery ? _address : null,
      );
      _cart.clear();
      _coordinator.goToTracking(order.id);
    } on ApiException catch (e) {
      _coordinator.showMessage(AppMessageFactory.error(e.message));
    } finally {
      _isPlacing = false;
      notifyListeners();
    }
  }

  void back() => _coordinator.back();

  void _onCartChanged() {
    notifyListeners();
    _requote();
  }

  Future<void> _requote() async {
    if (_cart.isEmpty) {
      _summary = null;
      notifyListeners();
      return;
    }
    final id = ++_quoteId;
    _isQuoting = true;
    notifyListeners();
    try {
      final result = await _server.quote(deliveryType: _deliveryType, items: _cart.items);
      if (id == _quoteId) {
        _summary = result;
        _quoteError = null;
      }
    } on ApiException catch (e) {
      if (id == _quoteId) _quoteError = e.message;
    } finally {
      if (id == _quoteId) {
        _isQuoting = false;
        notifyListeners();
      }
    }
  }

  void _info(String text) => _coordinator.showMessage(AppMessageFactory.info(text));

  // ------------------------------------- ViewModels dos componentes do DS

  TopBarViewModel get topBar => TopBarFactory.back(title: 'Pedido', onBack: back);

  SegmentedControlViewModel get deliveryToggle => SegmentedControlFactory.deliveryType(
        isDelivery: isDelivery,
        onChanged: selectDeliveryType,
      );

  ActionButtonViewModel get editAddressButton => ActionButtonFactory.outline(
        label: 'Editar endereço',
        icon: Icons.edit_outlined,
        onPressed: editAddress,
      );

  ActionButtonViewModel get addNoteButton => ActionButtonFactory.outline(
        label: 'Adicionar nota',
        icon: Icons.sticky_note_2_outlined,
        onPressed: addNote,
      );

  List<CartItemTileViewModel> get cartTiles => [
        for (final item in _cart.items)
          CartItemTileFactory.make(
            title: item.product.name,
            subtitle: '${item.product.subtitle} · ${item.sizeCode}',
            quantity: item.quantity,
            imageSource: item.product.imageUrl,
            onIncrement: () => increment(item.key),
            onDecrement: () => decrement(item.key),
          ),
      ];

  ActionTileViewModel? get discountTile {
    final label = _summary?.discountLabel;
    return label == null ? null : ActionTileFactory.discount(text: label, onTap: openDiscounts);
  }

  List<SummaryRowViewModel> get summaryRows {
    final s = _summary;
    if (s == null) return const [];
    return [
      SummaryRowFactory.line(label: 'Preço', value: Formatters.money(s.subtotal)),
      if (isDelivery)
        s.hasDeliveryDiscount
            ? SummaryRowFactory.discounted(
                label: 'Taxa de entrega',
                value: Formatters.money(s.deliveryFee),
                previousValue: Formatters.money(s.deliveryFeeOriginal),
              )
            : SummaryRowFactory.line(label: 'Taxa de entrega', value: Formatters.money(s.deliveryFee)),
      SummaryRowFactory.total(label: 'Total', value: Formatters.money(s.total)),
    ];
  }

  ActionTileViewModel get paymentTile => ActionTileFactory.paymentMethod(
        method: paymentMethod,
        amountLabel: _summary == null ? '—' : Formatters.money(_summary!.total),
        onTap: choosePayment,
      );

  ActionButtonViewModel get orderButton => ActionButtonFactory.primary(
        label: 'Fazer pedido',
        isLoading: _isPlacing,
        isEnabled: _summary != null && !_isQuoting,
        onPressed: placeOrder,
      );

  StateViewViewModel get emptyState => StateViewFactory.empty(
        title: 'Sua sacola está vazia',
        message: 'Escolha um café no cardápio para fazer seu pedido.',
        actionLabel: 'Ver cardápio',
        onAction: back,
      );

  @override
  void dispose() {
    _cart.removeListener(_onCartChanged);
    super.dispose();
  }
}
