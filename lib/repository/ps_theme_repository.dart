import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_theme_data.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/db/common/ps_shared_preferences.dart';
import 'package:flutterbuyandsell/repository/Common/ps_repository.dart';

class PsThemeRepository extends PsRepository {
  PsThemeRepository({required PsSharedPreferences? psSharedPreferences}) {
    _psSharedPreferences = psSharedPreferences;
  }

  PsSharedPreferences? _psSharedPreferences;

  Future<void> updateTheme(bool isDarkTheme) async {
    await _psSharedPreferences!.shared
        .setBool(PsConst.THEME__IS_DARK_THEME, isDarkTheme);
  }

  ThemeData getTheme() {
    final bool isDarkTheme =
        _psSharedPreferences!.shared.getBool(PsConst.THEME__IS_DARK_THEME) ??
            false;

    if (isDarkTheme) {
      return themeData(ThemeData.dark());
    } else {
      return themeData(ThemeData.light());
    }
  }
}
