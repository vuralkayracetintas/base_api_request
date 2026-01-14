part of 'auth_cubit.dart';

final class AuthState extends Equatable {
  const AuthState({
    this.user,
    this.getMeData,
    this.isLoading,
    this.errorMessage,
    this.shouldNavigateToLogin,
  });
  final UserModel? user;
  final GetMeModel? getMeData;
  final bool? isLoading;
  final String? errorMessage;
  final bool? shouldNavigateToLogin;

  AuthState copyWith({
    UserModel? user,
    GetMeModel? getMeData,
    bool? isLoading,
    String? errorMessage,
    bool? shouldNavigateToLogin,
  }) {
    return AuthState(
      user: user ?? this.user,
      getMeData: getMeData ?? this.getMeData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      shouldNavigateToLogin: shouldNavigateToLogin,
    );
  }

  @override
  List<Object?> get props => [
    user,
    getMeData,
    isLoading,
    errorMessage,
    shouldNavigateToLogin,
  ];
}
