import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'assets_picker/multi_assets_page.dart';
// import 'insta_asset_picker.dart';

void main() {
  runApp(const MainApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
  );
}

const Color themeColor = Color(0xff00bc56);

extension ColorExtension on Color {
  MaterialColor get swatch => Colors.primaries.firstWhere(
        (Color c) => c.value == value,
        orElse: () => _swatch,
      );

  Map<int, Color> get getMaterialColorValues => <int, Color>{
        50: _swatchShade(50),
        100: _swatchShade(100),
        200: _swatchShade(200),
        300: _swatchShade(300),
        400: _swatchShade(400),
        500: _swatchShade(500),
        600: _swatchShade(600),
        700: _swatchShade(700),
        800: _swatchShade(800),
        900: _swatchShade(900),
      };

  MaterialColor get _swatch => MaterialColor(value, getMaterialColorValues);

  Color _swatchShade(int swatchValue) => HSLColor.fromColor(this)
      .withLightness(1 - (swatchValue / 1000))
      .toColor();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      primarySwatch: themeColor.swatch,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: themeColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      // home: const InstaAssetPicker(),
      home: MultiAssetsPage(
        maxAssetsCount: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              minimumSize: const Size(500, 0),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.all(10),
              side: const BorderSide(color: Colors.grey, width: 2),
              surfaceTintColor: Colors.grey,
            ),
            label: const Text(
              "Upload thumbnail",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            icon: const Icon(
              Icons.add_photo_alternate,
              size: 24.0,
              color: Color(0xff0040e8),
            ),
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
