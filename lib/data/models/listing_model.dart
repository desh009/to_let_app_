import '../../domain/entities/tolet_item.dart';

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
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      area: json['area']?.toString(),
      price: (json['price'] as num?)?.toInt() ?? 0,
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 0,
      imageUrl: json['image_url']?.toString(),
      squareFeet: (json['square_feet'] as num?)?.toInt(),
      description: json['description']?.toString(),
      contactNumber: json['contact_number']?.toString() ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      category: json['category']?.toString() ?? '',
      furnishing: json['furnishing']?.toString() ?? '',
      amenities: AmenitiesModel.fromJson(json['amenities']),
      availability: json['availability']?.toString() ?? '',
      availableFrom: json['available_from']?.toString(),
      isDirectOwner: json['is_direct_owner'] == true,
      ownerId: json['owner_id']?.toString(),
      ownerName: json['owner_name']?.toString(),
      ownerEmail: json['owner_email']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  ToLetItem toToLetItem() {
    String displayLocation = location;
    if (area != null && area!.isNotEmpty) {
      displayLocation = '$area, $city';
    } else if (displayLocation.isEmpty) {
      displayLocation = city;
    }

    final imagesList = images.isNotEmpty
        ? images
        : (imageUrl != null && imageUrl!.isNotEmpty
            ? [imageUrl!]
            : ['https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800']);

    return ToLetItem(
      id: id.toString(),
      title: title,
      location: displayLocation,
      price: price.toDouble(),
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      squareFeet: (squareFeet ?? 1000).toDouble(),
      description: description ?? '',
      contactNumber: contactNumber,
      ownerName: ownerName ?? 'Property Owner',
      images: imagesList,
      category: category.isNotEmpty ? category : 'Family',
      badgeText: availability.isNotEmpty ? availability : 'Available now',
      isVerified: isDirectOwner,
      isAvailable: availability == 'Available now',
      isFeatured: isDirectOwner || id <= 15,
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

  factory AmenitiesModel.fromJson(dynamic json) {
    if (json is! Map) {
      return AmenitiesModel();
    }
    return AmenitiesModel(
      lift: json['lift'] == true,
      wifi: json['wifi'] == true,
      gasLine: json['gasLine'] == true || json['gas_line'] == true,
      parking: json['parking'] == true,
      generator: json['generator'] == true,
      water247: json['water24_7'] == true || json['water247'] == true,
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
