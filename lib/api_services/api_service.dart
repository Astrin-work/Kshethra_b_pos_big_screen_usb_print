
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kshethra_mini/model/api%20models/get_temple_model.dart';
import '../model/api models/E_Hundi_Get_Devatha_Model.dart';
import '../model/api models/get_donation_model.dart';
import '../model/api models/get_single_temple_model.dart';
import '../model/api models/god_model.dart';
import '../utils/hive/hive.dart';


class ApiService {
  late final Dio _dio;



  ApiService() {
    _dio = Dio(
      BaseOptions(
          baseUrl: 'https://online.astrins.com/api',
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
    //   client.badCertificateCallback = (cert, host, port) => true;
    //   return client;
    // };
  }

  Future<String> login(String username, String password) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String deviceId = '';

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id ?? '';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      }

      if (deviceId.isEmpty) {
        throw Exception("Device ID is empty. Cannot proceed with login.");
      }

      print('Using DeviceId: $deviceId');

      final response = await _dio.post(
        '/Login',
        data: {
          'userUserName': username,
          'userPassword': password,
          'deviceId': deviceId,
        },
      );

      print('Response data: ${response.data}');
      final token = response.data['accessToken'];
      print('Token: $token');

      await AppHive().putToken(token: token);
      return token;
    } on DioException catch (e) {
      print('Error response: ${e.response}');
      print('Error data: ${e.response?.data}');
      print('Error message: ${e.message}');
      throw ('${e.response?.data ?? e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }

  Future<List<Godmodel>> getDevatha() async {
    final token = await AppHive().getToken();
    final lag = await appHive.getLanguage();

    final response = await _dio.get(
      '/Devatha/DevathaVazhipadu?lang=$lag',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final List<dynamic> dataList = response.data;

    List<Godmodel> godList = [];
    for (var item in dataList) {
      godList.add(Godmodel.fromJson(item));
    }
    print('--------api respons-------');
    print(response.data);
    return godList;
  }

  Future<dynamic> postVazhipaduDetails(Map<String, dynamic> data) async {
    final token = await AppHive().getToken();

    try {
      final response = await _dio.post(
        '/vazhipadu/vazhipadureceipt?lang=en',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print(response.headers);
      print('-------response data------');
      print(response.data);
      print(response.statusCode);
      print(response.statusMessage);
      return response.data;
    } catch (e) {
      print('API call error: $e');
      rethrow;
    }
  }

  Future<List<Getdonationmodel>> getDonation() async {
    final token = await AppHive().getToken();
    final lag = await appHive.getLanguage();

    final response = await _dio.get(
      '/Donation?lang=$lag',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => Getdonationmodel.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }


  Future<Map<String, dynamic>> postDonationDetails(Map<String, dynamic> donationData) async {
    final token = await AppHive().getToken();

    try {
      final response = await _dio.post(
        '/Donation/generalreceipt',
        data: donationData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(" Donation posted successfully.");
        print(" Response Data: ${response.data}");
        return response.data as Map<String, dynamic>;
      } else if (response.statusCode == 409) {
        throw Exception("⚠️ Donation already exists.");
      } else {
        throw Exception("❌ Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error posting donation: $e");
      rethrow;
    }
  }



  Future<List<Ehundigetdevathamodel>> getEbannaramDevetha() async {
    final token = await AppHive().getToken();
    final lag = await appHive.getLanguage();
    final response = await _dio.get(
      '/Devatha?lang=$lag',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final List<dynamic> dataList = response.data;

    List<Ehundigetdevathamodel> godListEhundi = [];
    for (var item in dataList) {
      godListEhundi.add(Ehundigetdevathamodel.fromJson(item));
    }
    return godListEhundi;
  }


  Future<Map<String, dynamic>?> postEHundiDetails(Map<String, dynamic> eHundiData) async {
    final token = await AppHive().getToken();

    try {
      final response = await _dio.post(
        '/HundiCash',
        data: eHundiData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print("📤 Request Data: $eHundiData");
      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ E-Hundi posted successfully.");
        return response.data;
      } else if (response.statusCode == 409) {
        throw Exception(" E-Hundi entry already exists.");
      } else {
        throw Exception(" Failed with status: ${response.statusCode}, body: ${response.data}");
      }
    } catch (e) {
      print("🚨 Error posting E-Hundi: $e");
      return null;
    }
  }


  Future<dynamic> postAdvVazhipaduDetails(Map<String, dynamic> data) async    {
    final token = await AppHive().getToken();

    try {
      final response = await _dio.post(
        '/vazhipadu/AdvanceVazhipadureceipt?lang=en',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print(response.data);
      print(response.statusCode);
      print(response.statusMessage);
      print("----------response from api-------------");
      return response.data;
    } catch (e) {
      print('API call error: $e');
      rethrow;
    }
  }


  Future<List<GetTemplemodel>> getTemple(String dbName) async {
    try {
      final token = await AppHive().getToken();

      final response = await _dio.get(
        '/Temple/$dbName',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final responseData = response.data;

      if (responseData is Map<String, dynamic> && responseData['data'] is List) {
        final dataList = responseData['data'] as List;
        return dataList.map((item) => GetTemplemodel.fromJson(item)).toList();
      } else if (responseData is Map<String, dynamic>) {
        return [GetTemplemodel.fromJson(responseData)];
      } else {
        return [];
      }
    } catch (e) {
      print("Error in getTemple: $e");
      return [];
    }
  }

  Future<GetSingleTemplemodel?> getSingleTempleName() async {
    try {
      final token = await AppHive().getToken();
      final templeId = await getTempleIdFromToken();
      final lag = await appHive.getLanguage();

      if (templeId == null) return null;

      final response = await _dio.post(
        '/Translator/get-temple-names?templeId=$templeId&lang=$lag',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('templeName')) {
        return GetSingleTemplemodel.fromJson(data);
      }

      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }


  Future<String?> getDatabaseNameFromToken() async {
    try {
      final token = await AppHive().getToken();

      if (token.isNotEmpty) {
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        print("Decoded Token: $decodedToken");

        if (decodedToken.containsKey('DatabaseName')) {
          return decodedToken['DatabaseName'] as String;
        } else {
          print("Key 'DatabaseName' not found in token.");
        }
      } else {
        print("JWT token is null or empty.");
      }
    } catch (e) {
      print("Error decoding token: $e");
    }

    return null;
  }

  Future<int?> getTempleIdFromToken() async {
    try {
      final token = await AppHive().getToken();

      if (token.isNotEmpty) {
        final decoded = JwtDecoder.decode(token);

        print("🔓 Decoded Token: $decoded");

        if (decoded.containsKey('TempleId')) {
          final templeId = decoded['TempleId'];
          print("🏛️ Temple ID from token: $templeId");

          if (templeId is int) {
            return templeId;
          } else if (templeId is String) {
            return int.tryParse(templeId);
          } else {
            print("⚠️ Temple ID is of unexpected type: ${templeId.runtimeType}");
          }
        } else {
          print("❌ 'TempleId' key not found in token.");
        }
      } else {
        print("❌ Token is empty or null.");
      }
    } catch (e) {
      print("❌ Error decoding token for TempleId: $e");
    }

    return null;
  }

  Future<void> printDeviceDetails() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo android = await deviceInfo.androidInfo;
        print('Device Info [Android]:');
        print('Brand: ${android.brand}');
        print('Device: ${android.device}');
        print('Model: ${android.model}');
        print('Android Version: ${android.version.release}');
        print('Android SDK: ${android.version.sdkInt}');
        print('serial number: ${android.serialNumber}');
        print('id: ${android.id}');
      } else if (Platform.isIOS) {
        IosDeviceInfo ios = await deviceInfo.iosInfo;
        print('Device Info [iOS]:');
        print('Name: ${ios.name}');
        print('Model: ${ios.model}');
        print('System Version: ${ios.systemVersion}');
        print('Identifier for Vendor: ${ios.identifierForVendor}');
      }
    } catch (e) {
      print('Failed to get device info: $e');
    }
  }

}