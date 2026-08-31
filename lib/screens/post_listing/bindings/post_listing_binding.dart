import 'package:get/get.dart';
import '../controllers/post_listing_controller.dart';

class PostListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostListingController>(
      () => PostListingController(),
    );
  }
}
