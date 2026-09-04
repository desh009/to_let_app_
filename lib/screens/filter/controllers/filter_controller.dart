import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';

class FilterController extends GetxController {
  // Location
  final RxString selectedCity = 'Khulna'.obs;
  final RxString selectedSubLocation = 'Sonadanga, Khulna'.obs;

  // Price Range
  final Rx<RangeValues> priceRange = const RangeValues(10000, 20000).obs;
  final double minPriceLimit = 1000;
  final double maxPriceLimit = 100000;

  final TextEditingController minPriceTextController = TextEditingController(text: '10000');
  final TextEditingController maxPriceTextController = TextEditingController(text: '20000');

  // Property Types (Exactly 4 Options: Family, Bachelor, Sublet, Seat)
  final List<Map<String, dynamic>> propertyTypes = const [
    {'title': 'Family', 'icon': Icons.family_restroom_rounded},
    {'title': 'Bachelor', 'icon': Icons.person_outline_rounded},
    {'title': 'Sublet', 'icon': Icons.door_front_door_outlined},
    {'title': 'Seat', 'icon': Icons.bed_rounded},
  ];
  final RxString selectedPropertyType = 'Family'.obs;

  // Bachelor Preference (Male / Female / Any)
  final List<String> bachelorGenderOptions = const ['Male', 'Female', 'Any'];
  final RxString selectedBachelorGender = 'Male'.obs;

  // Bedrooms
  final List<String> bedroomOptions = const ['1', '2', '3', '4+'];
  final RxString selectedBedrooms = '2'.obs;

  // Furnishing
  final List<String> furnishingOptions = const ['Furnished', 'Unfurnished', 'Semi'];
  final RxString selectedFurnishing = 'Semi'.obs;

  // Amenities
  final List<Map<String, dynamic>> amenityOptions = const [
    {'title': 'Generator', 'icon': Icons.flash_on_outlined},
    {'title': 'Lift', 'icon': Icons.elevator_outlined},
    {'title': 'Parking', 'icon': Icons.directions_car_outlined},
    {'title': 'Gas', 'icon': Icons.local_fire_department_outlined},
    {'title': 'Water 24/7', 'icon': Icons.water_drop_outlined},
  ];
  final RxList<String> selectedAmenities = <String>['Lift', 'Parking'].obs;

  // Availability
  final List<String> availabilityOptions = const ['Available now', 'From next month'];
  final RxString selectedAvailability = 'Available now'.obs;

  // Results count
  final RxInt matchingResultsCount = 24.obs;

  @override
  void onInit() {
    super.onInit();
    // Sync location from HomeController if available
    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();
      final loc = homeCtrl.selectedLocation.value;
      if (loc.isNotEmpty) {
        selectedSubLocation.value = loc;
        if (loc.contains(',')) {
          selectedCity.value = loc.split(',').last.trim();
        } else {
          selectedCity.value = 'Khulna';
        }
      }
    }
  }

  void updatePriceRange(RangeValues values) {
    priceRange.value = values;
    minPriceTextController.text = values.start.round().toString();
    maxPriceTextController.text = values.end.round().toString();
    _recalculateResults();
  }

  void updateMinPrice(String text) {
    final val = double.tryParse(text);
    if (val != null) {
      final newMin = val.clamp(minPriceLimit, priceRange.value.end - 500);
      priceRange.value = RangeValues(newMin, priceRange.value.end);
      _recalculateResults();
    }
  }

  void updateMaxPrice(String text) {
    final val = double.tryParse(text);
    if (val != null) {
      final newMax = val.clamp(priceRange.value.start + 500, maxPriceLimit);
      priceRange.value = RangeValues(priceRange.value.start, newMax);
      _recalculateResults();
    }
  }

  void selectPropertyType(String type) {
    selectedPropertyType.value = type;
    _recalculateResults();
  }

  void selectBachelorGender(String val) {
    selectedBachelorGender.value = val;
    _recalculateResults();
  }

  void selectBedrooms(String val) {
    selectedBedrooms.value = val;
    _recalculateResults();
  }

  void selectFurnishing(String val) {
    selectedFurnishing.value = val;
    _recalculateResults();
  }

  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
    _recalculateResults();
  }

  void selectAvailability(String val) {
    selectedAvailability.value = val;
    _recalculateResults();
  }

  void clearSubLocation() {
    selectedSubLocation.value = '';
    _recalculateResults();
  }

  void resetFilters() {
    priceRange.value = const RangeValues(10000, 20000);
    minPriceTextController.text = '10000';
    maxPriceTextController.text = '20000';
    selectedPropertyType.value = 'Family';
    selectedBedrooms.value = '2';
    selectedFurnishing.value = 'Semi';
    selectedAmenities.assignAll(['Lift', 'Parking']);
    selectedAvailability.value = 'Available now';
    matchingResultsCount.value = 24;
  }

  void _recalculateResults() {
    int count = 18;
    if (selectedPropertyType.value == 'Family') count += 6;
    if (selectedBedrooms.value == '2') count += 4;
    if (selectedFurnishing.value == 'Semi') count += 2;
    if (selectedSubLocation.value.isEmpty) count += 10;
    matchingResultsCount.value = count;
  }

  void applyFilters() {
    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();
      homeCtrl.selectCategory(selectedPropertyType.value);
      if (selectedSubLocation.value.isNotEmpty) {
        homeCtrl.updateLocation(selectedSubLocation.value);
      }
    }
    Get.toNamed(Routes.FILTER_RESULTS);
  }

  @override
  void onClose() {
    minPriceTextController.dispose();
    maxPriceTextController.dispose();
    super.onClose();
  }
}
