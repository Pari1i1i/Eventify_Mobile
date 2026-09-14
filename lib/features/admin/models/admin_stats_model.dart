class AdminDashboardStats {
  final int totalEvents;
  final int publishedEvents;
  final int totalOrders;
  final int paidOrders;
  final int totalTicketsSold;
  final int totalAttendance;
  final num totalRevenue;

  AdminDashboardStats({
    required this.totalEvents,
    this.publishedEvents = 0,
    required this.totalOrders,
    this.paidOrders = 0,
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
      publishedEvents: data['published_events'] is int
          ? data['published_events']
          : int.tryParse(data['published_events']?.toString() ?? '0') ?? 0,
      totalOrders: data['total_orders'] is int
          ? data['total_orders']
          : int.tryParse(data['total_orders']?.toString() ?? '0') ?? 0,
      paidOrders: data['paid_orders'] is int
          ? data['paid_orders']
          : int.tryParse(data['paid_orders']?.toString() ?? '0') ?? 0,
      totalTicketsSold: data['total_tickets_sold'] is int
          ? data['total_tickets_sold']
          : int.tryParse(data['total_tickets_sold']?.toString() ?? '0') ?? 0,
      totalAttendance: data['total_checked_in'] is int
          ? data['total_checked_in']
          : data['total_attendance'] is int
              ? data['total_attendance']
              : int.tryParse(data['total_checked_in']?.toString() ?? data['total_attendance']?.toString() ?? '0') ?? 0,
      totalRevenue: data['total_revenue'] is num
          ? data['total_revenue']
          : num.tryParse(data['total_revenue']?.toString() ?? '0') ?? 0,
    );
  }
}
