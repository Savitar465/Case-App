import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market_app/app/app.dart';
import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/auth/domain/entities/auth_user.dart';
import 'package:market_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:market_app/features/auth/presentation/pages/login_page.dart';
import 'package:market_app/features/business/domain/entities/business.dart';
import 'package:market_app/features/business/domain/entities/business_image.dart';
import 'package:market_app/features/business/domain/repositories/business_repository.dart';
import 'package:market_app/features/items/domain/entities/item.dart';
import 'package:market_app/features/items/domain/repositories/item_repository.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthSession> login({required String email, required String password}) {
    final user = AuthUser(id: '1', email: email);
    return Future.value(AuthSession(user: user, accessToken: 'token'));
  }

  @override
  Future<AuthSession?> signUp({
    required String email,
    required String password,
  }) async {
    final user = AuthUser(id: '1', email: email);
    return AuthSession(user: user, accessToken: 'token');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async => null;
}

class _FakeBusinessRepository implements BusinessRepository {
  @override
  Stream<List<Business>> watchBusinesses() =>
      Stream<List<Business>>.value(const []);

  @override
  Future<void> refreshBusinesses() async {}

  @override
  Future<Business?> getBusiness(String id) async => null;

  @override
  Future<List<BusinessImage>> getBusinessImages(String businessId) async =>
      const [];

  @override
  Future<bool> isFollowing(String businessId) async => false;

  @override
  Future<bool> toggleFollow(String businessId) async => false;
}

class _FakeItemRepository implements ItemRepository {
  @override
  Stream<List<Item>> watchItems(String businessId) =>
      Stream<List<Item>>.value(const []);

  @override
  Future<void> refreshItems(String businessId) async {}

  @override
  Future<Item?> getItem(String id) async => null;
}

void main() {
  testWidgets('Shows Login screen initially', (WidgetTester tester) async {
    final authRepository = _FakeAuthRepository();
    final businessRepository = _FakeBusinessRepository();
    final itemRepository = _FakeItemRepository();
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>.value(value: authRepository),
          RepositoryProvider<BusinessRepository>.value(
            value: businessRepository,
          ),
          RepositoryProvider<ItemRepository>.value(value: itemRepository),
        ],
        child: App(authRepository: authRepository),
      ),
    );
    await tester.pump();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
