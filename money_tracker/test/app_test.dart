import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  // flutter drive --target=test_driver/app.dart
  group('LoginPage test', () {
    final emailField = find.byValueKey('fieldEmail');
    final passwordField = find.byValueKey('fieldPassword');
    final loginButton = find.byValueKey('buttonLogin');
    final snackbar = find.byType('SnackBar');

    late FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test(
        "login fails with incorrect email and password, provides snackbar feedback",
        () async {
      await driver.tap(emailField);
      await driver.enterText('test@gmail.com');
      await driver.tap(passwordField);
      await driver.enterText('1234567');
      await driver.tap(loginButton);
      await driver.waitFor(snackbar);
      assert(snackbar != null);
    });
  });
}
