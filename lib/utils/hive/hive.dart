import 'package:hive/hive.dart';
import 'constants.dart';

class AppHive {
  static const String _USER_ID = "user_id";
  static const String _ISLOGGEDIN = "isLoggedIn";
  static const String _VIDEOSOUNDSTATUS = "video_sound_status";
  static const String _IS_SIGNED_IN_USER = "isSignedInUser";
  static const String _NAME = "name";
  static const String _TOKEN = "token";
  static const String _REFRESH_TOKEN = "refresh_token"; // ✅ Added
  static const String _LANGUAGE = "language";

  /// Put methods
  Future<void> hivePut({required String key, required String? value}) async {
    await Hive.box(Constants.BOX_NAME).put(key, value);
  }

  Future<void> hivePutInt({required String key, required int? value}) async {
    await Hive.box(Constants.BOX_NAME).put(key, value);
  }

  Future<void> hivePutBool({required String key, required bool? value}) async {
    await Hive.box(Constants.BOX_NAME).put(key, value);
  }

  /// Get methods
  bool hiveGetBool({required String key}) {
    return Hive.box(Constants.BOX_NAME).get(key) ?? false;
  }

  String hiveGet({required String key}) {
    return Hive.box(Constants.BOX_NAME).get(key) ?? "";
  }

  int hiveGetInt({required String key}) {
    return Hive.box(Constants.BOX_NAME).get(key) ?? 0;
  }

  /// User ID
  Future<void> putUserId(String? userId) async {
    await hivePut(key: _USER_ID, value: userId);
  }

  String getUserId() {
    return hiveGet(key: _USER_ID);
  }

  /// Login Status
  bool getIsUserLoggedIn() {
    return Hive.box(Constants.BOX_NAME).get(_ISLOGGEDIN) ?? false;
  }

  Future<void> putIsUserLoggedIn({required bool isLoggedIn}) async {
    await Hive.box(Constants.BOX_NAME).put(_ISLOGGEDIN, isLoggedIn);
  }

  /// Video Audio Status
  Future<void> putVideoAudioStatus(bool? isVideoPlaying) async {
    await hivePutBool(key: _VIDEOSOUNDSTATUS, value: isVideoPlaying);
  }

  bool getVideoAudioStatus() {
    return hiveGetBool(key: _VIDEOSOUNDSTATUS);
  }

  /// Name
  Future<void> putName(String? name, String languageCode) async {
    await hivePut(key: _NAME, value: name);
  }

  String getName() {
    return hiveGet(key: _NAME);
  }

  /// Access Token
  Future<void> putToken({required String token}) async {
    await hivePut(key: _TOKEN, value: token);
  }

  String getToken() {
    return hiveGet(key: _TOKEN);
  }

  /// Refresh Token -  NEW
  Future<void> putRefreshToken({required String token}) async {
    await hivePut(key: _REFRESH_TOKEN, value: token);
  }

  String getRefreshToken() {
    return hiveGet(key: _REFRESH_TOKEN);
  }

  /// Signed-In User
  Future<void> putIsSignedInUser(bool? isSignedInUser) async {
    await hivePutBool(key: _IS_SIGNED_IN_USER, value: isSignedInUser);
  }

  bool getIsSignedInUser() {
    return hiveGetBool(key: _IS_SIGNED_IN_USER);
  }

  /// Language
  Future<void> putLanguage(String? language, String languageCode) async {
    await hivePut(key: _LANGUAGE, value: language);
  }

  String getLanguage() {
    return hiveGet(key: _LANGUAGE);
  }

  /// Clear all saved data
  Future<void> clearHive() async {
    await Hive.box(Constants.BOX_NAME).clear();
  }

  /// Constructor
  AppHive();
}

/// Global instance (optional but usable for direct access)
AppHive appHive = AppHive();
