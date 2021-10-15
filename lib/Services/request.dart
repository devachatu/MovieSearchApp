import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const noImg =
    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png";
const BASE_URL = 'https://imdb8.p.rapidapi.com/';

Map<String, dynamic> timeoutResponse() {
  return {
    "issuccess": false,
    "message": "Please check your network connection and try again."
  };
}

Map<String, dynamic> errorResponse() {
  return {
    "issuccess": false,
    "message": "Something went wrong, please try again."
  };
}

Future<Map<String, dynamic>> postRequest(String url,
    {Map<String, dynamic>? body, bool showMessage = true}) async {
  var options = BaseOptions(
      baseUrl: BASE_URL,
      responseType: ResponseType.json,
      connectTimeout: 1000000,
      headers: {
        'x-rapidapi-host': 'imdb8.p.rapidapi.com',
        'x-rapidapi-key': 'a3fdb000eamsh4c667a579fd2527p12b689jsnaed7c88cb9c0'
      },
      receiveTimeout: 1000000);
  Dio dio = Dio(options);
  var response;
  try {
    print(url);
    print(body);
    response = await dio.post(url, data: body);
    while (Get.isOverlaysOpen) Get.back();
    Map<String, dynamic> responseData = response.data;
    print(responseData);
    responseData["isSuccess"] = true;
    if (responseData['message'] != null && showMessage) {
      Get.defaultDialog(
        title: "Message",
        content: Center(child: Text(responseData['message'])),
      );
    }

    return responseData;
  } catch (e) {
    print(e);
    while (Get.isOverlaysOpen) Get.back();

    if (e is DioError) {
      try {
        print(e.toString());

        if ((e.response?.statusCode ?? 0) >= 400 &&
            (e.response?.statusCode ?? 0) < 500) {
          if (e.response?.data?.containsKey('error') ?? false) {
            Get.defaultDialog(
              title: "Error",
              middleText: e.response?.data['error'] ?? "",
            );
            // Get.showSnackbar(GetBar(
            //     duration: Duration(seconds: 5),
            //     title: "Error",
            //     message: e.response.data['error']));
          }
          if ((e.response?.statusCode ?? 0) >= 500 &&
              (e.response?.statusCode ?? 0) < 600) {
            if ((e.response?.statusMessage ?? "") != "") {
              Get.defaultDialog(
                title: "Error",
                middleText: e.response?.statusMessage ?? "",
              );
              // Get.showSnackbar(GetBar(
              //     duration: Duration(seconds: 5),
              //     title: "Error",
              //     message: e.response.data['error']));
            }
          }
          if (e.response?.data?.containsKey('errors') ?? false) {
            Get.defaultDialog(
              title: "Error",
              middleText: e.response?.data['errors'][0]['msg'] ?? "",
            );
            // Get.showSnackbar(GetBar(
            //     duration: Duration(seconds: 5),
            //     title: "Error",
            //     message: e.response.data['errors'][0]['msg']));
          }
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
  return {"isSuccess": false};
}

Future<Map<String, dynamic>> getRequest(String url,
    {bool showMessage = true,
    Map<String, dynamic>? query,
    bool close = true}) async {
  var options = BaseOptions(
      baseUrl: BASE_URL,
      responseType: ResponseType.json,
      connectTimeout: 1000000,
      queryParameters: query,
      headers: {
        'x-rapidapi-host': 'imdb8.p.rapidapi.com',
        'x-rapidapi-key': 'a3fdb000eamsh4c667a579fd2527p12b689jsnaed7c88cb9c0'
      },
      receiveTimeout: 300000);
  // print (options);

  Dio dio = Dio(options);
  var response;
  try {
    print(url);
    if (query != null) {
      print(query);
      response = await dio.get(url, queryParameters: query);
    } else
      response = await dio.get(url);
    Map<String, dynamic> responseData = response.data;
    responseData["isSuccess"] = true;
    if (close) while (Get.isOverlaysOpen) Get.back();
    if (responseData['message'] != null && showMessage)
      Get.defaultDialog(
        title: "Message",
        content: Center(child: Text(responseData['message'])),
      );
    debugPrint(responseData.toString());
    print(responseData.length);
    return responseData;
  } on DioError catch (e) {
    while (Get.isOverlaysOpen) Get.back();
    if ((e.response ?? "") != "") if ((e.response?.statusCode ?? 0) >= 400 &&
        (e.response?.statusCode ?? 0) < 600) {
      if ((e.response?.data?.containsKey('error') ?? false) & showMessage) {
        Get.showSnackbar(GetBar(
            title: "Error",
            message: e.response?.data['error'].toString() ?? ""));
      }
    }
  } catch (e) {
    Get.showSnackbar(GetBar(title: "Error", message: e.toString()));
  }
  return {"isSuccess": false};
}
