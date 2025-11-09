import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final String bio;
  final List<String> languages;
  final List<String> specialties; // e.g., electronics, clothing, food
  final double rating;
  final int totalReviews;
  final bool verified;
  final bool available;
  final GeoPoint location;
  final String city;
  final String country;
  final double hourlyRate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.bio,
    required this.languages,
    required this.specialties,
    required this.rating,
    required this.totalReviews,
    required this.verified,
    required this.available,
    required this.location,
    required this.city,
    required this.country,
    required this.hourlyRate,
    required this.createdAt,
    this.updatedAt,
  });

  factory Agent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Agent(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      bio: data['bio'] ?? '',
      languages: List<String>.from(data['languages'] ?? []),
      specialties: List<String>.from(data['specialties'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      verified: data['verified'] ?? false,
      available: data['available'] ?? false,
      location: data['location'] ?? const GeoPoint(0, 0),
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      hourlyRate: (data['hourlyRate'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'languages': languages,
      'specialties': specialties,
      'rating': rating,
      'totalReviews': totalReviews,
      'verified': verified,
      'available': available,
      'location': location,
      'city': city,
      'country': country,
      'hourlyRate': hourlyRate,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
