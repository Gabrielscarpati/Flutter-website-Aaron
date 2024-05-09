class AppConstants {
  AppConstants._();

  static AppConstants? _instance;

  static AppConstants get instance {
    _instance ??= AppConstants._();
    return _instance!;
  }

  final String sellers = 'edi_members';
  final String buyers = 'edi_customers';
}
