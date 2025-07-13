import 'package:get/get.dart';
import '../controllers/service_leads_controller.dart';
import '../../domain/usecases/service_lead_usecases.dart';

class ServiceLeadsBinding extends Bindings {
  @override
  void dependencies() {
    // Get the use case from dependency injection
    final getServiceLeadsUseCase = Get.find<GetServiceLeadsUseCase>();

    // Register the controller
    Get.lazyPut<ServiceLeadsController>(
      () => ServiceLeadsController(getServiceLeadsUseCase),
    );
  }
}
