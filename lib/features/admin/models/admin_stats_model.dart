class AdminDashboardStats {
  final int totalEvents;
  final int totalOrders;
  final int totalTicketsSold;
  final int totalAttendance;
  final num totalRevenue;

  AdminDashboardStats({
    required this.totalEvents,
    required this.totalOrders,
    required this.totalTicketsSold,
    required this.totalAttendance,
    required this.totalRevenue,
  });

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json['stats'] is Map<String, dynamic>
            ? json['stats'] as Map<String, dynamic>
            : json;

    return AdminDashboardStats(
      totalEvents: data['total_events'] is int
          ? data['total_events']
          : int.tryParse(data['total_events']?.toString() ?? '0') ?? 0,
      totalOrders: data['total_orders'] is int
          ? data['total_orders']
          : int.tryParse(data['total_orders']?.toString() ?? '0') ?? 0,
      totalTicketsSold: data['total_tickets_sold'] is int
          ? data['total_tickets_sold']
          : int.tryParse(data['total_tickets_sold']?.toString() ?? '0') ?? 0,
      totalAttendance: data['total_attendance'] is int
          ? data['total_attendance']
          : data['total_check_in'] is int
              ? data['total_check_in']
              : int.tryParse(data['total_attendance']?.toString() ?? data['total_check_in']?.toString() ?? '0') ?? 0,
      totalRevenue: data['total_revenue'] is num
          ? data['total_revenue']
          : num.tryParse(data['total_revenue']?.toString() ?? '0') ?? 0,
    );
  }
}
