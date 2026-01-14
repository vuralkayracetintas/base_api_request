import 'package:base_apis/data/datasource/auth_datasource.dart';
import 'package:base_apis/model/get_me_model.dart';
import 'package:base_apis/model/token_response_model.dart';
import 'package:base_apis/model/user_model.dart';
import 'package:base_apis/result/result.dart';

abstract class AuthRepository {
  Future<DataResult<UserModel>> authLogin({
    required String username,
    required String password,
  });

  Future<DataResult<GetMeModel>> getMe();

  Future<DataResult<TokenResponseModel>> refreshToken({
    required String refreshToken,
    int expiresInMins,
  });
}

final class IAuthRepository implements AuthRepository {
  final AuthDatasource _authDatasource;
  IAuthRepository({required AuthDatasource authDatasource})
    : _authDatasource = authDatasource;

  @override
  Future<DataResult<UserModel>> authLogin({
    required String username,
    required String password,
  }) async {
    final response = await _authDatasource.authLogin(
      username: username,
      password: password,
    );

    if (response.isSuccess) {
      return SuccessDataResult(
        data: response.data!,
        message: 'Login successful',
      );
    } else {
      return ErrorDataResult(
        message: response.error?.message ?? 'Login failed',
      );
    }
  }

  @override
  Future<DataResult<GetMeModel>> getMe() async {
    final response = await _authDatasource.getMe();

    if (response.isSuccess) {
      return SuccessDataResult(
        data: response.data!,
        message: 'User data fetched successfully',
      );
    } else {
      return ErrorDataResult(
        message: response.error?.message ?? 'Failed to fetch user data',
      );
    }
  }

  @override
  Future<DataResult<TokenResponseModel>> refreshToken({
    required String refreshToken,
    int expiresInMins = 30,
  }) async {
    final response = await _authDatasource.refreshToken(
      refreshToken: refreshToken,
      expiresInMins: expiresInMins,
    );

    if (response.isSuccess) {
      return SuccessDataResult(
        data: response.data!,
        message: 'Token refreshed successfully',
      );
    } else {
      return ErrorDataResult(
        message: response.error?.message ?? 'Failed to refresh token',
      );
    }
  }
}
