import 'package:auto_tech/widgets/stateless/Loading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Tests Loading Widget', () {
    var loadingWithText = Loading(text: "Your car helper");
    var loadingWithoutText = Loading();

    expect(loadingWithText.buildWidgets().length, 3);
    expect(loadingWithoutText.buildWidgets().length, 1);
  });
}
