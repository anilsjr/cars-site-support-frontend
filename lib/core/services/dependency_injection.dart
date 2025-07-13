import 'package:get/get.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/datasources/service_lead_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/service_lead_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/service_lead_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/service_lead_usecases.dart';
import 'auth_service.dart';
import 'network_service.dart';
import 'storage_service.dart';
import 'theme_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Core Services - register instances first, but don't initialize ThemeService yet
    Get.put(NetworkService(), permanent: true);
    Get.put(StorageService(), permanent: true);

    // Initialize storage service first
    await Get.find<StorageService>().initialize();
    Get.find<NetworkService>().initialize();

    // Now register services that depend on storage being initialized
    Get.put(ThemeService(), permanent: true);
    Get.put(AuthService(), permanent: true);

    // Data Sources
    Get.lazyPut<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(Get.find<NetworkService>()),
      fenix: true,
    );

    Get.lazyPut<ServiceLeadRemoteDataSource>(
      () => ServiceLeadRemoteDataSourceImpl(Get.find<NetworkService>()),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<UserRemoteDataSource>(),
        storageService: Get.find<StorageService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ServiceLeadRepository>(
      () => ServiceLeadRepositoryImpl(
        remoteDataSource: Get.find<ServiceLeadRemoteDataSource>(),
      ),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(() => LoginUseCase(Get.find<UserRepository>()), fenix: true);
    Get.lazyPut(() => LogoutUseCase(Get.find<UserRepository>()), fenix: true);
    Get.lazyPut(
      () => GetCurrentUserUseCase(Get.find<UserRepository>()),
      fenix: true,
    );

    // Service Lead Use Cases
    Get.lazyPut(
      () => GetServiceLeadsUseCase(Get.find<ServiceLeadRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetServiceLeadByIdUseCase(Get.find<ServiceLeadRepository>()),
      fenix: true,
    );
  }
}
