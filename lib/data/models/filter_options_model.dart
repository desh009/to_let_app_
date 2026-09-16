class FilterOptionsResponse {
  final FilterOptionsData data;

  FilterOptionsResponse({required this.data});

  factory FilterOptionsResponse.fromJson(Map<String, dynamic> json) {
    return FilterOptionsResponse(
      data: FilterOptionsData.fromJson(json['data'] ?? {}),
    );
  }
}

class FilterOptionsData {
  final List<String> cities;
  final List<String> areas;
  final PriceRangeModel priceRange;
  final List<String> propertyTypes;
  final List<dynamic> bedrooms; // Can be int or String ("4+")
  final List<String> furnishing;
  final List<String> amenities;
  final List<String> availability;

  FilterOptionsData({
    required this.cities,
    required this.areas,
    required this.priceRange,
    required this.propertyTypes,
    required this.bedrooms,
    required this.furnishing,
    required this.amenities,
    required this.availability,
  });

  factory FilterOptionsData.fromJson(Map<String, dynamic> json) {
    return FilterOptionsData(
      cities: (json['cities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      areas: (json['areas'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      priceRange: PriceRangeModel.fromJson(json['priceRange'] ?? {}),
      propertyTypes: (json['propertyTypes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      bedrooms: (json['bedrooms'] as List<dynamic>?) ?? [],
      furnishing: (json['furnishing'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      availability: (json['availability'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class PriceRangeModel {
  final int min;
  final int max;

  PriceRangeModel({
    required this.min,
    required this.max,
  });

  factory PriceRangeModel.fromJson(Map<String, dynamic> json) {
    return PriceRangeModel(
      min: json['min'] ?? 0,
      max: json['max'] ?? 100000,
    );
  }
}
