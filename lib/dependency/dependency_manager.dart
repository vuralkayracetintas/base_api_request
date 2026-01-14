import 'package:base_apis/cubit/auth_cubit.dart';
import 'package:base_apis/data/datasource/auth_datasource.dart';
import 'package:base_apis/data/repository/auth_repository.dart';
import 'package:base_apis/model/user_model.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

/// **Service provider class managing all dependencies**
final class ServiceLocator {
  /// **Main method to call to set up dependencies**
  ///

  void setup() {
    // _setupRouter();
    _setupDataSource();
    _setupRepository();
    _setupCubit();
    _setupModels();
  }

  /// **Router Dependency**
  // void _setupRouter() {
  //   getIt.registerLazySingleton<AppRouter>(() => AppRouter(getIt()));
  // }

  void _setupModels() {
    getIt.registerLazySingleton<UserModel>(() => UserModel());
    // getIt.registerLazySingleton<InstructorModel>(() => InstructorModel());
  }

  /// **DataSource Dependency**
  void _setupDataSource() {
    getIt.registerLazySingleton<AuthDatasource>(() => IAuthDatasource());
  }

  /// **Repository Dependency**
  void _setupRepository() {
    getIt.registerLazySingleton<AuthRepository>(
      () => IAuthRepository(authDatasource: getIt()),
    );
  }

  /// **BLoC, Cubit and ViewModel Dependency**
  void _setupCubit() {
    getIt.registerLazySingleton<AuthCubit>(
      () => AuthCubit(authRepository: getIt()),
    );
  }

  /// **Resets dependencies for Test and Debug**
  Future<void> reset() async {
    await getIt.reset();
    setup();
  }
}
