import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingType {
  escort, // Market escort service
  search, // Search for items
  purchase, // Purchase and delivery
  translation, // Translation and negotiation
}

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class Booking {
  final String? id;
  final String userId;
  final String agentId;
  final BookingType type;
  final BookingStatus status;
  final String title;
  final String description;
  final DateTime scheduledDate;
  final String location;
  final GeoPoint? locationCoordinates;
  final double estimatedHours;
  final double totalCost;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  Booking({
    this.id,
    required this.userId,
    required this.agentId,
    required this.type,
    required this.status,
    required this.title,
    required this.description,
    required this.scheduledDate,
    required this.location,
    this.locationCoordinates,
    required this.estimatedHours,
    required this.totalCost,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Booking(
      id: doc.id,
      userId: data['userId'] ?? '',
      agentId: data['agentId'] ?? '',
      type: BookingType.values.firstWhere(
        (e) => e.toString() == 'BookingType.${data['type']}',
        orElse: () => BookingType.escort,
      ),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${data['status']}',
        orElse: () => BookingStatus.pending,
      ),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      scheduledDate: (data['scheduledDate'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      locationCoordinates: data['locationCoordinates'],
      estimatedHours: (data['estimatedHours'] ?? 0.0).toDouble(),
      totalCost: (data['totalCost'] ?? 0.0).toDouble(),
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'agentId': agentId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'title': title,
      'description': description,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'location': location,
      'locationCoordinates': locationCoordinates,
      'estimatedHours': estimatedHours,
      'totalCost': totalCost,
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
