import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/screen_time_max_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloomController extends Mock implements BloomController {}

void main() {
  late MockBloomController mockController;
  late BloomModel testModel;

  setUp(() {
    mockController = MockBloomController();
    testModel = BloomModel(screenTimeMax: Duration(minutes: 5));

    when(
      () => mockController.stream,
    ).thenAnswer((_) => Stream<BloomModel>.empty());
    when(() => mockController.state).thenReturn(testModel);
  });

  Future<Duration?> fakeShowDialog(BuildContext _, Duration __) async {
    return Duration(minutes: 10);
  }

  testWidgets(
    'calls controller.setScreenTimeMax after selecting new duration',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BloomController>.value(
            value: mockController,
            child: ScreenTimeMaxSetting(
              model: testModel,
              showDialogFn: fakeShowDialog,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ScreenTimeMaxSetting));
      await tester.pumpAndSettle();

      verify(
        () => mockController.setScreenTimeMax(Duration(minutes: 10)),
      ).called(1);
    },
  );
}
