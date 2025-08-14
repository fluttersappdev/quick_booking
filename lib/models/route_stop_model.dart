class RouteStop {
  final String id;
  final String name;
  final String time;
  final String status;
  final bool isActive;

  RouteStop({
    required this.id,
    required this.name,
    required this.time,
    required this.status,
    required this.isActive,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      id: json['id'],
      name: json['name'],
      time: json['time'],
      status: json['status'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'status': status,
      'isActive': isActive,
    };
  }
}