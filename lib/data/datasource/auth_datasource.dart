import 'package:base_apis/dio/api_response_model.dart';
import 'package:base_apis/dio/dio_manager.dart';
import 'package:base_apis/model/get_me_model.dart';
import 'package:base_apis/model/token_response_model.dart';
import 'package:base_apis/model/user_model.dart';

abstract class AuthDatasource {
  Future<ApiResponseModel<UserModel>> authLogin({
    required String username,
    required String password,
  });

  Future<ApiResponseModel<GetMeModel>> getMe();

  Future<ApiResponseModel<TokenResponseModel>> refreshToken({
    required String refreshToken,
    int expiresInMins,
  });
}

final class IAuthDatasource extends AuthDatasource {
  final String _baseUrl = 'https://dummyjson.com/';
  late final DioApiManager _dioManager;

  IAuthDatasource() {
    _dioManager = DioApiManager(baseUrl: _baseUrl);
  }

  @override
  Future<ApiResponseModel<UserModel>> authLogin({
    required String username,
    required String password,
  }) async {
    final response = await _dioManager.post(
      'auth/login',
      data: {'username': username, 'password': password, "expiresInMins": 2},
      converter: (data) {
        return UserModel.fromJson(data);
      },
    );
    if (response.isSuccess) {
      return ApiResponseModel.success(response.data!);
    } else {
      return ApiResponseModel.error(response.error!);
    }
  }

  @override
  Future<ApiResponseModel<GetMeModel>> getMe() async {
    final response = await _dioManager.get(
      'auth/me',
      converter: (data) {
        return GetMeModel.fromJson(data);
      },
    );
    if (response.isSuccess) {
      return ApiResponseModel.success(response.data!);
    } else {
      return ApiResponseModel.error(response.error!);
    }
  }

  @override
  Future<ApiResponseModel<TokenResponseModel>> refreshToken({
    required String refreshToken,
    int expiresInMins = 2,
  }) async {
    final response = await _dioManager.post(
      'auth/refresh',
      data: {'refreshToken': refreshToken, 'expiresInMins': expiresInMins},
      converter: (data) {
        return TokenResponseModel.fromJson(data);
      },
    );
    if (response.isSuccess) {
      return ApiResponseModel.success(response.data!);
    } else {
      return ApiResponseModel.error(response.error!);
    }
  }
}
