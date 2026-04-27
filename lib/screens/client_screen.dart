import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

// ═══════════════════════════════════════════════════════════════
// CLIENT SCREEN — lib/screens/client_screen.dart
// ═══════════════════════════════════════════════════════════════

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});
  @override State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _filterType = 'সব';
  final _serviceTypes = ['সব', 'জমি পরিমাপ', 'দলিল রেজিস্ট্রি', 'নামজারী', 'জমাভাগ', 'খতিয়ান সৃজন'];

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ক্লায়েন্ট তালিকা'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 26),
            onPressed: () => _openAddClient(context),
          ),
        ],
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          AppSearchBar(
            controller: _searchCtrl,
            hint: 'নাম, মৌজা বা দাগ নম্বর দিয়ে খুঁজুন...',
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          // Filter Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _serviceTypes.length,
              itemBuilder: (ctx, i) {
                final t = _serviceTypes[i];
                final isSelected = _filterType == t;
                return GestureDetector(
                  onTap: () => setState(() => _filterType = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.divider),
                    ),
                    child: Text(t,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                      )),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Client>>(
              stream: FirebaseService.getClients(
                searchQuery: _searchQuery,
                serviceType: _filterType,
              ),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final clients = snap.data ?? [];
                if (clients.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.people_outline,
                    title: 'কোনো ক্লায়েন্ট পাওয়া যায়নি',
                    subtitle: 'নতুন ক্লায়েন্ট যোগ করতে + বাটন ট্যাপ করুন',
                    buttonLabel: 'নতুন ক্লায়েন্ট',
                    onButtonTap: () => _openAddClient(context),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: clients.length,
                  itemBuilder: (ctx, i) => ClientListTile(
                    name: clients[i].name,
                    mouzaName: clients[i].mouzaName,
                    dagNumbers: clients[i].dagNumbers,
                    phone: clients[i].phone,
                    serviceType: clients[i].serviceType,
                    status: clients[i].status,
                    onTap: () => _openClientDetail(context, clients[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddClient(context),
        icon: const Icon(Icons.person_add_outlined),
        label: Text('নতুন ক্লায়েন্ট', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _openAddClient(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddClientScreen()));
  }

  void _openClientDetail(BuildContext context, Client client) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ClientDetailScreen(client: client)));
  }
}

// ═══════════════════════════════════════════════════════════════
// ADD CLIENT SCREEN
// ═══════════════════════════════════════════════════════════════

class AddClientScreen extends StatefulWidget {
  final Client? existing;
  const AddClientScreen({super.key, this.existing});
  @override State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _fatherCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _nidCtrl = TextEditingController();
  final _mouzaCtrl = TextEditingController();
  final _jlCtrl = TextEditingController();
  final _upazilaCtrl = TextEditingController();
  final _dagCtrl = TextEditingController();
  final _khatianCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _serviceType = 'জমি পরিমাপ';
  String _status = 'চলমান';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final c = widget.existing!;
      _nameCtrl.text = c.name;
      _fatherCtrl.text = c.fatherName;
      _phoneCtrl.text = c.phone;
      _addressCtrl.text = c.address;
      _nidCtrl.text = c.nidNumber;
      _mouzaCtrl.text = c.mouzaName;
      _jlCtrl.text = c.mouzaJL;
      _upazilaCtrl.text = c.upazila;
      _dagCtrl.text = c.dagNumbers;
      _khatianCtrl.text = c.khatianNumber;
      _areaCtrl.text = c.landArea;
      _notesCtrl.text = c.notes;
      _serviceType = c.serviceType;
      _status = c.status;
    }
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl,_fatherCtrl,_phoneCtrl,_addressCtrl,_nidCtrl,_mouzaCtrl,_jlCtrl,_upazilaCtrl,_dagCtrl,_khatianCtrl,_areaCtrl,_notesCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final client = Client(
        id: widget.existing?.id ?? '',
        name: _nameCtrl.text.trim(),
        fatherName: _fatherCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        nidNumber: _nidCtrl.text.trim(),
        mouzaName: _mouzaCtrl.text.trim(),
        mouzaJL: _jlCtrl.text.trim(),
        upazila: _upazilaCtrl.text.trim(),
        dagNumbers: _dagCtrl.text.trim(),
        khatianNumber: _khatianCtrl.text.trim(),
        landArea: _areaCtrl.text.trim(),
        serviceType: _serviceType,
        status: _status,
        notes: _notesCtrl.text.trim(),
        createdAt: widget.existing?.createdAt ?? DateTime.now(),
      );
      if (widget.existing != null) {
        await FirebaseService.updateClient(client);
      } else {
        await FirebaseService.addClient(client);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ক্লায়েন্ট সংরক্ষিত হয়েছে ✓')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ত্রুটি: $e'), backgroundColor: AppTheme.danger));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing != null ? 'ক্লায়েন্ট সম্পাদনা' : 'নতুন ক্লায়েন্ট'),
      ),
      backgroundColor: AppTheme.background,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            FormSectionCard(
              title: 'ব্যক্তিগত তথ্য',
              children: [
                AppFormField(label: 'পূর্ণ নাম', controller: _nameCtrl, hint: 'মো. রহিম উদ্দিন', isRequired: true),
                AppFormField(label: 'পিতার নাম', controller: _fatherCtrl, hint: 'পিতার নাম'),
                AppFormField(label: 'মোবাইল নম্বর', controller: _phoneCtrl, hint: '০১৭XXXXXXXX', keyboardType: TextInputType.phone, isRequired: true),
                AppFormField(label: 'ঠিকানা', controller: _addressCtrl, hint: 'গ্রাম, ইউনিয়ন, উপজেলা'),
                AppFormField(label: 'এনআইডি নম্বর', controller: _nidCtrl, hint: 'জাতীয় পরিচয়পত্র নম্বর', keyboardType: TextInputType.number),
              ],
            ),
            FormSectionCard(
              title: 'জমির তথ্য',
              children: [
                AppFormField(label: 'মৌজার নাম', controller: _mouzaCtrl, hint: 'মৌজার নাম', isRequired: true),
                Row(children: [
                  Expanded(child: AppFormField(label: 'মৌজা নম্বর (JL)', controller: _jlCtrl, hint: 'JL নং', keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: AppFormField(label: 'উপজেলা', controller: _upazilaCtrl, hint: 'উপজেলা')),
                ]),
                AppFormField(label: 'দাগ নম্বর(সমূহ)', controller: _dagCtrl, hint: 'যেমন: ৩৪৫, ৩৪৬, ৩৪৭'),
                Row(children: [
                  Expanded(child: AppFormField(label: 'খতিয়ান নম্বর', controller: _khatianCtrl, hint: 'খতিয়ান নং', keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: AppFormField(label: 'জমির পরিমাণ (শতাংশ)', controller: _areaCtrl, hint: 'শতাংশে', keyboardType: TextInputType.number)),
                ]),
              ],
            ),
            FormSectionCard(
              title: 'সেবার বিবরণ',
              children: [
                AppDropdownField(
                  label: 'সেবার ধরন',
                  value: _serviceType,
                  items: ['জমি পরিমাপ', 'দলিল রেজিস্ট্রি', 'নামজারী', 'জমাভাগ', 'খতিয়ান সৃজন', 'অন্যান্য'],
                  onChanged: (v) => setState(() => _serviceType = v!),
                ),
                AppDropdownField(
                  label: 'বর্তমান অবস্থা',
                  value: _status,
                  items: ['চলমান', 'সম্পন্ন', 'মুলতবি'],
                  onChanged: (v) => setState(() => _status = v!),
                ),
                AppFormField(label: 'বিশেষ নোট', controller: _notesCtrl, hint: 'গুরুত্বপূর্ণ তথ্য, রেফারেন্স নম্বর ইত্যাদি', maxLines: 3),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Text('সংরক্ষণ করুন', style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CLIENT DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════

class ClientDetailScreen extends StatelessWidget {
  final Client client;
  const ClientDetailScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(client.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => AddClientScreen(existing: client))),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // Header Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryLight]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                AvatarCircle(
                  text: client.initials,
                  bg: Colors.white.withOpacity(0.2),
                  fg: Colors.white, size: 56,
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(client.name, style: GoogleFonts.hindSiliguri(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(client.phone, style: GoogleFonts.hindSiliguri(fontSize: 14, color: Colors.white70)),
                  const SizedBox(height: 6),
                  StatusBadge(label: client.status, style: const BadgeStyle(Colors.white, AppTheme.primary)),
                ])),
              ],
            ),
          ),
          FormSectionCard(title: 'ব্যক্তিগত তথ্য', children: [
            InfoRow(label: 'পূর্ণ নাম', value: client.name),
            if (client.fatherName.isNotEmpty) InfoRow(label: 'পিতার নাম', value: client.fatherName),
            InfoRow(label: 'মোবাইল', value: client.phone),
            if (client.address.isNotEmpty) InfoRow(label: 'ঠিকানা', value: client.address),
            if (client.nidNumber.isNotEmpty) InfoRow(label: 'এনআইডি', value: client.nidNumber, isLast: true),
          ]),
          FormSectionCard(title: 'জমির তথ্য', children: [
            InfoRow(label: 'মৌজা', value: '${client.mouzaName} ${client.mouzaJL.isNotEmpty ? "(JL-${client.mouzaJL})" : ""}'),
            if (client.upazila.isNotEmpty) InfoRow(label: 'উপজেলা', value: client.upazila),
            if (client.dagNumbers.isNotEmpty) InfoRow(label: 'দাগ নম্বর', value: client.dagNumbers),
            if (client.khatianNumber.isNotEmpty) InfoRow(label: 'খতিয়ান নং', value: client.khatianNumber),
            if (client.landArea.isNotEmpty) InfoRow(label: 'জমির পরিমাণ', value: '${client.landArea} শতাংশ', isLast: true),
          ]),
          FormSectionCard(title: 'সেবার তথ্য', children: [
            InfoRow(label: 'সেবার ধরন', value: client.serviceType),
            InfoRow(label: 'অবস্থা', value: client.status),
            if (client.notes.isNotEmpty) InfoRow(label: 'নোট', value: client.notes, isLast: true),
          ]),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
