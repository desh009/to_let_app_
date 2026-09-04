class ToLetItem {
  final String id;
  final String title;
  final String location;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final double squareFeet;
  final String description;
  final String contactNumber;
  final List<String> images;
  final String category;
  final String badgeText;
  final bool isVerified;
  final bool isAvailable;
  final bool isFeatured;

  const ToLetItem({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.squareFeet,
    required this.description,
    required this.contactNumber,
    required this.images,
    this.category = 'Apartments',
    this.badgeText = 'Available now',
    this.isVerified = true,
    this.isAvailable = true,
    this.isFeatured = false,
  });
}
