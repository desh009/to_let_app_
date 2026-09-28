import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/filter_options_model.dart';
import '../../../data/models/listing_model.dart';
import '../../../data/repositories/listings_repo.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../../routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';

class FilterController extends GetxController {
  final ListingsRepo _listingsRepo = ListingsRepo();

  // ============================================================
  // API DATA
  // ============================================================

  final Rx<FilterOptionsData?> apiFilterOptions = Rx<FilterOptionsData?>(null);

  final RxBool isLoadingOptions = false.obs;
  final RxBool isLoadingResults = false.obs;

  final RxList<ToLetItem> filteredListings = <ToLetItem>[].obs;

  // ============================================================
  // LOCATION
  // ============================================================

  final RxString selectedCity = ''.obs;
  final RxString selectedSubLocation = ''.obs;

  // ============================================================
  // PRICE
  // ============================================================

  final Rx<RangeValues> priceRange = const RangeValues(1000, 35000).obs;

  final TextEditingController minPriceTextController = TextEditingController(
    text: '1000',
  );

  final TextEditingController maxPriceTextController = TextEditingController(
    text: '35000',
  );

  final RxDouble minPriceLimit = 1000.0.obs;
  final RxDouble maxPriceLimit = 100000.0.obs;

  // ============================================================
  // PROPERTY TYPE
  // ============================================================

  // These will be used as fallback if API fails
  final List<String> _fallbackPropertyTypes = ['Family', 'Bachelor', 'Sublet', 'Seat'];
  final List<String> _fallbackBedrooms = ['1', '2', '3', '4+'];
  final List<String> _fallbackFurnishing = ['Furnished', 'Unfurnished', 'Semi'];
  final List<String> _fallbackAvailability = ['Available now', 'From next month'];

  // Selection states
  final RxString selectedPropertyType = ''.obs;
  final List<String> bachelorGenderOptions = const ['Male', 'Female', 'Any'];
  final RxString selectedBachelorGender = 'Any'.obs;
  final RxString selectedBedrooms = ''.obs;
  final RxString selectedFurnishing = ''.obs;
  final RxList<String> selectedAmenities = <String>[].obs;
  final RxString selectedAvailability = ''.obs;

  final List<Map<String, dynamic>> _fallbackAmenities = const [
    {'title': 'Generator', 'key': 'generator', 'icon': Icons.flash_on_outlined},
    {'title': 'Lift', 'key': 'lift', 'icon': Icons.elevator_outlined},
    {'title': 'Parking', 'key': 'parking', 'icon': Icons.directions_car_outlined},
    {'title': 'Gas', 'key': 'gasLine', 'icon': Icons.local_fire_department_outlined},
    {'title': 'Water 24/7', 'key': 'water24_7', 'icon': Icons.water_drop_outlined},
    {'title': 'WiFi', 'key': 'wifi', 'icon': Icons.wifi_rounded},
  ];

  // ============================================================
  // GETTERS FOR DYNAMIC UI
  // ============================================================

  List<Map<String, dynamic>> get dynamicAmenityOptions {
    final data = apiFilterOptions.value;
    if (data == null || data.amenities.isEmpty) {
      return _fallbackAmenities;
    }

    return data.amenities.map((key) {
      String title = key;
      IconData icon = Icons.check_circle_outline_rounded;
      
      // Map keys to display titles and icons
      if (key == 'generator') {
        title = 'Generator';
        icon = Icons.flash_on_outlined;
      } else if (key == 'lift') {
        title = 'Lift';
        icon = Icons.elevator_outlined;
      } else if (key == 'parking') {
        title = 'Parking';
        icon = Icons.directions_car_outlined;
      } else if (key == 'gasLine') {
        title = 'Gas';
        icon = Icons.local_fire_department_outlined;
      } else if (key == 'water24_7') {
        title = 'Water 24/7';
        icon = Icons.water_drop_outlined;
      } else if (key == 'wifi') {
        title = 'WiFi';
        icon = Icons.wifi_rounded;
      }

      return {'title': title, 'key': key, 'icon': icon};
    }).toList();
  }

  List<Map<String, dynamic>> get propertyTypeOptions {
    final data = apiFilterOptions.value;
    final types = (data != null && data.propertyTypes.isNotEmpty) 
        ? data.propertyTypes 
        : _fallbackPropertyTypes;

    return types.map((type) {
      IconData icon = Icons.home_work_outlined;
      if (type == 'Family') icon = Icons.family_restroom_rounded;
      if (type == 'Bachelor') icon = Icons.person_outline_rounded;
      if (type == 'Sublet') icon = Icons.door_front_door_outlined;
      if (type == 'Seat') icon = Icons.bed_rounded;
      if (type == 'Office') icon = Icons.business_rounded;
      
      return {'title': type, 'icon': icon};
    }).toList();
  }

  List<String> get bedroomOptions {
    final data = apiFilterOptions.value;
    if (data != null && data.bedrooms.isNotEmpty) {
      return data.bedrooms.map((e) => e.toString()).toList();
    }
    return _fallbackBedrooms;
  }

  List<String> get furnishingOptions {
    final data = apiFilterOptions.value;
    return (data != null && data.furnishing.isNotEmpty)
        ? data.furnishing
        : _fallbackFurnishing;
  }

  List<String> get availabilityOptions {
    final data = apiFilterOptions.value;
    return (data != null && data.availability.isNotEmpty)
        ? data.availability
        : _fallbackAvailability;
  }


  // Empty means all availability.
  // final RxString selectedAvailability = ''.obs;

  // ============================================================
  // RESULT COUNT
  // ============================================================

  final RxInt matchingResultsCount = 0.obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    loadFilterOptions();
    _loadHomeLocation();
    
    // If we are on results screen and list is empty, load data
    if (Get.currentRoute == Routes.FILTER_RESULTS && filteredListings.isEmpty) {
      loadFilteredListings();
    }
  }

  /// Sync location from HomeController and reload results
  void syncAndLoad() {
    _loadHomeLocation();
    loadFilteredListings();
  }

  // ============================================================
  // LOAD HOME LOCATION
  // ============================================================

  void _loadHomeLocation() {
    if (!Get.isRegistered<HomeController>()) {
      return;
    }

    final homeCtrl = Get.find<HomeController>();
    String loc = homeCtrl.selectedLocation.value.trim();

    if (loc.isEmpty) {
      selectedCity.value = 'Khulna';
      selectedSubLocation.value = '';
      return;
    }

    List<String> parts = loc.split(',').map((e) => e.trim()).toList();
    if (parts.length >= 2) {
      String lastPart = parts.last;
      if (lastPart.toLowerCase() == 'bangladesh') {
        // "Khulna, Bangladesh" -> City: Khulna, Area: null
        selectedCity.value = parts.first;
        selectedSubLocation.value = '';
      } else {
        // "Sonadanga, Khulna" -> City: Khulna, Area: Sonadanga
        selectedCity.value = lastPart;
        selectedSubLocation.value = loc;
      }
    } else {
      selectedCity.value = loc;
      selectedSubLocation.value = '';
    }

    debugPrint(
      'FILTER LOCATION INITIALIZED: '
      'city=${selectedCity.value}, '
      'subLoc=${selectedSubLocation.value}',
    );
  }

  // ============================================================
  // LOAD FILTER OPTIONS
  // ============================================================

  Future<void> loadFilterOptions() async {
    try {
      isLoadingOptions.value = true;

      final response = await _listingsRepo.getFilterOptions();

      if (response.isSuccess) {
        final parsed = _listingsRepo.parseFilterOptionsResponse(response);

        if (parsed != null) {
          apiFilterOptions.value = parsed.data;

          // Update price range from backend.
          final apiMin = parsed.data.priceRange.min.toDouble();

          final apiMax = parsed.data.priceRange.max.toDouble();

          if (apiMin > 0 && apiMax > apiMin) {
            minPriceLimit.value = apiMin;
            maxPriceLimit.value = apiMax;

            priceRange.value = RangeValues(apiMin, apiMax);

            minPriceTextController.text = apiMin.round().toString();

            maxPriceTextController.text = apiMax.round().toString();

            debugPrint(
              'FILTER PRICE RANGE FROM API: '
              '$apiMin - $apiMax',
            );
          }
        }
      } else {
        debugPrint(
          'Failed to load filter options: '
          '${response.errorMessage}',
        );
      }
    } catch (e) {
      debugPrint('Error loading filter options: $e');
    } finally {
      isLoadingOptions.value = false;
    }
  }

  // ============================================================
  // AVAILABLE OPTIONS
  // ============================================================

  List<String> get availableCities {
    final data = apiFilterOptions.value;

    if (data != null && data.cities.isNotEmpty) {
      return data.cities;
    }

    return ['Khulna'];
  }

  List<String> get availableAreas {
    final data = apiFilterOptions.value;

    if (data != null && data.areas.isNotEmpty) {
      return data.areas;
    }

    return [
      'Sonadanga',
      'Boyra',
      'Khalishpur',
      'Daulatpur',
      'Gollamari',
      'Nirala',
      'Gallamari',
      'Mujgunni',
      'Shibbari',
      'Moylapota',
      'Royal Mor',
      'Dakbangla',
      'KDA Avenue',
      'Tutpara',
      'Rupsha',
      'Labonchora',
      'Banorgati',
      'Mistripara',
      'Boyra Bazar',
      'Housing Estate',
      'Phulbarigate',
      'Teligati',
      'KUET Area',
      'Zero Point',
      'Sheikh para',
    ];
  }

  List<String> get availablePropertyTypes {
    final data = apiFilterOptions.value;

    if (data != null && data.propertyTypes.isNotEmpty) {
      return data.propertyTypes;
    }

    return ['Bachelor', 'Family', 'Seat', 'Sublet', 'Office'];
  }

  List<String> get availableFurnishing {
    final data = apiFilterOptions.value;

    if (data != null && data.furnishing.isNotEmpty) {
      return data.furnishing;
    }

    return ['Furnished', 'Unfurnished', 'Semi'];
  }

  List<String> get availableAmenities {
    final data = apiFilterOptions.value;

    if (data != null && data.amenities.isNotEmpty) {
      return data.amenities;
    }

    return ['generator', 'lift', 'parking', 'gasLine', 'water24_7', 'wifi'];
  }

  List<String> get availableAvailability {
    final data = apiFilterOptions.value;

    if (data != null && data.availability.isNotEmpty) {
      return data.availability;
    }

    return ['Available now', 'From next month'];
  }

  // ============================================================
  // CITY
  // ============================================================

  void selectCity(String city) {
    selectedCity.value = city;
    _recalculateResults();
  }

  // ============================================================
  // AREA / LOCATION
  // ============================================================

  void selectSubLocation(String location) {
    selectedSubLocation.value = location;

    // Automatically extract city when location is:
    // "Boyra, Khulna"
    if (location.contains(',')) {
      selectedCity.value = location.split(',').last.trim();
    }

    _recalculateResults();
  }

  void clearSubLocation() {
    selectedSubLocation.value = '';
    _recalculateResults();
  }

  // ============================================================
  // PRICE
  // ============================================================

  void updatePriceRange(RangeValues values) {
    // Round to nearest 500 for a cleaner user experience
    double start = (values.start / 500).round() * 500.0;
    double end = (values.end / 500).round() * 500.0;

    start = start.clamp(minPriceLimit.value, maxPriceLimit.value);
    end = end.clamp(minPriceLimit.value, maxPriceLimit.value);

    if (start >= end) {
      if (start >= maxPriceLimit.value) {
        start = maxPriceLimit.value - 500;
      } else {
        end = start + 500;
      }
    }

    priceRange.value = RangeValues(start, end);

    minPriceTextController.text = start.round().toString();
    maxPriceTextController.text = end.round().toString();

    _recalculateResults();
  }

  void updateMinPrice(String text) {
    if (text.isEmpty) return;
    final val = double.tryParse(text);
    if (val == null) return;

    final max = priceRange.value.end;
    // We allow typing values below minLimit temporarily, but clamp for the slider
    final sliderVal = val.clamp(minPriceLimit.value, max - 100);
    priceRange.value = RangeValues(sliderVal.toDouble(), max);

    _recalculateResults();
  }

  void updateMaxPrice(String text) {
    if (text.isEmpty) return;
    final val = double.tryParse(text);
    if (val == null) return;

    final min = priceRange.value.start;
    // Clamp for the slider
    final sliderVal = val.clamp(min + 100, maxPriceLimit.value);
    priceRange.value = RangeValues(min, sliderVal.toDouble());

    _recalculateResults();
  }

  // ============================================================
  // PROPERTY TYPE
  // ============================================================

  void selectPropertyType(String type) {
    selectedPropertyType.value = type;

    // Dynamic price floor logic
    if (type == 'Family') {
      minPriceLimit.value = 5000;
    } else {
      minPriceLimit.value = 1000;
    }

    // Adjust current range if it falls below the new limit
    double currentStart = priceRange.value.start;
    double currentEnd = priceRange.value.end;

    if (currentStart < minPriceLimit.value) {
      currentStart = minPriceLimit.value;
      if (currentEnd <= currentStart) {
        currentEnd = currentStart + 500;
      }
    }

    priceRange.value = RangeValues(currentStart, currentEnd);
    minPriceTextController.text = currentStart.round().toString();
    maxPriceTextController.text = currentEnd.round().toString();

    _recalculateResults();
  }

  // ============================================================
  // BACHELOR GENDER
  // ============================================================

  void selectBachelorGender(String val) {
    selectedBachelorGender.value = val;
    _recalculateResults();
  }

  // ============================================================
  // BEDROOM
  // ============================================================

  void selectBedrooms(String val) {
    selectedBedrooms.value = val;
    _recalculateResults();
  }

  // ============================================================
  // FURNISHING
  // ============================================================

  void selectFurnishing(String val) {
    selectedFurnishing.value = val;
    _recalculateResults();
  }

  // ============================================================
  // AMENITIES
  // ============================================================

  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }

    _recalculateResults();
  }

  // ============================================================
  // AVAILABILITY
  // ============================================================

  void selectAvailability(String val) {
    selectedAvailability.value = val;
    _recalculateResults();
  }

  // ============================================================
  // CONVERT API MODEL -> ToLetItem
  // ============================================================

  ToLetItem _convertToToLetItem(ListingModel listing) {
    return listing.toToLetItem();
  }

  // ============================================================
  // LOAD FILTERED LISTINGS FROM API
  // ============================================================

  Future<void> loadFilteredListings() async {
    try {
      isLoadingResults.value = true;

      // ==========================================================
      // AREA
      // ==========================================================

      String? area;

      final location = selectedSubLocation.value.trim();

      if (location.isNotEmpty) {
        if (location.contains(',')) {
          area = location.split(',').first.trim();
        } else if (location != selectedCity.value) {
          area = location;
        }
      }

      // If area is same as city, don't send area filter
      if (area != null &&
          area.toLowerCase() == selectedCity.value.toLowerCase()) {
        area = null;
      }

      // ==========================================================
      // BEDROOMS
      // ==========================================================

      int? bedrooms;

      if (selectedBedrooms.value.trim().isNotEmpty) {
        if (selectedBedrooms.value == '4+') {
          bedrooms = 4;
        } else {
          bedrooms = int.tryParse(selectedBedrooms.value);
        }
      }

      // ==========================================================
      // FURNISHING
      // ==========================================================

      final String? furnishing = selectedFurnishing.value.trim().isEmpty
          ? null
          : selectedFurnishing.value.trim();

      // ==========================================================
      // AVAILABILITY
      // ==========================================================

      final String? availability = selectedAvailability.value.trim().isEmpty
          ? null
          : selectedAvailability.value.trim();

      // ==========================================================
      // AMENITIES
      // ==========================================================

      final Map<String, bool> amenities = {};

      for (final amenityKey in selectedAmenities) {
        amenities[amenityKey] = true;
      }

      // ==========================================================
      // CATEGORY
      // ==========================================================

      final String? category = selectedPropertyType.value.trim().isEmpty
          ? null
          : selectedPropertyType.value.trim();

      // ==========================================================
      // CITY
      // ==========================================================

      final String? city = selectedCity.value.trim().isEmpty
          ? null
          : selectedCity.value.trim();

      // ==========================================================
      // PRICE
      // ==========================================================

      final int minPrice = priceRange.value.start.round();

      final int maxPrice = priceRange.value.end.round();

      // ==========================================================
      // DEBUG
      // ==========================================================

      debugPrint('=================================================');
      debugPrint('              FILTER API REQUEST');
      debugPrint('=================================================');
      debugPrint('City: $city');
      debugPrint('Area: $area');
      debugPrint('Category: $category');
      debugPrint('Min Price: $minPrice');
      debugPrint('Max Price: $maxPrice');
      debugPrint('Bedrooms: $bedrooms');
      debugPrint('Furnishing: $furnishing');
      debugPrint('Availability: $availability');
      debugPrint('Amenities: $amenities');
      debugPrint('=================================================');

      // ==========================================================
      // API REQUEST
      // ==========================================================

      final response = await _listingsRepo.getAllListings(
        offset: 0,
        limit: 50,

        city: city,
        area: area,
        category: category,

        minPrice: minPrice,
        maxPrice: maxPrice,

        bedrooms: bedrooms,
        furnishing: furnishing,
        availability: availability,

        amenities: amenities.isEmpty ? null : amenities,
      );

      // ==========================================================
      // RESPONSE
      // ==========================================================

      if (!response.isSuccess) {
        filteredListings.clear();
        matchingResultsCount.value = 0;

        debugPrint(
          'Filter API error: '
          '${response.errorMessage}',
        );

        return;
      }

      final parsed = _listingsRepo.parseListingsResponse(response);

      if (parsed == null) {
        filteredListings.clear();
        matchingResultsCount.value = 0;

        debugPrint('Could not parse listings response.');

        return;
      }

      // ==========================================================
      // ASSIGN RESULTS
      // ==========================================================

      final results = parsed.data.map(_convertToToLetItem).toList();

      filteredListings.assignAll(results);

      matchingResultsCount.value = parsed.pagination.total;

      // ==========================================================
      // RESULT DEBUG
      // ==========================================================

      debugPrint('=================================================');
      debugPrint(
        'FILTER RESULT COUNT: '
        '${filteredListings.length}',
      );
      debugPrint(
        'API TOTAL: '
        '${parsed.pagination.total}',
      );
      debugPrint('=================================================');

      for (final item in filteredListings) {
        debugPrint(
          'Result: '
          '${item.category} | '
          '${item.title} | '
          '${item.location} | '
          '৳${item.price}',
        );
      }
    } catch (e) {
      filteredListings.clear();
      matchingResultsCount.value = 0;

      debugPrint('Error loading filtered listings: $e');
    } finally {
      isLoadingResults.value = false;
    }
  }

  // ============================================================
  // RESET FILTERS
  // ============================================================

  void resetFilters() {
    // Reset limits first
    minPriceLimit.value = 1000.0;
    maxPriceLimit.value = 100000.0;

    // Reset price range
    priceRange.value = RangeValues(minPriceLimit.value, maxPriceLimit.value);

    minPriceTextController.text = minPriceLimit.value.round().toString();
    maxPriceTextController.text = maxPriceLimit.value.round().toString();

    // RESET LOCATION to default city (No specific area)
    selectedSubLocation.value = '';
    // We keep the city but clear the specific area
    if (selectedCity.value.isEmpty) {
      selectedCity.value = 'Khulna';
    }

    // No property type selected.
    selectedPropertyType.value = '';

    // Bachelor gender.
    selectedBachelorGender.value = 'Any';

    // No bedroom filter.
    selectedBedrooms.value = '';

    // No furnishing filter.
    selectedFurnishing.value = '';

    // No amenities.
    selectedAmenities.clear();

    // No availability filter.
    selectedAvailability.value = '';

    // Clear previous results.
    filteredListings.clear();

    matchingResultsCount.value = 0;

    debugPrint('========== FILTERS RESET (Location cleared) ==========');
  }

  // ============================================================
  // LOCAL PREVIEW COUNT
  // ============================================================

  void _recalculateResults() {
    // Actual count comes from API after Apply.
    matchingResultsCount.value = filteredListings.length;
  }

  // ============================================================
  // APPLY FILTERS
  // ============================================================

  Future<void> applyFilters() async {
    debugPrint('========== APPLY FILTERS ==========');

    debugPrint(
      'Selected Category: '
      '${selectedPropertyType.value}',
    );

    debugPrint(
      'Selected City: '
      '${selectedCity.value}',
    );

    debugPrint(
      'Selected Area: '
      '${selectedSubLocation.value}',
    );

    debugPrint(
      'Price: '
      '${priceRange.value.start} - '
      '${priceRange.value.end}',
    );

    debugPrint(
      'Bedrooms: '
      '${selectedBedrooms.value}',
    );

    debugPrint(
      'Furnishing: '
      '${selectedFurnishing.value}',
    );

    debugPrint(
      'Availability: '
      '${selectedAvailability.value}',
    );

    debugPrint(
      'Amenities: '
      '${selectedAmenities.toList()}',
    );

    debugPrint('====================================');

    await loadFilteredListings();

    Get.toNamed(Routes.FILTER_RESULTS);
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {
    minPriceTextController.dispose();
    maxPriceTextController.dispose();

    super.onClose();
  }
}
