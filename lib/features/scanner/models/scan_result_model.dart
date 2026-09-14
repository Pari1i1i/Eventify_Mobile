enum ScanStatus {
  success,
  duplicate,
  invalid,
}

class ScanResultModel {
  final ScanStatus status;
  final String message;
  final String ticketCode;
  final String? attendeeName;
  final String? attendeeEmail;
  final String? eventTitle;
  final String? tierName;
  final DateTime? checkInTime;

  ScanResultModel({
    required this.status,
    required this.message,
    required this.ticketCode,
    this.attendeeName,
    this.attendeeEmail,
    this.eventTitle,
    this.tierName,
    this.checkInTime,
  });

  bool get isSuccess => status == ScanStatus.success;
  bool get isDuplicate => status == ScanStatus.duplicate;
  bool get isInvalid => status == ScanStatus.invalid;

  factory ScanResultModel.fromJson(Map<String, dynamic> json, String scannedCode) {
    final statusStr = json['status']?.toString().toLowerCase() ?? '';
    final msg = json['message']?.toString() ?? '';
    
    ScanStatus parsedStatus = ScanStatus.invalid;
    if (statusStr == 'success' || statusStr == 'valid' || msg.toLowerCase().contains('berhasil') || msg.toLowerCase().contains('sukses')) {
      parsedStatus = ScanStatus.success;
    } else if (statusStr == 'duplicate' || statusStr == 'already_used' || msg.toLowerCase().contains('sudah') || msg.toLowerCase().contains('duplikat')) {
      parsedStatus = ScanStatus.duplicate;
    }

    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json['ticket'] is Map<String, dynamic>
            ? json['ticket'] as Map<String, dynamic>
            : json;

    return ScanResultModel(
      status: parsedStatus,
      message: msg.isNotEmpty ? msg : (parsedStatus == ScanStatus.success ? 'Check-in berhasil' : 'Kode tidak valid'),
      ticketCode: data['ticket_code']?.toString() ?? data['code']?.toString() ?? scannedCode,
      attendeeName: data['attendee_name']?.toString() ?? data['name']?.toString(),
      attendeeEmail: data['attendee_email']?.toString() ?? data['email']?.toString(),
      eventTitle: data['event_title']?.toString() ?? data['event']?['title']?.toString(),
      tierName: data['tier_name']?.toString() ?? data['ticket_tier']?['name']?.toString(),
      checkInTime: data['checked_in_at'] != null ? DateTime.tryParse(data['checked_in_at'].toString()) : DateTime.now(),
    );
  }
}
