import 'headers_model.dart';

class Company {
  Company({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  CompanyOriginal original;
  dynamic exception;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        headers: Headers.fromJson(json["headers"]),
        original: CompanyOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class CompanyOriginal {
  CompanyOriginal({
    this.success,
    this.data,
  });

  bool success;
  List<CompanyOriginalData> data;

  factory CompanyOriginal.fromJson(Map<String, dynamic> json) =>
      CompanyOriginal(
        success: json["success"],
        data: List<CompanyOriginalData>.from(
            json["data"].map((x) => CompanyOriginalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CompanyOriginalData {
  CompanyOriginalData({
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
  String additionalInfo;

  factory CompanyOriginalData.fromJson(Map<String, dynamic> json) =>
      CompanyOriginalData(
        id: json["id"],
        name: json["name"],
        logoFileName: json["logo_file_name"],
        phone: json["phone"].toString(),
        email: json["email"],
        addressId: json["address_id"].toString(),
        whatsappNumber: json["whatsapp_number"].toString(),
        supportNumber: json["support_number"].toString(),
        facebookUrl: json["facebook_url"].toString(),
        instagramUrl: json["instagram_url"].toString(),
        messengerUrl: json["messenger_url"].toString(),
        supportUrl: json["support_url"].toString(),
        websiteUrl: json["website_url"].toString(),
        baseUrl: json["base_url"].toString(),
        imageBaseUrl: json["image_base_url"].toString(),
        currency: json["currency"].toString(),
        additionalInfo: json["additional_info"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo_file_name": logoFileName,
        "phone": phone,
        "email": email,
        "address_id": addressId,
        "whatsapp_number": whatsappNumber,
        "support_number": supportNumber,
        "facebook_url": facebookUrl,
        "instagram_url": instagramUrl,
        "messenger_url": messengerUrl,
        "support_url": supportUrl,
        "website_url": websiteUrl,
        "base_url": baseUrl,
        "image_base_url": imageBaseUrl,
        "currency": currency,
        "additional_info": additionalInfo,
      };
}
