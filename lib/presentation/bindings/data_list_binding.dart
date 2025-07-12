import 'package:get/get.dart';
import '../controllers/data_list_controller.dart';

class DataListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataListController>(() => DataListController());
  }
}
