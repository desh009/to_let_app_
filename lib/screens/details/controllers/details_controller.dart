import 'package:get/get.dart';
import 'package:to_let_app_abandon/widgets/favourite/controller/favourite_controller.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../masaage/massage_details/view/massage_details_view.dart';
import '../../masaage/controller/massage_controller.dart';

class DetailsController extends GetxController {
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  late final ToLetItem item;

  bool get isFavorite => favoriteController.isFavorite(item.id);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ToLetItem) {
      item = Get.arguments as ToLetItem;
    }
  }

  Future<void> toggleFavorite() async {
    await favoriteController.toggleFavorite(item);
  }

  void contactOwner() {
    // Create a message object for the owner
    final ownerMessage = MessageTileData(
      avatar:
          item.ownerAvatar ??
          'https://i.pravatar.cc/150?img=${item.id.hashCode % 70}',
      badgeCount: null,
      title: item.ownerName,
      time: 'Now',
      message: 'Property inquiry about ${item.title}',
      tag: item.title,
      showDot: false,
      isSystem: false,
    );

    // Navigate to chat detail screen
    Get.to(() => ChatDetailScreen(message: ownerMessage));
  }
}
