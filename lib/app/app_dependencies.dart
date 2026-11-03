import 'package:core/core.dart';
import 'package:design_system/design_system.dart';

/// Composition Root (Singleton): o ÚNICO lugar que cria as dependências
/// compartilhadas. As Factories das cenas pegam daqui o que precisam e
/// injetam nos Servers e ViewModels.
///
/// Para trocar o servidor mockado por um real, mude apenas [apiClient].
class AppDependencies {
  AppDependencies._();

  static final AppDependencies instance = AppDependencies._();

  final ThemeController themeController = ThemeController();
  final SessionStore sessionStore = InMemorySessionStore();
  final CartStore cartStore = CartStore();
  final FavoritesStore favoritesStore = FavoritesStore();

  late final ApiClient apiClient = AuthorizedApiClient(
    inner: MockApiClient(),
    sessionStore: sessionStore,
  );

  late final AuthRepository authRepository =
      AuthRepository(api: apiClient, sessionStore: sessionStore);
  late final CatalogRepository catalogRepository = CatalogRepository(api: apiClient);
  late final OrderRepository orderRepository = OrderRepository(api: apiClient);
}
