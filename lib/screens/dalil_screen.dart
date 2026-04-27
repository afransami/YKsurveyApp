import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

// ═══════════════════════════════════════════════════════════════
// DALIL SCREEN — lib/screens/dalil_screen.dart
// ═══════════════════════════════════════════════════════════════

class DalilScreen extends StatefulWidget {
  const DalilScreen({super.key});
  @override State<DalilScreen> createState() => _DalilScreenState();
}

class _DalilScreenState extends State<DalilScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('দলিল ও নামজারী'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: GoogleFonts.hindSiliguri(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.hindSiliguri(fontSize: 13),
          tabs: const [
            Tab(text: 'দলিল রেজিস্ট্রি'),
            Tab(text: 'নামজারী'),
            Tab(text: 'খতিয়ান সৃজন'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _DalilTab(),
          _NamjariTab(),
          _KhatianTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final idx = _tabController.index;
          Navigator.push(context, MaterialPageRoute(builder: (_) =>
            idx == 0 ? const AddDalilScreen() :
            idx == 1 ? const AddNamjariScreen() :
            const AddKhatianScreen(),
          ));
        },
        icon: const Icon(Icons.add),
        label: Text('নতুন যোগ', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ─── Dalil Tab ────────────────────────────────────────────────
class _DalilTab extends StatefulWidget {
  const _DalilTab();
  @override State<_DalilTab> createState() => _DalilTabState();
}

class _DalilTabState extends State<_DalilTab> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppSearchBar(controller: _searchCtrl, hint: 'বিক্রেতা, ক্রেতা বা দলিল নম্বর...', onChanged: (v) => setState(() => _searchQuery = v)),
      Expanded(
        child: StreamBuilder<List<DalilRecord>>(
          stream: FirebaseService.getDalils(searchQuery: _searchQuery),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final list = snap.data ?? [];
            if (list.isEmpty) return const EmptyStateWidget(icon: Icons.description_outlined, title: 'কোনো দলিল নেই', subtitle: 'নতুন দলিল রেজিস্ট্রি যোগ করুন');
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              itemCount: list.length,
              itemBuilder: (ctx, i) => _DalilTile(dalil: list[i]),
            );
          },
        ),
      ),
    ]);
  }
}

class _DalilTile extends StatelessWidget {
  final DalilRecord dalil;
  const _DalilTile({required this.dalil});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.tealLight, borderRadius: BorderRadius.circular(6)),
            child: Text('দলিল #${dalil.dalilNumber}', style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.teal, fontWeight: FontWeight.w600)),
          ),
          const Spacer(),
          StatusBadge.forStatus(dalil.status),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _Party(label: 'বিক্রেতা', name: dalil.sellerName, isLeft: true)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppTheme.primarySurface, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward, size: 16, color: AppTheme.primary),
          ),
          Expanded(child: _Party(label: 'ক্রেতা', name: dalil.buyerName, isLeft: false)),
        ]),
        const Divider(height: 16),
        Row(children: [
          const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textHint),
          const SizedBox(width: 4),
          Text('${dalil.mouzaName} মৌজা${dalil.dagNumber.isNotEmpty ? " • দাগ: ${dalil.dagNumber}" : ""}',
            style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary)),
          const Spacer(),
          if (dalil.landArea.isNotEmpty)
            Text('${dalil.landArea} শতাংশ', style: GoogleFonts.hindSiliguri(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primary)),
        ]),
        if (dalil.price > 0) ...[
          const SizedBox(height: 4),
          Text('মূল্য: ৳ ${dalil.price.toStringAsFixed(0)}',
            style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ]),
    );
  }
}

class _Party extends StatelessWidget {
  final String label, name;
  final bool isLeft;
  const _Party({required this.label, required this.name, required this.isLeft});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
    children: [
      Text(label, style: GoogleFonts.hindSiliguri(fontSize: 11, color: AppTheme.textHint)),
      const SizedBox(height: 2),
      Text(name, style: GoogleFonts.hindSiliguri(fontSize: 13, fontWeight: FontWeight.w600), textAlign: isLeft ? TextAlign.left : TextAlign.right),
    ],
  );
}

// ─── Namjari Tab ──────────────────────────────────────────────
class _NamjariTab extends StatefulWidget {
  const _NamjariTab();
  @override State<_NamjariTab> createState() => _NamjariTabState();
}

class _NamjariTabState extends State<_NamjariTab> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppSearchBar(controller: _searchCtrl, hint: 'আবেদনকারী বা মামলা নম্বর...', onChanged: (v) => setState(() => _searchQuery = v)),
      Expanded(
        child: StreamBuilder<List<NamjariCase>>(
          stream: FirebaseService.getNamjaris(searchQuery: _searchQuery),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final list = snap.data ?? [];
            if (list.isEmpty) return const EmptyStateWidget(icon: Icons.gavel_outlined, title: 'কোনো নামজারী মামলা নেই', subtitle: 'নতুন নামজারী/জমাভাগ মামলা যোগ করুন');
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              itemCount: list.length,
              itemBuilder: (ctx, i) => _NamjariTile(c: list[i]),
            );
          },
        ),
      ),
    ]);
  }
}

class _NamjariTile extends StatelessWidget {
  final NamjariCase c;
  const _NamjariTile({required this.c});

  @override
  Widget build(BuildContext context) {
    final isUrgent = c.isHearingUrgent;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUrgent ? AppTheme.dangerLight : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isUrgent ? AppTheme.danger.withOpacity(0.3) : AppTheme.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          AvatarCircle(text: c.applicantName.isNotEmpty ? c.applicantName[0] : '?', bg: AppTheme.purpleLight, fg: AppTheme.purple, size: 40),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.applicantName, style: GoogleFonts.hindSiliguri(fontSize: 14, fontWeight: FontWeight.w600)),
            Text('মামলা #${c.caseNumber}', style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary)),
          ])),
          StatusBadge(label: c.caseType, style: AppBadges.namjari),
        ]),
        const Divider(height: 16),
        Row(children: [
          const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textHint),
          const SizedBox(width: 4),
          Text('${c.mouzaName} মৌজা', style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary)),
          const Spacer(),
          StatusBadge.forStatus(c.status),
        ]),
        if (c.hearingDate != null) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isUrgent ? AppTheme.danger.withOpacity(0.1) : AppTheme.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.event, size: 14, color: isUrgent ? AppTheme.danger : AppTheme.primary),
              const SizedBox(width: 6),
              Text(
                'শুনানি: ${c.hearingDate!.day}/${c.hearingDate!.month}/${c.hearingDate!.year}',
                style: GoogleFonts.hindSiliguri(fontSize: 12, fontWeight: FontWeight.w500, color: isUrgent ? AppTheme.danger : AppTheme.primary),
              ),
              if (isUrgent) ...[const SizedBox(width: 6), Text('⚠ জরুরি', style: GoogleFonts.hindSiliguri(fontSize: 11, color: AppTheme.danger))],
            ]),
          ),
        ],
      ]),
    );
  }
}

// ─── Khatian Tab ──────────────────────────────────────────────
class _KhatianTab extends StatefulWidget {
  const _KhatianTab();
  @override State<_KhatianTab> createState() => _KhatianTabState();
}

class _KhatianTabState extends State<_KhatianTab> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppSearchBar(controller: _searchCtrl, hint: 'মালিক বা মৌজার নাম...', onChanged: (v) => setState(() => _searchQuery = v)),
      Expanded(
        child: StreamBuilder<List<KhatianRecord>>(
          stream: FirebaseService.getKhatians(searchQuery: _searchQuery),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final list = snap.data ?? [];
            if (list.isEmpty) return const EmptyStateWidget(icon: Icons.receipt_outlined, title: 'কোনো খতিয়ান নেই', subtitle: 'নতুন খতিয়ান সৃজন রেকর্ড যোগ করুন');
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              itemCount: list.length,
              itemBuilder: (ctx, i) => _KhatianTile(k: list[i]),
            );
          },
        ),
      ),
    ]);
  }
}

class _KhatianTile extends StatelessWidget {
  final KhatianRecord k;
  const _KhatianTile({required this.k});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.divider)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(k.ownerName, style: GoogleFonts.hindSiliguri(fontSize: 15, fontWeight: FontWeight.w600))),
          StatusBadge.forStatus(k.status),
        ]),
        const SizedBox(height: 8),
        Wrap(spacing: 12, runSpacing: 6, children: [
          _KhatianChip(label: 'মৌজা', value: k.mouzaName),
          if (k.newKhatianNumber.isNotEmpty) _KhatianChip(label: 'নতুন খতিয়ান', value: k.newKhatianNumber),
          if (k.oldKhatianNumber.isNotEmpty) _KhatianChip(label: 'পুরনো খতিয়ান', value: k.oldKhatianNumber),
          if (k.dagNumbers.isNotEmpty) _KhatianChip(label: 'দাগ', value: k.dagNumbers),
          if (k.landArea.isNotEmpty) _KhatianChip(label: 'পরিমাণ', value: '${k.landArea} শতাংশ'),
          _KhatianChip(label: 'শ্রেণি', value: k.landClass),
        ]),
      ]),
    );
  }
}

class _KhatianChip extends StatelessWidget {
  final String label, value;
  const _KhatianChip({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Text('$label: ', style: GoogleFonts.hindSiliguri(fontSize: 11, color: AppTheme.textHint)),
    Text(value, style: GoogleFonts.hindSiliguri(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
  ]);
}

// ═══════════════════════════════════════════════════════════════
// ADD DALIL SCREEN
// ═══════════════════════════════════════════════════════════════

class AddDalilScreen extends StatefulWidget {
  const AddDalilScreen({super.key});
  @override State<AddDalilScreen> createState() => _AddDalilScreenState();
}

class _AddDalilScreenState extends State<AddDalilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sellerCtrl = TextEditingController();
  final _buyerCtrl = TextEditingController();
  final _dalilNoCtrl = TextEditingController();
  final _mouzaCtrl = TextEditingController();
  final _dagCtrl = TextEditingController();
  final _khatianCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime _registryDate = DateTime.now();
  String _status = 'চলমান';
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_sellerCtrl,_buyerCtrl,_dalilNoCtrl,_mouzaCtrl,_dagCtrl,_khatianCtrl,_areaCtrl,_priceCtrl,_notesCtrl]) c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final dalil = DalilRecord(
        id: '', sellerName: _sellerCtrl.text.trim(), buyerName: _buyerCtrl.text.trim(),
        dalilNumber: _dalilNoCtrl.text.trim(), registryDate: _registryDate,
        mouzaName: _mouzaCtrl.text.trim(), dagNumber: _dagCtrl.text.trim(),
        khatianNumber: _khatianCtrl.text.trim(), landArea: _areaCtrl.text.trim(),
        price: double.tryParse(_priceCtrl.text) ?? 0, notes: _notesCtrl.text.trim(), status: _status,
      );
      await FirebaseService.addDalil(dalil);
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('দলিল সংরক্ষিত হয়েছে ✓'))); Navigator.pop(context); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ত্রুটি: $e'), backgroundColor: AppTheme.danger));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন দলিল রেজিস্ট্রি')),
      backgroundColor: AppTheme.background,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            FormSectionCard(title: 'ক্রেতা ও বিক্রেতা', children: [
              AppFormField(label: 'বিক্রেতার নাম', controller: _sellerCtrl, hint: 'বিক্রেতার পূর্ণ নাম', isRequired: true),
              AppFormField(label: 'ক্রেতার নাম', controller: _buyerCtrl, hint: 'ক্রেতার পূর্ণ নাম', isRequired: true),
            ]),
            FormSectionCard(title: 'দলিলের তথ্য', children: [
              Row(children: [
                Expanded(child: AppFormField(label: 'দলিল নম্বর', controller: _dalilNoCtrl, hint: 'দলিল নং', keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final d = await showDatePicker(context: context, initialDate: _registryDate, firstDate: DateTime(2000), lastDate: DateTime(2030));
                      if (d != null) setState(() => _registryDate = d);
                    },
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('রেজিস্ট্রির তারিখ', style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                        decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
                        child: Row(children: [
                          const Icon(Icons.calendar_today, size: 16, color: AppTheme.primary),
                          const SizedBox(width: 8),
                          Text('${_registryDate.day}/${_registryDate.month}/${_registryDate.year}', style: GoogleFonts.hindSiliguri(fontSize: 13)),
                        ]),
                      ),
                    ]),
                  ),
                ),
              ]),
              AppFormField(label: 'মৌজার নাম', controller: _mouzaCtrl, hint: 'মৌজা', isRequired: true),
              Row(children: [
                Expanded(child: AppFormField(label: 'দাগ নম্বর', controller: _dagCtrl, hint: 'দাগ নং')),
                const SizedBox(width: 12),
                Expanded(child: AppFormField(label: 'খতিয়ান নম্বর', controller: _khatianCtrl, hint: 'খতিয়ান নং')),
              ]),
              Row(children: [
                Expanded(child: AppFormField(label: 'জমির পরিমাণ (শতাংশ)', controller: _areaCtrl, hint: 'শতাংশ', keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: AppFormField(label: 'বিক্রয় মূল্য (৳)', controller: _priceCtrl, hint: 'টাকা', keyboardType: TextInputType.number)),
              ]),
              AppDropdownField(label: 'অবস্থা', value: _status, items: ['চলমান', 'সম্পন্ন', 'মুলতবি'], onChanged: (v) => setState(() => _status = v!)),
              AppFormField(label: 'নোট', controller: _notesCtrl, hint: 'অতিরিক্ত তথ্য...', maxLines: 3),
            ]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(height: 52, child: ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : Text('সংরক্ষণ করুন', style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.w600)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADD NAMJARI SCREEN
// ═══════════════════════════════════════════════════════════════

class AddNamjariScreen extends StatefulWidget {
  const AddNamjariScreen({super.key});
  @override State<AddNamjariScreen> createState() => _AddNamjariScreenState();
}

class _AddNamjariScreenState extends State<AddNamjariScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _caseNoCtrl = TextEditingController();
  final _mouzaCtrl = TextEditingController();
  final _khatianCtrl = TextEditingController();
  final _dagCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime _filingDate = DateTime.now();
  DateTime? _hearingDate;
  String _caseType = 'নামজারী';
  String _status = 'চলমান';
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_nameCtrl,_phoneCtrl,_caseNoCtrl,_mouzaCtrl,_khatianCtrl,_dagCtrl,_notesCtrl]) c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final namjari = NamjariCase(
        id: '', applicantName: _nameCtrl.text.trim(), applicantPhone: _phoneCtrl.text.trim(),
        caseNumber: _caseNoCtrl.text.trim(), filingDate: _filingDate, hearingDate: _hearingDate,
        mouzaName: _mouzaCtrl.text.trim(), khatianNumber: _khatianCtrl.text.trim(),
        dagNumber: _dagCtrl.text.trim(), caseType: _caseType, status: _status, notes: _notesCtrl.text.trim(),
      );
      await FirebaseService.addNamjari(namjari);
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('নামজারী সংরক্ষিত হয়েছে ✓'))); Navigator.pop(context); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ত্রুটি: $e'), backgroundColor: AppTheme.danger));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  Widget _datePicker(String label, DateTime? value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
          child: Row(children: [
            const Icon(Icons.calendar_today, size: 16, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(value != null ? '${value.day}/${value.month}/${value.year}' : 'তারিখ বেছে নিন',
              style: GoogleFonts.hindSiliguri(fontSize: 13, color: value != null ? AppTheme.textPrimary : AppTheme.textHint)),
          ]),
        ),
        const SizedBox(height: 14),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন নামজারী মামলা')),
      backgroundColor: AppTheme.background,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            FormSectionCard(title: 'আবেদনকারীর তথ্য', children: [
              AppFormField(label: 'আবেদনকারীর নাম', controller: _nameCtrl, hint: 'পূর্ণ নাম', isRequired: true),
              AppFormField(label: 'মোবাইল নম্বর', controller: _phoneCtrl, hint: '০১৭XXXXXXXX', keyboardType: TextInputType.phone),
            ]),
            FormSectionCard(title: 'মামলার তথ্য', children: [
              AppFormField(label: 'মামলা নম্বর', controller: _caseNoCtrl, hint: 'মামলা নং'),
              AppDropdownField(label: 'মামলার ধরন', value: _caseType, items: ['নামজারী', 'জমাভাগ', 'খতিয়ান সংশোধন'], onChanged: (v) => setState(() => _caseType = v!)),
              _datePicker('দাখিলের তারিখ', _filingDate, () async {
                final d = await showDatePicker(context: context, initialDate: _filingDate, firstDate: DateTime(2000), lastDate: DateTime(2030));
                if (d != null) setState(() => _filingDate = d);
              }),
              _datePicker('পরবর্তী শুনানির তারিখ', _hearingDate, () async {
                final d = await showDatePicker(context: context, initialDate: _hearingDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
                if (d != null) setState(() => _hearingDate = d);
              }),
              AppFormField(label: 'মৌজার নাম', controller: _mouzaCtrl, hint: 'মৌজা', isRequired: true),
              Row(children: [
                Expanded(child: AppFormField(label: 'খতিয়ান নম্বর', controller: _khatianCtrl, hint: 'খতিয়ান নং')),
                const SizedBox(width: 12),
                Expanded(child: AppFormField(label: 'দাগ নম্বর', controller: _dagCtrl, hint: 'দাগ নং')),
              ]),
              AppDropdownField(label: 'অবস্থা', value: _status, items: ['চলমান', 'সম্পন্ন', 'মুলতবি'], onChanged: (v) => setState(() => _status = v!)),
              AppFormField(label: 'নোট', controller: _notesCtrl, hint: 'মামলার বিস্তারিত...', maxLines: 3),
            ]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(height: 52, child: ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : Text('সংরক্ষণ করুন', style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.w600)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADD KHATIAN SCREEN
// ═══════════════════════════════════════════════════════════════

class AddKhatianScreen extends StatefulWidget {
  const AddKhatianScreen({super.key});
  @override State<AddKhatianScreen> createState() => _AddKhatianScreenState();
}

class _AddKhatianScreenState extends State<AddKhatianScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ownerCtrl = TextEditingController();
  final _mouzaCtrl = TextEditingController();
  final _jlCtrl = TextEditingController();
  final _newKhatianCtrl = TextEditingController();
  final _oldKhatianCtrl = TextEditingController();
  final _dagCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _landClass = 'কৃষি';
  String _status = 'চলমান';
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_ownerCtrl,_mouzaCtrl,_jlCtrl,_newKhatianCtrl,_oldKhatianCtrl,_dagCtrl,_areaCtrl,_notesCtrl]) c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final khatian = KhatianRecord(
        id: '', ownerName: _ownerCtrl.text.trim(), mouzaName: _mouzaCtrl.text.trim(),
        mouzaJL: _jlCtrl.text.trim(), newKhatianNumber: _newKhatianCtrl.text.trim(),
        oldKhatianNumber: _oldKhatianCtrl.text.trim(), dagNumbers: _dagCtrl.text.trim(),
        landClass: _landClass, landArea: _areaCtrl.text.trim(),
        status: _status, notes: _notesCtrl.text.trim(), createdAt: DateTime.now(),
      );
      await FirebaseService.addKhatian(khatian);
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('খতিয়ান সংরক্ষিত হয়েছে ✓'))); Navigator.pop(context); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ত্রুটি: $e'), backgroundColor: AppTheme.danger));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন খতিয়ান সৃজন')),
      backgroundColor: AppTheme.background,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            FormSectionCard(title: 'মালিক ও মৌজার তথ্য', children: [
              AppFormField(label: 'জমির মালিকের নাম', controller: _ownerCtrl, hint: 'পূর্ণ নাম', isRequired: true),
              AppFormField(label: 'মৌজার নাম', controller: _mouzaCtrl, hint: 'মৌজার নাম', isRequired: true),
              AppFormField(label: 'মৌজা নম্বর (JL)', controller: _jlCtrl, hint: 'JL নং', keyboardType: TextInputType.number),
            ]),
            FormSectionCard(title: 'খতিয়ানের তথ্য', children: [
              Row(children: [
                Expanded(child: AppFormField(label: 'নতুন খতিয়ান নং', controller: _newKhatianCtrl, hint: 'নতুন নং', keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: AppFormField(label: 'পুরনো খতিয়ান নং', controller: _oldKhatianCtrl, hint: 'পুরনো নং', keyboardType: TextInputType.number)),
              ]),
              AppFormField(label: 'দাগ নম্বর(সমূহ)', controller: _dagCtrl, hint: 'যেমন: ৩৪৫, ৩৪৬'),
              Row(children: [
                Expanded(child: AppDropdownField(label: 'জমির শ্রেণি', value: _landClass, items: ['কৃষি', 'বাড়ি', 'পুকুর', 'বাগান', 'নালা', 'অন্যান্য'], onChanged: (v) => setState(() => _landClass = v!))),
                const SizedBox(width: 12),
                Expanded(child: AppFormField(label: 'পরিমাণ (শতাংশ)', controller: _areaCtrl, hint: 'শতাংশ', keyboardType: TextInputType.number)),
              ]),
              AppDropdownField(label: 'অবস্থা', value: _status, items: ['চলমান', 'সম্পন্ন', 'মুলতবি'], onChanged: (v) => setState(() => _status = v!)),
              AppFormField(label: 'নোট', controller: _notesCtrl, hint: 'অতিরিক্ত তথ্য...', maxLines: 2),
            ]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(height: 52, child: ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : Text('সংরক্ষণ করুন', style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.w600)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
