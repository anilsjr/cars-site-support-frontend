import 'package:get/get.dart';
import '../../data/datasources/servicelead_remote_datasource.dart';
import '../../data/repositories/servicelead_repository_impl.dart';
import '../../domain/repositories/servicelead_repository.dart';
import '../../domain/usecases/servicelead_usecases.dart';
import '../controllers/servicelead_controller.dart';

class ServiceLeadBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<ServiceLeadRemoteDataSource>(
      () => ServiceLeadRemoteDataSourceImpl(),
    );

    // Repositories
    Get.lazyPut<ServiceLeadRepository>(
      () => ServiceLeadRepositoryImpl(
        remoteDataSource: Get.find<ServiceLeadRemoteDataSource>(),
      ),
    );

    // Use cases
    Get.lazyPut<GetServiceLeadsUseCase>(
      () => GetServiceLeadsUseCase(Get.find<ServiceLeadRepository>()),
    );

    Get.lazyPut<GetServiceLeadByIdUseCase>(
      () => GetServiceLeadByIdUseCase(Get.find<ServiceLeadRepository>()),
    );

    Get.lazyPut<CreateServiceLeadUseCase>(
      () => CreateServiceLeadUseCase(Get.find<ServiceLeadRepository>()),
    );

    Get.lazyPut<UpdateServiceLeadUseCase>(
      () => UpdateServiceLeadUseCase(Get.find<ServiceLeadRepository>()),
    );

    Get.lazyPut<DeleteServiceLeadUseCase>(
      () => DeleteServiceLeadUseCase(Get.find<ServiceLeadRepository>()),
    );

    // Controllers
    Get.lazyPut<ServiceLeadController>(
      () => ServiceLeadController(
        getServiceLeadsUseCase: Get.find<GetServiceLeadsUseCase>(),
        getServiceLeadByIdUseCase: Get.find<GetServiceLeadByIdUseCase>(),
        createServiceLeadUseCase: Get.find<CreateServiceLeadUseCase>(),
        updateServiceLeadUseCase: Get.find<UpdateServiceLeadUseCase>(),
        deleteServiceLeadUseCase: Get.find<DeleteServiceLeadUseCase>(),
      ),
    );
  }
}
