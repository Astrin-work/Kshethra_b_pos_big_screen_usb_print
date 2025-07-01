
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kshethra_mini/model/api%20models/get_temple_model.dart';
import '../model/api models/E_Hundi_Get_Devatha_Model.dart';
import '../model/api models/get_donation_model.dart';
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
      final response = await _dio.post(
        '/Login',
        data: {
          'userUserName': username,
          'userPassword': password,
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
    }
  }

  Future<List<Godmodel>> getDevatha() async {
    final token = await AppHive().getToken();

    final response = await _dio.get(
      '/Devatha/DevathaVazhipadu',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final List<dynamic> dataList = response.data;

    List<Godmodel> godList = [];
    for (var item in dataList) {
      godList.add(Godmodel.fromJson(item));
    }
    return godList;
  }

  Future<dynamic> postVazhipaduDetails(Map<String, dynamic> data) async {
    final token = await AppHive().getToken();

    try {
      final response = await _dio.post(
        '/vazhipadu/vazhipadureceipt',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
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

    final response = await _dio.get(
      '/Donation',
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


  Future<void> postDonationDetails(Map<String, dynamic> donationData) async {
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
        print("Donation posted successfully.");
        print(response.data);
        print(response.statusMessage);
      } else if (response.statusCode == 409) {
        throw Exception("Donation already exists.");
      } else {
        throw Exception("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error posting donation: $e");
      rethrow;
    }
  }


  Future<List<Ehundigetdevathamodel>> getEbannaramDevetha() async {
    final token = await AppHive().getToken();

    final response = await _dio.get(
      '/Devatha',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final List<dynamic> dataList = response.data;

    List<Ehundigetdevathamodel> godListEhundi = [];
    for (var item in dataList) {
      godListEhundi.add(Ehundigetdevathamodel.fromJson(item));
    }
    return godListEhundi;
  }


  Future<void> postEHundiDetails(Map<String, dynamic> eHundiData) async {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(" E-Hundi posted successfully.");
        print(response.data);
        print(response.realUri);
        print(response.statusMessage);
        print(response.statusCode);
      } else if (response.statusCode == 409) {
        throw Exception(" E-Hundi entry already exists.");
      } else {
        throw Exception(" Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print(" Error posting E-Hundi: $e");
      rethrow;
    }
  }

  Future<dynamic> postAdvVazhipaduDetails(Map<String, dynamic> data) async {
    final token = await AppHive().getToken();

    try {
      final response = await _dio.post(
        '/vazhipadu/AdvanceVazhipadureceipt',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print(response.data);
      print(response.statusCode);
      print(response.statusMessage);
      // Return the full JSON response
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

  Future<String?> getDatabaseNameFromToken() async {
    try {
      final token = await AppHive().getToken();

      if (token != null && token.isNotEmpty) {
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



}