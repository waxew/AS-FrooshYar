import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:possystem/helpers/logger.dart';
import 'package:possystem/settings/setting.dart';

class CollectEventsSetting extends Setting<bool> {
  static final CollectEventsSetting instance = ._();

  /// Privacy-first default for AS-FrooshYar. Telemetry is only enabled after
  /// the user explicitly turns it on from settings.
  static const defaultValue = false;

  CollectEventsSetting._() {
    value = defaultValue;
  }

  @override
  String get key => 'feat.collectEvents';

  @override
  void initialize() {
    value = service.get<bool>(key) ?? defaultValue;
    Log.allowSendEvents = value;
  }

  @override
  Future<void> updateRemotely(bool data) async {
    Log.allowSendEvents = data;

    await service.set<bool>(key, data);
    await Future.wait([
      FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(data),
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(data),
    ]);
  }
}
