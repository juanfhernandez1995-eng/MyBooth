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
}