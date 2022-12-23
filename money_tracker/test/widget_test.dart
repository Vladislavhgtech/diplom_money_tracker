import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_tracker/blocs/bloc/formtype_bloc.dart';
import 'package:money_tracker/blocs/bloc/login_bloc.dart';
import 'package:money_tracker/repositories/login_repository.dart';
import 'package:money_tracker/widgets/login_page.dart';

void main() async {
  final _firebase = MockFirebaseAuth();

  var widgetLogin = MultiBlocProvider(
    providers: [
      BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(
          loginRepository: LoginRepository(firebase: _firebase),
        ),
      ),
      BlocProvider<FormTypeBloc>(
        create: (_) => FormTypeBloc(),
      ),
    ],
    child: const MaterialApp(
      home: LoginPage(),
    ),
  );

  var emailField = find.byKey(const Key('fieldEmail'));
  var passwordField = find.byKey(const Key('fieldPassword'));
  var loginButton = find.byKey(const Key('buttonLogin'));
  var signInOrSignUpButton = find.byKey(const Key('buttonSignInOrSignUp'));

  group('LoginPage test', () {
    testWidgets("email, password and button are found",
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetLogin);

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);
    });

    testWidgets("validates empty email and password",
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetLogin);

      await tester.tap(loginButton);
      await tester.pump();
      expect(find.text('Введите e-mail'), findsOneWidget);
      expect(find.text('Введите пароль'), findsOneWidget);
    });

    testWidgets("validates incorrect email", (WidgetTester tester) async {
      await tester.pumpWidget(widgetLogin);

      await tester.enterText(emailField, '123');
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.text('Поле e-mail заполнено не корректно'), findsOneWidget);
    });

    testWidgets("toggle form type SignIn or SignUp",
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetLogin);

      expect(find.text('Войти'), findsOneWidget);
      await tester.tap(signInOrSignUpButton);
      await tester.pump();
      expect(find.text('Регистрация'), findsOneWidget);
    });
  });
}
