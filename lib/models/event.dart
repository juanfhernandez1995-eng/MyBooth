class BoothEvent {
  final String id;
  final String eventName;
  final String customerName;
  final String customerEmail;
  final String occasion;
  final DateTime eventDate;
  final String photoLayout;
  final int printCopies;
  final bool guestUploadsEnabled;
  final bool sendGalleryTomorrow;

  BoothEvent({
    required this.id,
    required this.eventName,
    required this.customerName,
    required this.customerEmail,
    required this.occasion,
    required this.eventDate,
    required this.photoLayout,
    required this.printCopies,
    required this.guestUploadsEnabled,
    required this.sendGalleryTomorrow,
  });

  String get displayDate {
    return "${eventDate.month}/${eventDate.day}/${eventDate.year}";
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "eventName": eventName,
      "customerName": customerName,
      "customerEmail": customerEmail,
      "occasion": occasion,
      "eventDate": eventDate.toIso8601String(),
      "photoLayout": photoLayout,
      "printCopies": printCopies,
      "guestUploadsEnabled": guestUploadsEnabled,
      "sendGalleryTomorrow": sendGalleryTomorrow,
    };
  }

  factory BoothEvent.fromJson(Map<String, dynamic> json) {
    return BoothEvent(
      id: json["id"],
      eventName: json["eventName"],
      customerName: json["customerName"],
      customerEmail: json["customerEmail"],
      occasion: json["occasion"],
      eventDate: DateTime.parse(json["eventDate"]),
      photoLayout: json["photoLayout"],
      printCopies: json["printCopies"],
      guestUploadsEnabled: json["guestUploadsEnabled"],
      sendGalleryTomorrow: json["sendGalleryTomorrow"],
    );
  }
}