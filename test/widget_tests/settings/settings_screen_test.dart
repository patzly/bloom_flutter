import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/settings_screen.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/brightness_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/contrast_setting.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloom_flutter/constants.dart';

// ----- MOCKS -----
class MockBloomController extends Mock implements BloomController {}

class FakeBloomModel extends Fake implements BloomModel {}

void main() {
  late BloomController mockController;
  late BloomModel model;

  setUpAll(() {
    registerFallbackValue(FakeBloomModel());
  });

  setUp(() {
    mockController = MockBloomController();

    model = BloomModel(
      sessionTime: Duration(minutes: 20),
      sessionTimeMax: Duration(minutes: 60),
      sessionTimeFraction: 20 / 60,
      sessionTimeTolerance: Duration.zero,
      sessionTimeToleranceFraction: 0,
      screenTime: Duration(minutes: 30),
      screenTimeMax: Duration(minutes: 120),
      screenTimeFraction: 30 / 120,
      breakTime: Duration(minutes: 5),
      sessionTimeRemaining: Duration(minutes: 10),
      streak: 3,
      waterDrops: 2,
      contrastLevel: ContrastLevel.standard,
    );

    when(() => mockController.state).thenReturn(model);
    when(() => mockController.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('SettingsScreen zeigt Titel und einige Settings', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('de')],
        path: 'assets/translations', // sicherstellen, dass vorhanden
        fallbackLocale: const Locale('de'),
        child: MaterialApp(
          home: BlocProvider.value(
            value: mockController,
            child: const SettingsScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Prüfen, ob AppBar-Titel vorhanden ist
    expect(find.text('Einstellungen'), findsOneWidget); // oder 'settings.title'.tr()

    // Prüfen, ob einige Settings-Widgets vorhanden sind
    expect(find.byType(BrightnessSetting), findsOneWidget);
    expect(find.byType(ContrastSetting), findsOneWidget);

    // Prüfen, ob Zurück-Icon vorhanden ist
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
