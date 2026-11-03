import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';

import '../../app/safe_change_notifier.dart';
import 'order_tracking_coordinator.dart';
import 'order_tracking_server.dart';

/// Figma: "High-Fidelity (Delivery)".
class OrderTrackingViewModel extends ChangeNotifier with SafeChangeNotifier {
  OrderTrackingViewModel({
    required this.orderId,
    required OrderTrackingServer server,
    required OrderTrackingCoordinator coordinator,
  })  : _server = server,
        _coordinator = coordinator;

  final String orderId;
  final OrderTrackingServer _server;
  final OrderTrackingCoordinator _coordinator;

  Order? _order;
  String? _errorMessage;
  bool _isLoading = true;
  bool _isRefreshing = false;

  Order? get order => _order;
  bool get isRefreshing => _isRefreshing;

  Future<void> load() async {
    _isLoading = _order == null;
    _isRefreshing = _order != null;
    _errorMessage = null;
    notifyListeners();
    try {
      _order = await _server.order(orderId);
    } on ApiException catch (e) {
      if (_order == null) {
        _errorMessage = e.message;
      } else {
        _coordinator.showMessage(AppMessageFactory.error(e.message));
      }
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// No servidor mockado, cada consulta avança o pedido uma etapa.
  Future<void> refresh() => load();

  void goToHome() => _coordinator.goToHome();

  void callCourier() {
    final courier = _order?.courier;
    if (courier == null) return;
    _coordinator.showMessage(AppMessageFactory.info('Ligando para ${courier.name} (${courier.phone})...'));
  }

  // ---------------------------------------------------- textos derivados

  bool get isDelivered => _order?.status == OrderStatus.delivered;

  String get headline {
    final o = _order;
    if (o == null) return '';
    if (o.status == OrderStatus.delivered) {
      return o.deliveryType == DeliveryType.deliver ? 'Pedido entregue!' : 'Pronto para retirar!';
    }
    return '${o.estimatedMinutes} minutos restantes';
  }

  String get destination {
    final o = _order;
    if (o == null) return '';
    return o.deliveryType == DeliveryType.deliver
        ? 'Entrega em ${o.address?.title ?? 'seu endereço'}'
        : 'Retirada na loja · Pedido ${o.id}';
  }

  (String, String) get _statusTexts => switch (_order?.status ?? OrderStatus.placed) {
        OrderStatus.placed => ('Pedido recebido', 'A loja confirmou o seu pedido.'),
        OrderStatus.preparing => ('Preparando seu café', 'Nosso barista está preparando seu pedido.'),
        OrderStatus.onTheWay => ('Saiu para entrega', 'Vamos entregar no menor tempo possível.'),
        OrderStatus.delivered => ('Pedido concluído', 'Bom café! Obrigado pela preferência.'),
      };

  // ------------------------------------- ViewModels dos componentes do DS

  TopBarViewModel get topBar => TopBarViewModel(
        title: 'Acompanhar pedido',
        leading: ActionButtonFactory.back(onPressed: goToHome),
      );

  StateViewViewModel? get contentState {
    if (_isLoading) return StateViewFactory.loading;
    if (_errorMessage != null) return StateViewFactory.error(message: _errorMessage!, onRetry: load);
    return null;
  }

  StepProgressViewModel get progress =>
      StepProgressFactory.orderStatus(completedSteps: _order?.status.completedSteps ?? 0);

  StatusCardViewModel get statusCard {
    final (title, message) = _statusTexts;
    return StatusCardFactory.orderStatus(title: title, message: message);
  }

  StatusCardViewModel? get courierCard {
    final courier = _order?.courier;
    if (courier == null) return null;
    return StatusCardFactory.courier(
      name: courier.name,
      role: 'Entregador parceiro',
      onCall: callCourier,
    );
  }

  ActionButtonViewModel get mainButton => isDelivered
      ? ActionButtonFactory.primary(label: 'Voltar ao início', onPressed: goToHome)
      : ActionButtonFactory.secondary(
          label: _isRefreshing ? 'Atualizando...' : 'Atualizar status',
          isEnabled: !_isRefreshing,
          onPressed: refresh,
        );
}
