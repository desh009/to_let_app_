class ListingsResponse {
  final List<ListingModel> data;
  final PaginationModel pagination;

  ListingsResponse({
    required this.data,
    required this.pagination,
  });

  factory ListingsResponse.fromJson(Map<String, dynamic> json) {
    return ListingsResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => ListingModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class ListingModel {
  final int id;
  final String title;
  final String location;
  final String city;
  final String? area;
  final int price;
  final int bedrooms;
  final int bathrooms;
  final String? imageUrl;
  final int? squareFeet;
  final String? description;
  final String contactNumber;
  final List<String> images;
  final String category;
  final String furnishing;
  final AmenitiesModel amenities;
  final String availability;
  final String? availableFrom;
  final bool isDirectOwner;
  final String? ownerId;
  final String? ownerName;
  final String? ownerEmail;
  final DateTime createdAt;
  final DateTime updatedAt;

  ListingModel({
    required this.id,
    required this.title,
    required this.location,
    required this.city,
    this.area,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    this.imageUrl,
    this.squareFeet,
    this.description,
    required this.contactNumber,
    required this.images,
    required this.category,
    required this.furnishing,
    required this.amenities,
    required this.availability,
    this.availableFrom,
    required this.isDirectOwner,
    this.ownerId,
    this.ownerName,
    this.ownerEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      area: json['area'],
      price: json['price'] ?? 0,
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      imageUrl: json['image_url'],
      squareFeet: json['square_feet'],
      description: json['description'],
      contactNumber: json['contact_number'] ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      category: json['category'] ?? '',
      furnishing: json['furnishing'] ?? '',
      amenities: AmenitiesModel.fromJson(json['amenities'] ?? {}),
      availability: json['availability'] ?? '',
      availableFrom: json['available_from'],
      isDirectOwner: json['is_direct_owner'] ?? false,
      ownerId: json['owner_id'],
      ownerName: json['owner_name'],
      ownerEmail: json['owner_email'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}

class AmenitiesModel {
  final bool lift;
  final bool wifi;
  final bool gasLine;
  final bool parking;
  final bool generator;
  final bool water247;

  AmenitiesModel({
    this.lift = false,
    this.wifi = false,
    this.gasLine = false,
    this.parking = false,
    this.generator = false,
    this.water247 = false,
  });

  factory AmenitiesModel.fromJson(Map<String, dynamic> json) {
    return AmenitiesModel(
      lift: json['lift'] ?? false,
      wifi: json['wifi'] ?? false,
      gasLine: json['gasLine'] ?? false,
      parking: json['parking'] ?? false,
      generator: json['generator'] ?? false,
      water247: json['water24_7'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lift': lift,
      'wifi': wifi,
      'gasLine': gasLine,
      'parking': parking,
      'generator': generator,
      'water24_7': water247,
    };
  }
}

class PaginationModel {
  final int total;
  final int offset;
  final int limit;
  final bool hasMore;

  PaginationModel({
    required this.total,
    required this.offset,
    required this.limit,
    required this.hasMore,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] ?? 0,
      offset: json['offset'] ?? 0,
      limit: json['limit'] ?? 20,
      hasMore: json['hasMore'] ?? false,
    );
  }
}
