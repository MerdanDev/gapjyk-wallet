import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/core/key_data.dart';

class SingletonSharedPreference {
  factory SingletonSharedPreference() {
    return instance;
  }
  SingletonSharedPreference._internal(this._pref);

  static void init(SharedPreferences pref) {
    instance = SingletonSharedPreference._internal(pref);
  }

  static late SingletonSharedPreference instance;

  final SharedPreferences _pref;

  static String? loadLangCode() {
    return instance._pref.getString(KeyData.languageCode);
  }

  static Future<bool> setLangCode(String code) {
    return instance._pref.setString(KeyData.languageCode, code);
  }

  static String? loadIncomeExpenseList() {
    return instance._pref.getString(KeyData.incomeExpenseList);
  }

  static Future<bool> setIncomeExpenseList(String data) {
    return instance._pref.setString(KeyData.incomeExpenseList, data);
  }

  static String? loadCounterCategory() {
    return instance._pref.getString(KeyData.counterCategoryList);
  }

  static Future<bool> setCounterCategory(String data) {
    return instance._pref.setString(KeyData.counterCategoryList, data);
  }

  static String? loadCategoryBudgetList() {
    return instance._pref.getString(KeyData.categoryBudgetList);
  }

  static Future<bool> setCategoryBudgetList(String data) {
    return instance._pref.setString(KeyData.categoryBudgetList, data);
  }

  static String? loadNotificationList() {
    return instance._pref.getString(KeyData.notificationList);
  }

  static Future<bool> setNotificationList(String data) {
    return instance._pref.setString(KeyData.notificationList, data);
  }

  static String? loadDateFilter() {
    return instance._pref.getString(KeyData.dateFilterState);
  }

  static Future<bool> setDateFilter(String data) {
    return instance._pref.setString(KeyData.dateFilterState, data);
  }

  static bool loadDefaultCategoriesSeeded() {
    return instance._pref.getBool(KeyData.defaultCategoriesSeeded) ?? false;
  }

  static Future<bool> setDefaultCategoriesSeeded({required bool value}) {
    return instance._pref.setBool(KeyData.defaultCategoriesSeeded, value);
  }

  static String? loadCurrencySymbol() {
    return instance._pref.getString(KeyData.currencySymbol);
  }

  static Future<bool> setCurrencySymbol(String symbol) {
    return instance._pref.setString(KeyData.currencySymbol, symbol);
  }

  static bool loadOnboardingCompleted() {
    return instance._pref.getBool(KeyData.onboardingCompleted) ?? false;
  }

  static Future<bool> setOnboardingCompleted({required bool value}) {
    return instance._pref.setBool(KeyData.onboardingCompleted, value);
  }

  static bool loadAutoBackupEnabled() {
    return instance._pref.getBool(KeyData.autoBackupEnabled) ?? false;
  }

  static Future<bool> setAutoBackupEnabled({required bool value}) {
    return instance._pref.setBool(KeyData.autoBackupEnabled, value);
  }

  static DateTime? loadLastAutoBackupAt() {
    final raw = instance._pref.getString(KeyData.lastAutoBackupAt);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  static Future<bool> setLastAutoBackupAt(DateTime value) {
    return instance._pref
        .setString(KeyData.lastAutoBackupAt, value.toIso8601String());
  }

  static String? loadIncomeExpenseBackup() {
    return instance._pref.getString(KeyData.incomeExpenseBackup);
  }

  static Future<bool> setIncomeExpenseBackup(String data) {
    return instance._pref.setString(KeyData.incomeExpenseBackup, data);
  }

  static Future<bool> clearIncomeExpenseBackup() {
    return instance._pref.remove(KeyData.incomeExpenseBackup);
  }

  static bool loadTitleCategoryMigrationDone() {
    return instance._pref.getBool(KeyData.titleCategoryMigrationDone) ?? false;
  }

  static Future<bool> setTitleCategoryMigrationDone({required bool value}) {
    return instance._pref.setBool(KeyData.titleCategoryMigrationDone, value);
  }
}
