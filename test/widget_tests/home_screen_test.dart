import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/home/widgets/screen_time_card.dart'; // Pfad anpassen
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloom_flutter/constants.dart';

void main() {
  group('ScreenTimeCard Widget Tests', () {
    late BloomModel model;

    setUp(() {
      // Beispielmodell initialisieren mit Defaultwerten
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
    });

    testWidgets('zeigt korrekte Titel und Chips an', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenTimeCard(model: model),
          ),
        ),
      );

      // Prüfen, ob der gute Status Text erscheint
      expect(find.text('Deiner Blume geht es gut!'), findsOneWidget);

      // Prüfen ob Chips mit Streak und Wassertropfen erscheinen
      expect(find.text('3 Tage'), findsOneWidget);
      expect(find.text('2 Wassertropfen'), findsOneWidget);

      // Prüfen ob Sitzungszeit-Titel da ist
      expect(find.text('Sitzungszeit'), findsOneWidget);

      // Prüfen ob Bildschirmzeit-Titel da ist
      expect(find.text('Bildschirmzeit'), findsOneWidget);
    });

    testWidgets('zeigt vertrocknet Meldung wenn Zeiten überschritten', (WidgetTester tester) async {
      // Modell mit überschrittenen Zeiten
      model = model.copyWith(
        sessionTimeToleranceFraction: 1.0,
        screenTimeFraction: 1.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenTimeCard(model: model),
          ),
        ),
      );

      expect(find.text('Deine Blume ist vertrocknet!'), findsOneWidget);
      expect(find.textContaining('Lege dein Smartphone für heute weg'), findsOneWidget);
    });

    testWidgets('zeigt Wasser benötigt Meldung bei passenden Zeiten', (WidgetTester tester) async {
      model = model.copyWith(
        sessionTimeFraction: 1.0,
        sessionTimeToleranceFraction: 0.5,
        screenTimeFraction: 0.5,
        breakTime: Duration(minutes: 7),
        sessionTimeRemaining: Duration(minutes: 15),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenTimeCard(model: model),
          ),
        ),
      );

      expect(find.text('Deine Blume braucht Wasser!'), findsOneWidget);
      expect(find.textContaining('Lege dein Smartphone für mindestens'), findsOneWidget);
    });
  });
}
