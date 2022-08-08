class Company {
  Company({
    this.id,
    this.name,
    this.logoFileName,
    this.phone,
    this.email,
    this.addressId,
    this.whatsappNumber,
    this.supportNumber,
    this.facebookUrl,
    this.instagramUrl,
    this.messengerUrl,
    this.supportUrl,
    this.websiteUrl,
    this.baseUrl,
    this.imageBaseUrl,
    this.currency,
    this.additionalInfo,
    this.useWallet,
    this.chatActive,
    this.chatUrl,
  });

  int id;
  String name;
  String logoFileName;
  String phone;
  String email;
  dynamic addressId;
  String whatsappNumber;
  String supportNumber;
  String facebookUrl;
  String instagramUrl;
  String messengerUrl;
  String supportUrl;
  String websiteUrl;
  String baseUrl;
  String imageBaseUrl;
  String currency;
  dynamic additionalInfo;
  String chatActive;
  int useWallet;
  String chatUrl;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json['id'],
        name: json['name'],
        logoFileName: json['logo_file_name'],
        phone: json['phone'],
        email: json['email'],
        addressId: json['address_id'],
        whatsappNumber: json['whatsapp_number'],
        supportNumber: json['support_number'],
        facebookUrl: json['facebook_url'],
        instagramUrl: json['instagram_url'],
        messengerUrl: json['messenger_url'],
        supportUrl: json['support_url'],
        websiteUrl: json['website_url'],
        baseUrl: json['base_url'],
        imageBaseUrl: json['image_base_url'],
        currency: json['currency'],
        additionalInfo: json['additional_info'],
        useWallet: json['use_wallet'],
        chatActive: json['chat_active'].toString(),
        chatUrl: json['chat_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logo_file_name': logoFileName,
        'phone': phone,
        'email': email,
        'address_id': addressId,
        'whatsapp_number': whatsappNumber,
        'support_number': supportNumber,
        'facebook_url': facebookUrl,
        'instagram_url': instagramUrl,
        'messenger_url': messengerUrl,
        'support_url': supportUrl,
        'website_url': websiteUrl,
        'base_url': baseUrl,
        'image_base_url': imageBaseUrl,
        'currency': currency,
        'additional_info': additionalInfo,
      };
}
