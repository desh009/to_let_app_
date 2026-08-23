import '../../domain/entities/tolet_item.dart';

class ToLetModel extends ToLetItem {
  const ToLetModel({
    required super.id,
    required super.title,
    required super.location,
    required super.price,
    required super.bedrooms,
    required super.bathrooms,
    required super.squareFeet,
    required super.description,
    required super.contactNumber,
    required super.images,
    super.category = 'Family',
    super.badgeText = 'Available now',
    super.isVerified = true,
    super.isAvailable = true,
    super.isFeatured = false,
  });

  factory ToLetModel.fromJson(Map<String, dynamic> json) {
    return ToLetModel(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      price: (json['price'] as num).toDouble(),
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      squareFeet: (json['squareFeet'] as num).toDouble(),
      description: json['description'] as String,
      contactNumber: json['contactNumber'] as String,
      images: List<String>.from(json['images'] as List? ?? []),
      category: json['category'] as String? ?? 'Family',
      badgeText: json['badgeText'] as String? ?? 'Available now',
      isVerified: json['isVerified'] as bool? ?? true,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'price': price,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'squareFeet': squareFeet,
      'description': description,
      'contactNumber': contactNumber,
      'images': images,
      'category': category,
      'badgeText': badgeText,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
    };
  }

  // Sample data with Bangladesh To-Let categories: Family, Bachelor, Sublet, Seat
  static List<ToLetModel> get sampleData => [
    const ToLetModel(
      id: '1',
      title: 'Modern 3-BHK Family Flat in Gulshan 2',
      location: 'Gulshan 2 · Dhaka',
      price: 32000,
      bedrooms: 3,
      bathrooms: 3,
      squareFeet: 1650,
      description:
          'Spacious family flat with south-facing balcony, generator backup, lift, dedicated car parking, and 24/7 security guard.',
      contactNumber: '+8801711223344',
      images: [
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      ],
      category: 'Family',
      badgeText: 'Available now',
      isVerified: true,
      isFeatured: true,
    ),
    const ToLetModel(
      id: '2',
      title: 'Bachelor 2-BHK Shared Flat in Banani',
      location: 'Banani · Dhaka',
      price: 24000,
      bedrooms: 2,
      bathrooms: 2,
      squareFeet: 1150,
      description:
          'Bachelor friendly flat for job holders / students. No gate lock restrictions, high-speed WiFi, meal system, and helper available.',
      contactNumber: '+8801811556677',
      images: [
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
      ],
      category: 'Bachelor',
      badgeText: 'Verified',
      isVerified: true,
      isFeatured: true,
    ),
    const ToLetModel(
      id: '3',
      title: 'Furnished Master Bed Sublet in Dhanmondi',
      location: 'Road 8A, Dhanmondi · Dhaka',
      price: 12500,
      bedrooms: 1,
      bathrooms: 1,
      squareFeet: 450,
      description:
          'Master bed with attached bathroom and balcony for a female student / small family sublet in a quiet residential apartment.',
      contactNumber: '+8801911998877',
      images: [
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
      ],
      category: 'Sublet',
      badgeText: 'Available now',
      isVerified: true,
      isFeatured: false,
    ),
    const ToLetModel(
      id: '4',
      title: 'Single Seat in 2-Bed Bachelor Room',
      location: 'Block C, Bashundhara R/A · Dhaka',
      price: 4500,
      bedrooms: 1,
      bathrooms: 1,
      squareFeet: 250,
      description:
          '1 Seat available in 2-bed room for university students (NSU/IUB/AIUB). Includes bed, reading table, WiFi, water filter, and electricity.',
      contactNumber: '+8801611334455',
      images: [
        'https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=800',
      ],
      category: 'Seat',
      badgeText: 'Verified',
      isVerified: true,
      isFeatured: false,
    ),
    const ToLetModel(
      id: '5',
      title: 'Luxury 4-BHK Family Apartment in Uttara',
      location: 'Sector 4, Uttara · Dhaka',
      price: 48000,
      bedrooms: 4,
      bathrooms: 4,
      squareFeet: 2200,
      description:
          'Exclusive corner apartment with 3 wide balconies, modular kitchen, gas connection, and full building CCTV surveillance.',
      contactNumber: '+8801511778899',
      images: [
        'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      ],
      category: 'Family',
      badgeText: 'Available now',
      isVerified: true,
      isFeatured: false,
    ),
  ];
}
