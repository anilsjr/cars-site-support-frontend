import 'package:get/get.dart';
import '../../data/datasources/serviceticket_remote_datasource.dart';
import '../../data/repositories/serviceticket_repository_impl.dart';
import '../../domain/repositories/serviceticket_repository.dart';
import '../../domain/usecases/serviceticket_usecases.dart';
import '../controllers/serviceticket_controller.dart';

class ServiceTicketBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<ServiceTicketRemoteDataSource>(
      () => ServiceTicketRemoteDataSourceImpl(),
    );

    // Repositories
    Get.lazyPut<ServiceTicketRepository>(
      () => ServiceTicketRepositoryImpl(
        remoteDataSource: Get.find<ServiceTicketRemoteDataSource>(),
      ),
    );

    // Use cases
    Get.lazyPut<GetServiceTicketsUseCase>(
      () => GetServiceTicketsUseCase(Get.find<ServiceTicketRepository>()),
    );

    Get.lazyPut<GetServiceTicketByIdUseCase>(
      () => GetServiceTicketByIdUseCase(Get.find<ServiceTicketRepository>()),
    );

    Get.lazyPut<CreateServiceTicketUseCase>(
      () => CreateServiceTicketUseCase(Get.find<ServiceTicketRepository>()),
    );

    Get.lazyPut<UpdateServiceTicketUseCase>(
      () => UpdateServiceTicketUseCase(Get.find<ServiceTicketRepository>()),
    );

    Get.lazyPut<DeleteServiceTicketUseCase>(
      () => DeleteServiceTicketUseCase(Get.find<ServiceTicketRepository>()),
    );

    // Controllers
    Get.lazyPut<ServiceTicketController>(
      () => ServiceTicketController(
        getServiceTicketsUseCase: Get.find<GetServiceTicketsUseCase>(),
        getServiceTicketByIdUseCase: Get.find<GetServiceTicketByIdUseCase>(),
        createServiceTicketUseCase: Get.find<CreateServiceTicketUseCase>(),
        updateServiceTicketUseCase: Get.find<UpdateServiceTicketUseCase>(),
        deleteServiceTicketUseCase: Get.find<DeleteServiceTicketUseCase>(),
      ),
    );
  }
}
