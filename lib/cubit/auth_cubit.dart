import 'package:base_apis/data/repository/auth_repository.dart';
import 'package:base_apis/dio/token_manager.dart';
import 'package:base_apis/model/get_me_model.dart';

import 'package:base_apis/model/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true));
    final result = await _authRepository.authLogin(
      username: username,
      password: password,
    );
    if (result.success) {
      // Save tokens to TokenManager for automatic refresh
      TokenManager().setTokens(
        accessToken: result.data!.accesToken,
        refreshToken: result.data!.refreshToken,
      );
      emit(state.copyWith(user: result.data, isLoading: false));
      // After successful login, fetch user details
      await getMe();
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> getMe() async {
    // Check if we have an access token from TokenManager
    if (TokenManager().accessToken == null) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'No access token available',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _authRepository.getMe();
    if (result.success) {
      emit(
        state.copyWith(
          getMeData: result.data,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } else {
      // Interceptor will handle token refresh automatically
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: result.message ?? 'Failed to fetch user data',
        ),
      );
    }
  }

  void logout() {
    TokenManager().clearTokens();
    emit(const AuthState());
  }
}
