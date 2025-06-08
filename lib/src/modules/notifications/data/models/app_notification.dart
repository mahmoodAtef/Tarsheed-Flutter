class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String? imageUrl;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.imageUrl,
  });

  @override
  String toString() {
    return 'AppNotification(id: $id, title: $title, body: $body, timestamp: $timestamp, imageUrl: $imageUrl)';
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
