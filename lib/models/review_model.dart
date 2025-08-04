class Review {
  final String id;
  final String userId;
  final String propertyId;
  final String bookingId;
  final double overallRating;
  final Map<String, double> categoryRatings;
  final String reviewText;
  final List<String> photos;
  final DateTime createdAt;
  final String guestName;
  final bool isVerifiedStay;

  Review({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.bookingId,
    required this.overallRating,
    required this.categoryRatings,
    required this.reviewText,
    required this.photos,
    required this.createdAt,
    required this.guestName,
    required this.isVerifiedStay,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'propertyId': propertyId,
      'bookingId': bookingId,
      'overallRating': overallRating,
      'categoryRatings': categoryRatings,
      'reviewText': reviewText,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
      'guestName': guestName,
      'isVerifiedStay': isVerifiedStay,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      propertyId: json['propertyId'],
      bookingId: json['bookingId'],
      overallRating: json['overallRating'].toDouble(),
      categoryRatings: Map<String, double>.from(json['categoryRatings']),
      reviewText: json['reviewText'],
      photos: List<String>.from(json['photos']),
      createdAt: DateTime.parse(json['createdAt']),
      guestName: json['guestName'],
      isVerifiedStay: json['isVerifiedStay'],
    );
  }
}
