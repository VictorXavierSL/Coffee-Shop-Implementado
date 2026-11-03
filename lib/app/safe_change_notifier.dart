import 'package:flutter/foundation.dart';

/// Evita `notifyListeners()` depois do `dispose()`.
///
/// Acontece quando uma chamada assíncrona termina depois que o Coordinator
/// já trocou de tela (ex.: login conclui → Home abre → Login é descartado).
mixin SafeChangeNotifier on ChangeNotifier {
  bool _disposed = false;

  bool get isDisposed => _disposed;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
