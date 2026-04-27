import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/models.dart';

// ═══════════════════════════════════════════════════════════════
// FIREBASE SERVICE — lib/services/firebase_service.dart
// ═══════════════════════════════════════════════════════════════

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String get _uid => _auth.currentUser?.uid ?? '';

  // ─── Collection References ───────────────────────────────
  static CollectionReference get _clients => _db.collection('clients');
  static CollectionReference get _schedules => _db.collection('schedules');
  static CollectionReference get _dalils => _db.collection('dalils');
  static CollectionReference get _namjaris => _db.collection('namjaris');
  static CollectionReference get _khatians => _db.collection('khatians');
  static CollectionReference get _advances => _db.collection('advances');
  static CollectionReference get _khajnas => _db.collection('khajnas');
  static CollectionReference get _users => _db.collection('users');

  // ═══════════════════════════════════════════════════════════
  // AUTH
  // ═══════════════════════════════════════════════════════════

  static Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signOut() => _auth.signOut();

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<AppUser?> getCurrentUserProfile() async {
    if (_uid.isEmpty) return null;
    final doc = await _users.doc(_uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  static Future<void> saveUserProfile(AppUser user) {
    return _users.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  // ═══════════════════════════════════════════════════════════
  // CLIENTS
  // ═══════════════════════════════════════════════════════════

  static Future<String> addClient(Client client) async {
    final docRef = await _clients.add({
      ...client.toMap(),
      'createdBy': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  static Future<void> updateClient(Client client) {
    return _clients.doc(client.id).update(client.toMap());
  }

  static Future<void> deleteClient(String id) {
    return _clients.doc(id).delete();
  }

  static Stream<List<Client>> getClients({String? searchQuery, String? serviceType}) {
    Query query = _clients.orderBy('createdAt', descending: true);
    if (serviceType != null && serviceType != 'সব') {
      query = query.where('serviceType', isEqualTo: serviceType);
    }
    return query.snapshots().map((snap) {
      var clients = snap.docs.map((doc) =>
          Client.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        clients = clients.where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.mouzaName.toLowerCase().contains(q) ||
            c.dagNumbers.toLowerCase().contains(q) ||
            c.phone.contains(q)).toList();
      }
      return clients;
    });
  }

  static Future<Client?> getClientById(String id) async {
    final doc = await _clients.doc(id).get();
    if (!doc.exists) return null;
    return Client.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  // ═══════════════════════════════════════════════════════════
  // SCHEDULES
  // ═══════════════════════════════════════════════════════════

  static Future<String> addSchedule(SurveySchedule schedule) async {
    final docRef = await _schedules.add({
      ...schedule.toMap(),
      'createdBy': _uid,
    });
    return docRef.id;
  }

  static Future<void> updateSchedule(SurveySchedule schedule) {
    return _schedules.doc(schedule.id).update(schedule.toMap());
  }

  static Future<void> updateScheduleStatus(String id, String status) {
    return _schedules.doc(id).update({'status': status});
  }

  static Stream<List<SurveySchedule>> getUpcomingSchedules() {
    return _schedules
        .where('scheduledAt', isGreaterThanOrEqualTo: DateTime.now().subtract(const Duration(days: 1)))
        .orderBy('scheduledAt')
        .limit(50)
        .snapshots()
        .map((snap) => snap.docs.map((doc) =>
            SurveySchedule.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  static Stream<List<SurveySchedule>> getTodaySchedules() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59);
    return _schedules
        .where('scheduledAt', isGreaterThanOrEqualTo: start)
        .where('scheduledAt', isLessThanOrEqualTo: end)
        .orderBy('scheduledAt')
        .snapshots()
        .map((snap) => snap.docs.map((doc) =>
            SurveySchedule.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  // ═══════════════════════════════════════════════════════════
  // DALIL
  // ═══════════════════════════════════════════════════════════

  static Future<String> addDalil(DalilRecord dalil) async {
    final docRef = await _dalils.add({
      ...dalil.toMap(),
      'createdBy': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  static Future<void> updateDalil(DalilRecord dalil) {
    return _dalils.doc(dalil.id).update(dalil.toMap());
  }

  static Stream<List<DalilRecord>> getDalils({String? searchQuery}) {
    return _dalils.orderBy('registryDate', descending: true).snapshots().map((snap) {
      var list = snap.docs.map((doc) =>
          DalilRecord.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        list = list.where((d) =>
            d.sellerName.toLowerCase().contains(q) ||
            d.buyerName.toLowerCase().contains(q) ||
            d.mouzaName.toLowerCase().contains(q) ||
            d.dalilNumber.contains(q)).toList();
      }
      return list;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // NAMJARI
  // ═══════════════════════════════════════════════════════════

  static Future<String> addNamjari(NamjariCase namjari) async {
    final docRef = await _namjaris.add({
      ...namjari.toMap(),
      'createdBy': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  static Future<void> updateNamjari(NamjariCase namjari) {
    return _namjaris.doc(namjari.id).update(namjari.toMap());
  }

  static Stream<List<NamjariCase>> getNamjaris({String? searchQuery}) {
    return _namjaris.orderBy('filingDate', descending: true).snapshots().map((snap) {
      var list = snap.docs.map((doc) =>
          NamjariCase.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        list = list.where((n) =>
            n.applicantName.toLowerCase().contains(q) ||
            n.mouzaName.toLowerCase().contains(q) ||
            n.caseNumber.contains(q)).toList();
      }
      return list;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // KHATIAN
  // ═══════════════════════════════════════════════════════════

  static Future<String> addKhatian(KhatianRecord khatian) async {
    final docRef = await _khatians.add({
      ...khatian.toMap(),
      'createdBy': _uid,
    });
    return docRef.id;
  }

  static Stream<List<KhatianRecord>> getKhatians({String? searchQuery}) {
    return _khatians.orderBy('createdAt', descending: true).snapshots().map((snap) {
      var list = snap.docs.map((doc) =>
          KhatianRecord.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        list = list.where((k) =>
            k.ownerName.toLowerCase().contains(q) ||
            k.mouzaName.toLowerCase().contains(q) ||
            k.newKhatianNumber.contains(q)).toList();
      }
      return list;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // ADVANCE PAYMENTS
  // ═══════════════════════════════════════════════════════════

  static Future<String> addAdvance(AdvancePayment advance) async {
    final docRef = await _advances.add({
      ...advance.toMap(),
      'createdBy': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  static Future<void> updateAdvance(AdvancePayment advance) {
    return _advances.doc(advance.id).update(advance.toMap());
  }

  static Future<void> settleAdvance(String id, double adjustedAmount) {
    return _advances.doc(id).update({
      'adjustedAmount': adjustedAmount,
      'isSettled': true,
    });
  }

  static Stream<List<AdvancePayment>> getAdvances({bool pendingOnly = false}) {
    Query query = _advances.orderBy('receivedDate', descending: true);
    if (pendingOnly) {
      query = query.where('isSettled', isEqualTo: false);
    }
    return query.snapshots().map((snap) => snap.docs.map((doc) =>
        AdvancePayment.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  static Stream<double> getTotalPendingAdvance() {
    return _advances.where('isSettled', isEqualTo: false).snapshots().map((snap) {
      double total = 0;
      for (final doc in snap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        total += ((data['totalAmount'] ?? 0) - (data['adjustedAmount'] ?? 0)).toDouble();
      }
      return total;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // KHAJNA
  // ═══════════════════════════════════════════════════════════

  static Future<String> addKhajna(KhajnaRecord khajna) async {
    final docRef = await _khajnas.add({
      ...khajna.toMap(),
      'createdBy': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  static Stream<List<KhajnaRecord>> getKhajnas({String? searchQuery}) {
    return _khajnas.orderBy('paymentDate', descending: true).snapshots().map((snap) {
      var list = snap.docs.map((doc) =>
          KhajnaRecord.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        list = list.where((k) =>
            k.ownerName.toLowerCase().contains(q) ||
            k.mouzaName.toLowerCase().contains(q) ||
            k.dakikaNumber.contains(q)).toList();
      }
      return list;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // DASHBOARD STATS
  // ═══════════════════════════════════════════════════════════

  static Future<Map<String, int>> getDashboardStats() async {
    final results = await Future.wait([
      _clients.count().get(),
      _clients.where('status', isEqualTo: 'চলমান').count().get(),
      _schedules.where('scheduledAt',
          isGreaterThanOrEqualTo: DateTime.now()).count().get(),
      _advances.where('isSettled', isEqualTo: false).count().get(),
    ]);
    return {
      'totalClients': results[0].count ?? 0,
      'activeWork': results[1].count ?? 0,
      'upcomingSchedules': results[2].count ?? 0,
      'pendingAdvances': results[3].count ?? 0,
    };
  }
}
