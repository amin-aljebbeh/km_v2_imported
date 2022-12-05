import 'start_model_importer.dart';

class Company {
  Company({this.headers, this.original, this.exception});

  KHeaders headers;
  CompanyOriginal original;
  dynamic exception;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
      headers: KHeaders.fromJson(json['headers']),
      original: CompanyOriginal.fromJson(json['original']),
      exception: json['exception']);

  Map<String, dynamic> toJson() => {'headers': headers.toJson(), 'original': original.toJson(), 'exception': exception};
}

class CompanyOriginal {
  CompanyOriginal({this.success, this.data});

  bool success;
  List<CompanyOriginalData> data;

  factory CompanyOriginal.fromJson(Map<String, dynamic> json) => CompanyOriginal(
        success: json['success'],
        data: List<CompanyOriginalData>.from(json['data'].map((x) => CompanyOriginalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CompanyOriginalData {
  CompanyOriginalData({
    this.email,
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
  });

  String email;
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
  String additionalInfo;

  factory CompanyOriginalData.fromJson(Map<String, dynamic> json) => CompanyOriginalData(
        email: json['email'],
        whatsappNumber: json['whatsapp_number'].toString(),
        supportNumber: json['support_number'].toString(),
        facebookUrl: json['facebook_url'].toString(),
        instagramUrl: json['instagram_url'].toString(),
        messengerUrl: json['messenger_url'].toString(),
        supportUrl: json['support_url'].toString(),
        websiteUrl: json['website_url'].toString(),
        baseUrl: json['base_url'].toString(),
        imageBaseUrl: json['image_base_url'].toString(),
        currency: json['currency'].toString(),
        additionalInfo: json['additional_info'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
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
