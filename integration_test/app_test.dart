import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const productPageViewKey = Key('ShrinePage_ProductPageView');
  const openCart = Key('ShrinePage_Cart');
  const cartTotal = Key('ShrinePage_Total');
  const shippingTotal = Key('ShrinePage_Shipping');
  const taxTotal = Key('ShrinePage_Tax');
  const subTotal = Key('ShrinePage_Subtotal');

  final reply = find.text('Reply');
  final shrine = find.text('Shrine');
  final nextButton = find.text('NEXT');
  final stellaSunglasses = find.text('Stella sunglasses');
  final menu = find.byTooltip('Open menu');
  final clothing = find.text('CLOTHING');
  final walter = find.text('Walter henley (white)');
  final accessories = find.text('ACCESSORIES');
  final shrugBag = find.text('Shrug bag');
  final seaTunic = find.text('Sea tunic');
  final clearCartButton = find.text('CLEAR CART');
  final noCartItems = find.text('NO ITEMS');

  Future<void> waitUntilElementIsVisible(WidgetTester tester,Finder theElement) async {
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (findsOneWidget.matches(theElement, <dynamic, dynamic>{})) {
        break;
      }
    }
  }
  
  group('end-to-end test', () {
    testWidgets('Test Gallery App',
        (WidgetTester tester) async {
      //open app then wait until app fully load
      app.main();
      await waitUntilElementIsVisible(tester, reply);
      
      // Swipe the carousel then tap on shrine card
      await tester.dragUntilVisible(shrine, reply, const Offset(-300, 0));
      await tester.pumpAndSettle();
      await tester.tap(shrine);

      // Verify the shrine login page opened
      await waitUntilElementIsVisible(tester, find.bySemanticsLabel('Username'));
      await tester.enterText(find.bySemanticsLabel('Username'), 'semutmerah');
      await tester.enterText(find.bySemanticsLabel('Password'), '12345678');
      await tester.tap(nextButton);
      await waitUntilElementIsVisible(tester, stellaSunglasses);

      //Add walter henley (white) shirt to cart
      await tester.tap(menu);
      await waitUntilElementIsVisible(tester, clothing);
      await tester.tap(clothing);
      await waitUntilElementIsVisible(tester, seaTunic);
      await tester.dragUntilVisible(walter, find.byKey(productPageViewKey), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(walter);

      //Add shrug bag
      await tester.tap(menu);
      await waitUntilElementIsVisible(tester, accessories);
      await tester.tap(accessories);
      await waitUntilElementIsVisible(tester, shrugBag);
      await tester.tap(shrugBag);

      //Checking total of shopping cart
      await tester.tap(find.byKey(openCart));
      await waitUntilElementIsVisible(tester, find.byKey(cartTotal));

      var totalObject = find.byKey(cartTotal).evaluate().single.widget as SelectableText;
      var shippingObject = find.byKey(shippingTotal).evaluate().single.widget as SelectableText;
      var taxObject = find.byKey(taxTotal).evaluate().single.widget as SelectableText;
      var subtotalObject = find.byKey(subTotal).evaluate().single.widget as SelectableText;
      
      var expectTotal = double.parse(subtotalObject.data.substring(1)) + double.parse(taxObject.data.substring(1)) + double.parse(shippingObject.data.substring(1));
      await expectLater(double.parse(totalObject.data.substring(1)), equals(double.parse(expectTotal.toStringAsFixed(2))));

      //Clear cart
      await tester.tap(clearCartButton);
      await waitUntilElementIsVisible(tester, find.byKey(openCart));
      await tester.tap(find.byKey(openCart));
      await waitUntilElementIsVisible(tester, noCartItems);
    });
  });
}