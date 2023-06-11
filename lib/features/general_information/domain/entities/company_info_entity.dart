class CompanyInfoEntity {
  CompanyInfoEntity({
    this.email,
    this.whatsappNumber,
    this.supportNumber,
    this.facebookUrl,
    this.instagramUrl,
    this.messengerUrl,
    this.supportUrl,
    this.websiteUrl,
    this.currency,
    this.androidShareUrl,
    this.iOSShareUrl,
    this.additionalInfo,
    this.imagePrefixUrl,
    this.updateRequired = false,
  });

  String email;
  String whatsappNumber;
  String supportNumber;
  String facebookUrl;
  String instagramUrl;
  String messengerUrl;
  String supportUrl;
  String websiteUrl;
  String currency;
  String additionalInfo;
  String androidShareUrl;
  String iOSShareUrl;
  String imagePrefixUrl;
  bool updateRequired;

  CompanyInfoEntity copyWith({
    String email,
    String whatsappNumber,
    String supportNumber,
    String facebookUrl,
    String instagramUrl,
    String messengerUrl,
    String supportUrl,
    String websiteUrl,
    String currency,
    String additionalInfo,
    String androidShareUrl,
    String iOSShareUrl,
    String imagePrefixUrl,
    bool updateRequired,
  }) {
    return CompanyInfoEntity(
      email: email ?? this.email,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      supportNumber: supportNumber ?? this.supportNumber,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      messengerUrl: messengerUrl ?? this.messengerUrl,
      supportUrl: supportUrl ?? this.supportUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      currency: currency ?? this.currency,
      updateRequired: updateRequired ?? this.updateRequired,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      androidShareUrl: androidShareUrl ?? this.androidShareUrl,
      iOSShareUrl: iOSShareUrl ?? this.iOSShareUrl,
      imagePrefixUrl: imagePrefixUrl ?? this.imagePrefixUrl,
    );
  }
}
