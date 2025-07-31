import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/break_time_min_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';


class MockBloomController extends Mock implements BloomController {}

void main() {
  late MockBloomController mockController;
  late BloomModel testModel;

  setUp(() {
    mockController = MockBloomController();
    testModel = BloomModel(breakTimeMin: Duration(minutes: 5));

    when(() => mockController.stream).thenAnswer((_) => Stream<BloomModel>.empty());
    when(() => mockController.state).thenReturn(testModel);
  });

  Future<Duration?> fakeShowDialog(BuildContext _, Duration __) async {
    return Duration(minutes: 10);
  }

  testWidgets('calls controller.setBreakTimeMin after selecting new duration', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<BloomController>.value(
          value: mockController,
          child: BreakTimeMinSetting(
            model: testModel,
            showDialogFn: fakeShowDialog,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(BreakTimeMinSetting));
    await tester.pumpAndSettle();

    verify(() => mockController.setBreakTimeMin(Duration(minutes: 10))).called(1);
  });
}
