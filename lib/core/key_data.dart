class KeyData {
  static const String languageCode = 'languageCode';
  static const String counterCode = 'counterCode';
  static const String categoryCode = 'categoryCode';
  static const String defaultDateFilter = 'defaultDateFilter';
  static const String incomeExpenseList = 'incomeExpenseList';
  static const String counterCategoryList = 'counterCategoryList';
  static const String categoryBudgetList = 'categoryBudgetList';
  static const String notificationList = 'notificationList';
  static const String dateFilterState = 'dateFilterState';
  static const String defaultCategoriesSeeded = 'defaultCategoriesSeeded';
  static const String currencySymbol = 'currencySymbol';
  static const String onboardingCompleted = 'onboardingCompleted';

  /// One-time snapshot of the raw income/expense JSON taken before the
  /// title→category migration first rewrites the store, as a recovery net.
  static const String incomeExpenseBackup = 'incomeExpenseBackup';

  /// Set once the title→category migration has run and persisted a clean store.
  static const String titleCategoryMigrationDone = 'titleCategoryMigrationDone';

  /// Whether automatic backups (on app open/close) are enabled.
  static const String autoBackupEnabled = 'autoBackupEnabled';

  /// ISO-8601 timestamp of the last successful automatic backup, for display.
  static const String lastAutoBackupAt = 'lastAutoBackupAt';
}
