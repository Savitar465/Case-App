import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:market_app/app/app.dart';
import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/auth/domain/entities/auth_user.dart';
import 'package:market_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:market_app/features/auth/presentation/pages/login_page.dart';
import 'package:market_app/features/business/domain/entities/business.dart';
import 'package:market_app/features/business/domain/repositories/business_repository.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthSession> login({required String email, required String password}) {
    final user = AuthUser(id: '1', email: email);
    return Future.value(AuthSession(user: user, accessToken: 'token'));
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
}

void main() {
  testWidgets('Shows Login screen initially', (WidgetTester tester) async {
    final authRepository = _FakeAuthRepository();
    final businessRepository = _FakeBusinessRepository();
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>.value(value: authRepository),
          RepositoryProvider<BusinessRepository>.value(value: businessRepository),
        ],
        child: App(authRepository: authRepository),
      ),
    );
    await tester.pump();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
