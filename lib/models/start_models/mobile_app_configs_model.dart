import 'start_model_importer.dart';

class MobileAppConfigs {
  MobileAppConfigs({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  MobileAppConfigsOriginal original;
  dynamic exception;

  factory MobileAppConfigs.fromJson(Map<String, dynamic> json) =>
      MobileAppConfigs(
        headers: Headers.fromJson(json["headers"]),
        original: MobileAppConfigsOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class MobileAppConfigsOriginal {
  MobileAppConfigsOriginal({
    this.success,
    this.data,
  });

  bool success;
  List<StickyDatum> data;

  factory MobileAppConfigsOriginal.fromJson(Map<String, dynamic> json) =>
      MobileAppConfigsOriginal(
        success: json["success"],
        data: List<StickyDatum>.from(
            json["data"].map((x) => StickyDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class StickyDatum {
  StickyDatum({
    this.id,
    this.iosCurrentVersion,
    this.iosLastSupportedVersion,
    this.androidCurrentVersion,
    this.androidLastSupportedVersion,
    this.googlePlayUrl,
    this.appStoreUrl,
    this.iosIsActive,
    this.androidIsActive,
    this.maintenanceMessages,
  });

  int id;
  String iosCurrentVersion;
  String iosLastSupportedVersion;
  String androidCurrentVersion;
  String androidLastSupportedVersion;
  String googlePlayUrl;
  String appStoreUrl;
  String iosIsActive;
  String androidIsActive;
  String maintenanceMessages;

  factory StickyDatum.fromJson(Map<String, dynamic> json) => StickyDatum(
        id: json["id"],
        iosCurrentVersion: json["ios_current_version"].toString(),
        iosLastSupportedVersion: json["ios_last_supported_version"].toString(),
        androidCurrentVersion: json["android_current_version"].toString(),
        androidLastSupportedVersion:
            json["android_last_supported_version"].toString(),
        googlePlayUrl: json["google_play_url"].toString(),
        appStoreUrl: json["app_store_url"].toString(),
        iosIsActive: json["ios_is_active"].toString(),
        maintenanceMessages: json["maintenance_messages"].toString(),
        androidIsActive: json["android_is_active"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ios_current_version": iosCurrentVersion,
        "ios_last_supported_version": iosLastSupportedVersion,
        "android_current_version": androidCurrentVersion,
        "android_last_supported_version": androidLastSupportedVersion,
        "google_play_url": googlePlayUrl,
        "app_store_url": appStoreUrl,
        "ios_is_active": iosIsActive,
        "maintenance_messages": maintenanceMessages,
        "android_is_active": androidIsActive,
      };
}
