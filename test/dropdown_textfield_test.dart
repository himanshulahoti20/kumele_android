import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/shared/widgets/dropdown_textfield/dropdown_textfield.dart';

void main() {
  testWidgets('tapping outside without an open overlay does not throw',
      (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              DropDownTextField(
                dropDownList: const [],
                textFieldFocusNode: focusNode,
              ),
              const TextButton(onPressed: null, child: Text('Outside')),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.tap(find.text('Outside'));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
