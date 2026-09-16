import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/filter_options_model.dart';
import '../../../data/repositories/listings_repo.dart';
import '../../../routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';

class FilterController extends GetxController {
  final ListingsRepo _listingsRepo = ListingsRepo();

  // API Data
  final Rx<FilterOptionsData?> apiFilterOptions = Rx<FilterOptionsData?>(null);
  final RxBool isLoadingOptions = false.obs;

  final RxString selectedCity = 'Khulna'.obs;
  final RxString selectedSubLocation = 'Sonadanga, Khulna'.obs;

  final Rx<RangeValues> priceRange = const RangeValues(10000, 20000).obs;
  final double minPriceLimit = 1000;
  final double maxPriceLimit = 100000;

  final TextEditingController minPriceTextController = TextEditingController(
    text: '10000',
  );
  final TextEditingController maxPriceTextController = TextEditingController(
    text: '20000',
  );

  final List<Map<String, dynamic>> propertyTypes = const [
    {'title': 'Family', 'icon': Icons.family_restroom_rounded},
    {'title': 'Bachelor', 'icon': Icons.person_outline_rounded},
    {'title': 'Sublet', 'icon': Icons.door_front_door_outlined},
    {'title': 'Seat', 'icon': Icons.bed_rounded},
  ];
  final RxString selectedPropertyType = 'Family'.obs;

  final List<String> bachelorGenderOptions = const ['Male', 'Female', 'Any'];
  final RxString selectedBachelorGender = 'Male'.obs;

  final List<String> bedroomOptions = const ['1', '2', '3', '4+'];
  final RxString selectedBedrooms = '2'.obs;

  final List<String> furnishingOptions = const [
    'Furnished',
    'Unfurnished',
    'Semi',
  ];
  final RxString selectedFurnishing = 'Semi'.obs;

  final List<Map<String, dynamic>> amenityOptions = const [
    {'title': 'Generator', 'icon': Icons.flash_on_outlined},
    {'title': 'Lift', 'icon': Icons.elevator_outlined},
    {'title': 'Parking', 'icon': Icons.directions_car_outlined},
    {'title': 'Gas', 'icon': Icons.local_fire_department_outlined},
    {'title': 'Water 24/7', 'icon': Icons.water_drop_outlined},
  ];
  final RxList<String> selectedAmenities = <String>['Lift', 'Parking'].obs;

  final List<String> availabilityOptions = const [
    'Available now',
    'From next month',
  ];
  final RxString selectedAvailability = 'Available now'.obs;

  final RxInt matchingResultsCount = 24.obs;

  @override
  void onInit() {
    super.onInit();

    // Load filter options from API
    loadFilterOptions();

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

  // Load Filter Options from API
  Future<void> loadFilterOptions() async {
    try {
      isLoadingOptions.value = true;

      final response = await _listingsRepo.getFilterOptions();

      if (response.isSuccess) {
        final filterOptionsResponse = _listingsRepo.parseFilterOptionsResponse(
          response,
        );

        if (filterOptionsResponse != null) {
          apiFilterOptions.value = filterOptionsResponse.data;

          // Update price range based on API data
          if (filterOptionsResponse.data.priceRange.min > 0) {
            priceRange.value = RangeValues(
              filterOptionsResponse.data.priceRange.min.toDouble(),
              filterOptionsResponse.data.priceRange.max.toDouble(),
            );
            minPriceTextController.text = filterOptionsResponse
                .data
                .priceRange
                .min
                .toString();
            maxPriceTextController.text = filterOptionsResponse
                .data
                .priceRange
                .max
                .toString();
          }

          debugPrint('Filter options loaded successfully');
        }
      } else {
        debugPrint('Failed to load filter options: ${response.errorMessage}');
      }
    } catch (e) {
      debugPrint('Error loading filter options: $e');
    } finally {
      isLoadingOptions.value = false;
    }
  }

  // Get cities from API or fallback to default
  List<String> get availableCities {
    if (apiFilterOptions.value != null &&
        apiFilterOptions.value!.cities.isNotEmpty) {
      return apiFilterOptions.value!.cities;
    }
    return ['Khulna']; // Default fallback
  }

  // Get areas from API or fallback to default
  List<String> get availableAreas {
    if (apiFilterOptions.value != null &&
        apiFilterOptions.value!.areas.isNotEmpty) {
      return apiFilterOptions.value!.areas;
    }
    return ['Sonadanga']; // Default fallback
  }

  // Get property types from API or fallback to default
  List<String> get availablePropertyTypes {
    if (apiFilterOptions.value != null &&
        apiFilterOptions.value!.propertyTypes.isNotEmpty) {
      return apiFilterOptions.value!.propertyTypes;
    }
    return ['Bachelor', 'Family', 'Seat', 'Sublet', 'Office'];
  }

  // Get furnishing options from API or fallback to default
  List<String> get availableFurnishing {
    if (apiFilterOptions.value != null &&
        apiFilterOptions.value!.furnishing.isNotEmpty) {
      return apiFilterOptions.value!.furnishing;
    }
    return ['Furnished', 'Unfurnished', 'Semi'];
  }

  // Get amenities from API or fallback to default
  List<String> get availableAmenities {
    if (apiFilterOptions.value != null &&
        apiFilterOptions.value!.amenities.isNotEmpty) {
      return apiFilterOptions.value!.amenities;
    }
    return ['generator', 'lift', 'parking', 'gasLine', 'water24_7', 'wifi'];
  }

  // Get availability options from API or fallback to default
  List<String> get availableAvailability {
    if (apiFilterOptions.value != null &&
        apiFilterOptions.value!.availability.isNotEmpty) {
      return apiFilterOptions.value!.availability;
    }
    return ['Available now', 'From next month'];
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
