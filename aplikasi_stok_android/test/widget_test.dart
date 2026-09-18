import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_stok_android/main.dart';

void main() {
  testWidgets('Cek tampilan awal halaman login', (WidgetTester tester) async {
    // Mock SharedPreferences dengan kondisi belum login
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const AplikasiStokApp());
    await tester.pumpAndSettle();

    expect(find.text('Stok Hebat'), findsOneWidget);
    expect(find.text('LOGIN MASUK'), findsOneWidget);
  });
}
