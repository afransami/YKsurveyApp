// ═══════════════════════════════════════════════════════════════
// MODELS — lib/models/models.dart
// ═══════════════════════════════════════════════════════════════

class Client {
  final String id;
  final String name;
  final String fatherName;
  final String phone;
  final String address;
  final String nidNumber;
  final String mouzaName;
  final String mouzaJL;
  final String upazila;
  final String dagNumbers;
  final String khatianNumber;
  final String landArea; // শতাংশ
  final String serviceType; // পরিমাপ, দলিল, নামজারী...
  final String status; // চলমান, সম্পন্ন, মুলতবি
  final String notes;
  final DateTime createdAt;
  final String createdBy;

  Client({
    required this.id,
    required this.name,
    this.fatherName = '',
    required this.phone,
    this.address = '',
    this.nidNumber = '',
    required this.mouzaName,
    this.mouzaJL = '',
    this.upazila = '',
    this.dagNumbers = '',
    this.khatianNumber = '',
    this.landArea = '',
    required this.serviceType,
    this.status = 'চলমান',
    this.notes = '',
    required this.createdAt,
    this.createdBy = '',
  });

  factory Client.fromMap(Map<String, dynamic> map, String docId) {
    return Client(
      id: docId,
      name: map['name'] ?? '',
      fatherName: map['fatherName'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      nidNumber: map['nidNumber'] ?? '',
      mouzaName: map['mouzaName'] ?? '',
      mouzaJL: map['mouzaJL'] ?? '',
      upazila: map['upazila'] ?? '',
      dagNumbers: map['dagNumbers'] ?? '',
      khatianNumber: map['khatianNumber'] ?? '',
      landArea: map['landArea'] ?? '',
      serviceType: map['serviceType'] ?? '',
      status: map['status'] ?? 'চলমান',
      notes: map['notes'] ?? '',
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'fatherName': fatherName,
    'phone': phone,
    'address': address,
    'nidNumber': nidNumber,
    'mouzaName': mouzaName,
    'mouzaJL': mouzaJL,
    'upazila': upazila,
    'dagNumbers': dagNumbers,
    'khatianNumber': khatianNumber,
    'landArea': landArea,
    'serviceType': serviceType,
    'status': status,
    'notes': notes,
    'createdAt': createdAt,
    'createdBy': createdBy,
  };

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return name.isNotEmpty ? name[0] : '?';
  }
}

// ─────────────────────────────────────────
class SurveySchedule {
  final String id;
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String mouzaName;
  final String dagNumber;
  final String scheduleType;
  final DateTime scheduledAt;
  final String notes;
  final String status; // নির্ধারিত, সম্পন্ন, বাতিল
  final String createdBy;

  SurveySchedule({
    required this.id,
    required this.clientId,
    required this.clientName,
    this.clientPhone = '',
    required this.mouzaName,
    this.dagNumber = '',
    required this.scheduleType,
    required this.scheduledAt,
    this.notes = '',
    this.status = 'নির্ধারিত',
    this.createdBy = '',
  });

  factory SurveySchedule.fromMap(Map<String, dynamic> map, String docId) {
    return SurveySchedule(
      id: docId,
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      clientPhone: map['clientPhone'] ?? '',
      mouzaName: map['mouzaName'] ?? '',
      dagNumber: map['dagNumber'] ?? '',
      scheduleType: map['scheduleType'] ?? '',
      scheduledAt: (map['scheduledAt'] as dynamic)?.toDate() ?? DateTime.now(),
      notes: map['notes'] ?? '',
      status: map['status'] ?? 'নির্ধারিত',
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'clientId': clientId,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'mouzaName': mouzaName,
    'dagNumber': dagNumber,
    'scheduleType': scheduleType,
    'scheduledAt': scheduledAt,
    'notes': notes,
    'status': status,
    'createdBy': createdBy,
  };

  bool get isToday {
    final now = DateTime.now();
    return scheduledAt.year == now.year &&
        scheduledAt.month == now.month &&
        scheduledAt.day == now.day;
  }

  bool get isPast => scheduledAt.isBefore(DateTime.now());
}

// ─────────────────────────────────────────
class DalilRecord {
  final String id;
  final String sellerName;
  final String buyerName;
  final String dalilNumber;
  final DateTime registryDate;
  final String mouzaName;
  final String dagNumber;
  final String khatianNumber;
  final String landArea;
  final double price;
  final String notes;
  final String status;
  final String createdBy;

  DalilRecord({
    required this.id,
    required this.sellerName,
    required this.buyerName,
    this.dalilNumber = '',
    required this.registryDate,
    required this.mouzaName,
    this.dagNumber = '',
    this.khatianNumber = '',
    this.landArea = '',
    this.price = 0,
    this.notes = '',
    this.status = 'চলমান',
    this.createdBy = '',
  });

  factory DalilRecord.fromMap(Map<String, dynamic> map, String docId) {
    return DalilRecord(
      id: docId,
      sellerName: map['sellerName'] ?? '',
      buyerName: map['buyerName'] ?? '',
      dalilNumber: map['dalilNumber'] ?? '',
      registryDate: (map['registryDate'] as dynamic)?.toDate() ?? DateTime.now(),
      mouzaName: map['mouzaName'] ?? '',
      dagNumber: map['dagNumber'] ?? '',
      khatianNumber: map['khatianNumber'] ?? '',
      landArea: map['landArea'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      notes: map['notes'] ?? '',
      status: map['status'] ?? 'চলমান',
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'sellerName': sellerName,
    'buyerName': buyerName,
    'dalilNumber': dalilNumber,
    'registryDate': registryDate,
    'mouzaName': mouzaName,
    'dagNumber': dagNumber,
    'khatianNumber': khatianNumber,
    'landArea': landArea,
    'price': price,
    'notes': notes,
    'status': status,
    'createdBy': createdBy,
  };
}

// ─────────────────────────────────────────
class NamjariCase {
  final String id;
  final String applicantName;
  final String applicantPhone;
  final String caseNumber;
  final DateTime filingDate;
  final DateTime? hearingDate;
  final String mouzaName;
  final String khatianNumber;
  final String dagNumber;
  final String caseType; // নামজারী, জমাভাগ
  final String status; // চলমান, সম্পন্ন, মুলতবি
  final String notes;
  final String createdBy;

  NamjariCase({
    required this.id,
    required this.applicantName,
    this.applicantPhone = '',
    this.caseNumber = '',
    required this.filingDate,
    this.hearingDate,
    required this.mouzaName,
    this.khatianNumber = '',
    this.dagNumber = '',
    this.caseType = 'নামজারী',
    this.status = 'চলমান',
    this.notes = '',
    this.createdBy = '',
  });

  factory NamjariCase.fromMap(Map<String, dynamic> map, String docId) {
    return NamjariCase(
      id: docId,
      applicantName: map['applicantName'] ?? '',
      applicantPhone: map['applicantPhone'] ?? '',
      caseNumber: map['caseNumber'] ?? '',
      filingDate: (map['filingDate'] as dynamic)?.toDate() ?? DateTime.now(),
      hearingDate: (map['hearingDate'] as dynamic)?.toDate(),
      mouzaName: map['mouzaName'] ?? '',
      khatianNumber: map['khatianNumber'] ?? '',
      dagNumber: map['dagNumber'] ?? '',
      caseType: map['caseType'] ?? 'নামজারী',
      status: map['status'] ?? 'চলমান',
      notes: map['notes'] ?? '',
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'applicantName': applicantName,
    'applicantPhone': applicantPhone,
    'caseNumber': caseNumber,
    'filingDate': filingDate,
    'hearingDate': hearingDate,
    'mouzaName': mouzaName,
    'khatianNumber': khatianNumber,
    'dagNumber': dagNumber,
    'caseType': caseType,
    'status': status,
    'notes': notes,
    'createdBy': createdBy,
  };

  bool get isHearingUrgent {
    if (hearingDate == null) return false;
    return hearingDate!.difference(DateTime.now()).inDays <= 3;
  }
}

// ─────────────────────────────────────────
class KhatianRecord {
  final String id;
  final String ownerName;
  final String mouzaName;
  final String mouzaJL;
  final String newKhatianNumber;
  final String oldKhatianNumber;
  final String dagNumbers;
  final String landClass; // বাড়ি, কৃষি, পুকুর...
  final String landArea;
  final String status;
  final String notes;
  final String createdBy;
  final DateTime createdAt;

  KhatianRecord({
    required this.id,
    required this.ownerName,
    required this.mouzaName,
    this.mouzaJL = '',
    this.newKhatianNumber = '',
    this.oldKhatianNumber = '',
    this.dagNumbers = '',
    this.landClass = 'কৃষি',
    this.landArea = '',
    this.status = 'চলমান',
    this.notes = '',
    this.createdBy = '',
    required this.createdAt,
  });

  factory KhatianRecord.fromMap(Map<String, dynamic> map, String docId) {
    return KhatianRecord(
      id: docId,
      ownerName: map['ownerName'] ?? '',
      mouzaName: map['mouzaName'] ?? '',
      mouzaJL: map['mouzaJL'] ?? '',
      newKhatianNumber: map['newKhatianNumber'] ?? '',
      oldKhatianNumber: map['oldKhatianNumber'] ?? '',
      dagNumbers: map['dagNumbers'] ?? '',
      landClass: map['landClass'] ?? 'কৃষি',
      landArea: map['landArea'] ?? '',
      status: map['status'] ?? 'চলমান',
      notes: map['notes'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'ownerName': ownerName,
    'mouzaName': mouzaName,
    'mouzaJL': mouzaJL,
    'newKhatianNumber': newKhatianNumber,
    'oldKhatianNumber': oldKhatianNumber,
    'dagNumbers': dagNumbers,
    'landClass': landClass,
    'landArea': landArea,
    'status': status,
    'notes': notes,
    'createdBy': createdBy,
    'createdAt': createdAt,
  };
}

// ─────────────────────────────────────────
class AdvancePayment {
  final String id;
  final String clientId;
  final String clientName;
  final String clientPhone;
  final double totalAmount;
  final double adjustedAmount;
  final DateTime receivedDate;
  final String workDescription;
  final String notes;
  final bool isSettled;
  final String createdBy;

  AdvancePayment({
    required this.id,
    required this.clientId,
    required this.clientName,
    this.clientPhone = '',
    required this.totalAmount,
    this.adjustedAmount = 0,
    required this.receivedDate,
    required this.workDescription,
    this.notes = '',
    this.isSettled = false,
    this.createdBy = '',
  });

  double get remainingAmount => totalAmount - adjustedAmount;
  bool get isPartiallySettled => adjustedAmount > 0 && !isSettled;

  factory AdvancePayment.fromMap(Map<String, dynamic> map, String docId) {
    return AdvancePayment(
      id: docId,
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      clientPhone: map['clientPhone'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      adjustedAmount: (map['adjustedAmount'] ?? 0).toDouble(),
      receivedDate: (map['receivedDate'] as dynamic)?.toDate() ?? DateTime.now(),
      workDescription: map['workDescription'] ?? '',
      notes: map['notes'] ?? '',
      isSettled: map['isSettled'] ?? false,
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'clientId': clientId,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'totalAmount': totalAmount,
    'adjustedAmount': adjustedAmount,
    'receivedDate': receivedDate,
    'workDescription': workDescription,
    'notes': notes,
    'isSettled': isSettled,
    'createdBy': createdBy,
  };
}

// ─────────────────────────────────────────
class KhajnaRecord {
  final String id;
  final String ownerName;
  final String ownerPhone;
  final String dakikaNumber;
  final DateTime paymentDate;
  final String mouzaName;
  final String khatianNumber;
  final double amount;
  final String fiscalYear;
  final String notes;
  final String createdBy;

  KhajnaRecord({
    required this.id,
    required this.ownerName,
    this.ownerPhone = '',
    this.dakikaNumber = '',
    required this.paymentDate,
    required this.mouzaName,
    this.khatianNumber = '',
    required this.amount,
    required this.fiscalYear,
    this.notes = '',
    this.createdBy = '',
  });

  factory KhajnaRecord.fromMap(Map<String, dynamic> map, String docId) {
    return KhajnaRecord(
      id: docId,
      ownerName: map['ownerName'] ?? '',
      ownerPhone: map['ownerPhone'] ?? '',
      dakikaNumber: map['dakikaNumber'] ?? '',
      paymentDate: (map['paymentDate'] as dynamic)?.toDate() ?? DateTime.now(),
      mouzaName: map['mouzaName'] ?? '',
      khatianNumber: map['khatianNumber'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      fiscalYear: map['fiscalYear'] ?? '',
      notes: map['notes'] ?? '',
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'ownerName': ownerName,
    'ownerPhone': ownerPhone,
    'dakikaNumber': dakikaNumber,
    'paymentDate': paymentDate,
    'mouzaName': mouzaName,
    'khatianNumber': khatianNumber,
    'amount': amount,
    'fiscalYear': fiscalYear,
    'notes': notes,
    'createdBy': createdBy,
  };
}

// ─────────────────────────────────────────
class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role; // admin, employee
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.role = 'employee',
    required this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'employee',
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'createdAt': createdAt,
  };
}
