/// Application settings service.
///
/// Keeps user preferences separated from business data.
class FrooshyarSettingsService {
  Future<void> setStoreName(String name) async {}

  Future<String?> getStoreName() async {
    return null;
  }

  Future<void> setCurrency(String currency) async {}

  Future<String> getCurrency() async {
    return 'تومان';
  }
}
