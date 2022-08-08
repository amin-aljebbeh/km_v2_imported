class MobileAppConfigs {
  MobileAppConfigs({
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
  int iosIsActive;
  int androidIsActive;
  String maintenanceMessages;

  factory MobileAppConfigs.fromJson(Map<String, dynamic> json) => MobileAppConfigs(
        id: json["id"],
        iosCurrentVersion: json["ios_current_version"],
        iosLastSupportedVersion: json["ios_last_supported_version"],
        androidCurrentVersion: json["android_current_version"],
        androidLastSupportedVersion: json["android_last_supported_version"],
        googlePlayUrl: json["google_play_url"],
        appStoreUrl: json["app_store_url"],
        iosIsActive: json["ios_is_active"],
        androidIsActive: json["android_is_active"],
        maintenanceMessages: json["maintenance_messages"],
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
        "android_is_active": androidIsActive,
        "maintenance_messages": maintenanceMessages,
      };
}
