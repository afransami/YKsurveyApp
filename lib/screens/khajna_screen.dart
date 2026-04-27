import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

// ═══════════════════════════════════════════════════════════════
// KHAJNA SCREEN — lib/screens/khajna_screen.dart
// ═══════════════════════════════════════════════════════════════

class KhajnaScreen extends StatefulWidget {
  const KhajnaScreen({super.key});
  @override State<KhajnaScreen> createState() => _KhajnaScreenState();
}

class _KhajnaScreenState extends State<KhajnaScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('খাজনার দাখিলা'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddKhajnaScreen()))),
        ],
      ),
      backgroundColor: AppTheme.background,
      body: Column(children: [
        AppSearchBar(controller: _searchCtrl, hint: 'মালিক, মৌজা বা দাখিলা নম্বর...', onChanged: (v) => setState(() => _searchQuery = v)),
        Expanded(
          child: StreamBuilder<List<KhajnaRecord>>(
            stream: FirebaseService.getKhajnas(searchQuery: _searchQuery),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              final list = snap.data ?? [];
              if (list.isEmpty) return EmptyStateWidget(
                icon: Icons.receipt_long_outlined,
                title: 'কোনো দাখিলা নেই',
                subtitle: 'নতুন খাজনার দাখিলা যোগ করুন',
                buttonLabel: 'দাখিলা যোগ',
                onButtonTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddKhajnaScreen())),
              );
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 100),
                itemCount: list.length,
                itemBuilder: (ctx, i) => _KhajnaTile(khajna: list[i]),
              );
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddKhajnaScreen())),
        icon: const Icon(Icons.add),
        label: Text('নতুন দাখিলা', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _KhajnaTile extends StatelessWidget {
  final KhajnaRecord khajna;
  const _KhajnaTile({required this.khajna});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(color: AppTheme.tealLight, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.receipt_long, color: AppTheme.teal, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(khajna.ownerName, style: GoogleFonts.hindSiliguri(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text('${khajna.mouzaName} মৌজা • দাখিলা #${khajna.dakikaNumber}', style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary)),
          Text('অর্থবছর: ${khajna.fiscalYear} • ${khajna.paymentDate.day}/${khajna.paymentDate.month}/${khajna.paymentDate.year}', style: GoogleFonts.hindSiliguri(fontSize: 11, color: AppTheme.textHint)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('৳ ${khajna.amount.toStringAsFixed(0)}', style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.teal)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppTheme.tealLight, borderRadius: BorderRadius.circular(10)),
            child: Text('পরিশোধিত', style: GoogleFonts.hindSiliguri(fontSize: 10, color: AppTheme.teal, fontWeight: FontWeight.w500)),
          ),
        ]),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADD KHAJNA SCREEN
// ═══════════════════════════════════════════════════════════════

class AddKhajnaScreen extends StatefulWidget {
  const AddKhajnaScreen({super.key});
  @override State<AddKhajnaScreen> createState() => _AddKhajnaScreenState();
}

class _AddKhajnaScreenState extends State<AddKhajnaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ownerCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dakikaCtrl = TextEditingController();
  final _mouzaCtrl = TextEditingController();
  final _khatianCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _fiscalYearCtrl = TextEditingController(text: '২০২৫-২৬');
  final _notesCtrl = TextEditingController();
  DateTime _paymentDate = DateTime.now();
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_ownerCtrl,_phoneCtrl,_dakikaCtrl,_mouzaCtrl,_khatianCtrl,_amountCtrl,_fiscalYearCtrl,_notesCtrl]) c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final khajna = KhajnaRecord(
        id: '', ownerName: _ownerCtrl.text.trim(), ownerPhone: _phoneCtrl.text.trim(),
        dakikaNumber: _dakikaCtrl.text.trim(), paymentDate: _paymentDate,
        mouzaName: _mouzaCtrl.text.trim(), khatianNumber: _khatianCtrl.text.trim(),
        amount: double.tryParse(_amountCtrl.text) ?? 0,
        fiscalYear: _fiscalYearCtrl.text.trim(), notes: _notesCtrl.text.trim(),
      );
      await FirebaseService.addKhajna(khajna);
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('দাখিলা সংরক্ষিত হয়েছে ✓'))); Navigator.pop(context); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ত্রুটি: $e'), backgroundColor: AppTheme.danger));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন খাজনার দাখিলা')),
      backgroundColor: AppTheme.background,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            FormSectionCard(title: 'মালিকের তথ্য', children: [
              AppFormField(label: 'জমির মালিক', controller: _ownerCtrl, hint: 'পূর্ণ নাম', isRequired: true),
              AppFormField(label: 'মোবাইল নম্বর', controller: _phoneCtrl, hint: '০১৭XXXXXXXX', keyboardType: TextInputType.phone),
            ]),
            FormSectionCard(title: 'দাখিলার তথ্য', children: [
              Row(children: [
                Expanded(child: AppFormField(label: 'দাখিলা নম্বর', controller: _dakikaCtrl, hint: 'দাখিলা নং')),
                const SizedBox(width: 12),
                Expanded(child: AppFormField(label: 'অর্থবছর', controller: _fiscalYearCtrl, hint: '২০২৫-২৬', isRequired: true)),
              ]),
              GestureDetector(
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: _paymentDate, firstDate: DateTime(2000), lastDate: DateTime(2030),
                    builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: AppTheme.teal)), child: child!));
                  if (d != null) setState(() => _paymentDate = d);
                },
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('পরিশোধের তারিখ', style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                    decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
                    child: Row(children: [
                      const Icon(Icons.calendar_today, size: 16, color: AppTheme.teal),
                      const SizedBox(width: 8),
                      Text('${_paymentDate.day}/${_paymentDate.month}/${_paymentDate.year}', style: GoogleFonts.hindSiliguri(fontSize: 13)),
                    ]),
                  ),
                  const SizedBox(height: 14),
                ]),
              ),
              AppFormField(label: 'মৌজার নাম', controller: _mouzaCtrl, hint: 'মৌজার নাম', isRequired: true),
              Row(children: [
                Expanded(child: AppFormField(label: 'খতিয়ান নম্বর', controller: _khatianCtrl, hint: 'খতিয়ান নং')),
                const SizedBox(width: 12),
                Expanded(child: AppFormField(label: 'খাজনার পরিমাণ (৳)', controller: _amountCtrl, hint: 'টাকা', keyboardType: TextInputType.number, isRequired: true)),
              ]),
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
