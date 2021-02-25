import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:http/http.dart' as http;
import 'package:kammun_app/views/loading/Loading.dart';

class ProductsServices {
  static Future<bool> updateProductsDetails(
      {String bodyKey, String value, String productId}) async {
    var body = {bodyKey: value};

    var response = await ApiProvider.sendRequest(
        url: GET_PRODUCT + productId,
        method: httpMethods.put,
        body: jsonEncode(body));

    if (response.statusCode == SUCCESS_CODE &&
        response.data["success"] == true) {
      Tools.logToConsole(response.data);
      return true;
    } else {
      return false;
    }
  }

  static Future<int> addNewProducts(
      {String name,
      String quantity,
      String unit,
      String description,
      String categoryId,
      String price,
      String isActive,
      String supplierCode,
      String minThreshold,
      String priceFactor}) async {
    var body = {
      "name": name,
      "unit": unit,
      "is_in_facebook": 0,
      "description": description,
      "category_id": categoryId,
      "price": price,
      "quantity": quantity,
      "is_featured": 0,
      "is_active": isActive,
      "priority": 20,
      "supplier_code": supplierCode,
      "min_threshold": minThreshold,
      "increase_percentage": 0,
      "price_factor": priceFactor,
    };

    var response = await ApiProvider.sendRequest(
        url: GET_PRODUCT, method: httpMethods.post, body: jsonEncode(body));

    if (response.statusCode == SUCCESS_CODE &&
        response.data["success"] == true) {
      Tools.logToConsole("Product Added");
      Tools.logToConsole(response.data);
      return int.parse(response.data["data"]["id"].toString());
    } else {
      return 0;
    }
  }

  static Future<bool> setImageToProducts({File image, int productId}) async {
    // var body = {
    //   "product_id": productId,
    //   "image": image,
    // };
    try {
      // FormData formData = FormData.fromMap({
      //   "product_id": productId,
      //   "image": await MultipartFile.fromFile("${image.path.toString()}",
      //       filename: "upload.jpg")
      // });
      // var response = await ApiProvider.sendRequest(
      //     url: ADD_IMAGE_TO_PRODUCTS,
      //     method: httpMethods.post,
      //     body: jsonEncode(jsonEncode(formData)));

      bool result = await _upload(image, productId);

      if (result) {
        // Tools.logToConsole("Image Uploaded");
        // Tools.logToConsole(response.data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Tools.logToConsole("Catched Error");

      Tools.logToConsole(e.toString());
      return false;
    }
  }

  // static Future<bool> _upload(File file, int productId) async {
  //   String fileName = file.path.split('/').last;

  //   FormData formData = FormData.fromMap({
  //     "image": await MultipartFile.fromFile(
  //       file.path,
  //       filename: fileName,
  //     ),
  //     "product_id": productId,
  //   });

  //   Tools.logToConsole(BaseUrl + ADD_IMAGE_TO_PRODUCTS);

  //   Dio dio = new Dio();
  //   Tools.logToConsole(formData.fields);

  //   var res = await dio
  //       .post(BaseUrl + ADD_IMAGE_TO_PRODUCTS,
  //           data: {"image": file.path, "product_id": productId},
  //           options: Options(
  //             headers: {
  //               "Accept": "application/json",
  //               'Authorization': "Bearer aboHashim",
  //               "Content-Type": "multipart/form-data"
  //             },
  //             // followRedirects: false,
  //           ))
  //       .then((response) {
  //     print(response);
  //     return true;
  //   }).catchError((error) {
  //     print(error);
  //     return false;
  //   });
  //   return false;
  // }

  // static Future<bool> _upload(File file, int productId) async {
  //   Tools.logToConsole("I'm in upload image");
  //   Tools.logToConsole(file.path);
  //   var postUri = Uri.parse(BaseUrl + ADD_IMAGE_TO_PRODUCTS);
  //   var request = new http.MultipartRequest("POST", postUri);
  //   request.headers.addAll({
  //     "Accept": "application/json",
  //     'Authorization': "Bearer aboHashim",
  //     "Content-Type": "multipart/form-data"
  //   });
  //   request.fields['product_id'] = '$productId';
  //   request.files.add(new http.MultipartFile.fromBytes(
  //       'image', await File.fromUri(file.uri).readAsBytes(),
  //       contentType: MediaType('image', 'jpeg')));
  //   request.send().then((response) {
  //     if (response.statusCode == 200) {
  //       print("Uploaded!");
  //     } else {
  //       print(response.statusCode);
  //       print(response.request.url);
  //     }
  //   });
  //   return true;
  // }

  // static Future<bool> _upload(File file, int productId) async {
  //   List<FileItem> fileItems = List<FileItem>();
  //   fileItems.add(FileItem(
  //     filename: file.path.split('/').last,
  //     savedDir: file.path,
  //     fieldname: "image",
  //   ));
  //   FlutterUploader uploader = FlutterUploader();
  //   var taskId = await uploader.enqueue(
  //     url: BaseUrl + ADD_IMAGE_TO_PRODUCTS,
  //     data: {"product_id": "$productId"},
  //     files: fileItems,
  //     method: UploadMethod.POST,
  //     // tag: tag,
  //     headers: {'pageCode': 'videoPage', 'Authorization': "Bearer aboHashim"},
  //     showNotification: false,
  //   );
  //   // String taskId2 =
  //   //     await CCFileUploader(uploader: uploader, url: '$BaseUrl$PUBLIC_UPLOAD')
  //   //         .uploadFiles(files: [
  //   //   {'name': 'file', 'file': reimbursementImages[index]}
  //   // ], extraBody: {
  //   //   "tag": "",
  //   // });
  //   print("taskId is : $taskId");
  //   return true;
  // }

  // static Future<bool> _upload(File file, int productId) async {
  //   try {
  //     final response = await http.post(
  //       BaseUrl + ADD_IMAGE_TO_PRODUCTS,
  //       headers: {'Authorization': "Bearer aboHashim"},
  //       body: {
  //         'product_id': productId.toString(),
  //         'image':
  //             'data:image/png;base64,' + base64Encode(file.readAsBytesSync())
  //       },
  //     );

  //     // final responseJson = json.decode(response.body);

  //     print(response.statusCode);
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return false;
  // }

  static Future<bool> _upload(File file, int productId) async {
    var headers = {'Authorization': 'Bearer aboHashim'};
    var request = http.MultipartRequest(
        'POST', Uri.parse(BaseUrl + ADD_IMAGE_TO_PRODUCTS));
    request.fields.addAll({'product_id': '$productId'});
    request.files
        .add(await http.MultipartFile.fromPath('image', '${file.path}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }
}
