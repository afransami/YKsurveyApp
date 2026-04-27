import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

// ═══════════════════════════════════════════════════════════════
// ADVANCE SCREEN — lib/screens/advance_screen.dart
// ═══════════════════════════════════════════════════════════════

class AdvanceScreen extends StatefulWidget {
  const AdvanceScreen({super.key});
  @override State<AdvanceScreen> createState() => _AdvanceScreenState();
}

class _AdvanceScreenState extends State<AdvanceScreen> {
  bool _pendingOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('অগ্রিম টাকার হিসাব'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddAdvanceScreen()))),
        ],
      ),
      backgroundColor: AppTheme.background,
      body: Column(children: [
        // Summary card
        StreamBuilder<double>(
          stream: FirebaseService.getTotalPendingAdvance(),
          builder: (ctx, snap) {
            final total = snap.data ?? 0;
            return Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF4527A0), Color(0xFF7B1FA2)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(children: [
                const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('মোট বকেয়া অগ্রিম', style: GoogleFonts.hindSiliguri(fontSize: 13, color: Colors.white70)),
                  Text('৳ ${total.toStringAsFixed(0)}', style: GoogleFonts.hindSiliguri(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
                ]),
              ]),
            );
          },
        ),
        // Filter toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(children: [
            Text('শুধু বকেয়া দেখুন', style: GoogleFonts.hindSiliguri(fontSize: 14)),
            const Spacer(),
            Switch(value: _pendingOnly, onChanged: (v) => setState(() => _pendingOnly = v), activeColor: AppTheme.primary),
          ]),
        ),
        Expanded(
          child: StreamBuilder<List<AdvancePayment>>(
            stream: FirebaseService.getAdvances(pendingOnly: _pendingOnly),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              final list = snap.data ?? [];
              if (list.isEmpty) return const EmptyStateWidget(icon: Icons.account_balance_wallet_outlined, title: 'কোনো অগ্রিম নেই', subtitle: 'নতুন অগ্রিম যোগ করুন');
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 100),
                itemCount: list.length,
                itemBuilder: (ctx, i) => _AdvanceTile(advance: list[i]),
              );
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddAdvanceScreen())),
        icon: const Icon(Icons.add),
        label: Text('নতুন অগ্রিম', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _AdvanceTile extends StatelessWidget {
  final AdvancePayment advance;
  const _AdvanceTile({required this.advance});

  @override
  Widget build(BuildContext context) {
    final remaining = advance.remainingAmount;
    final percent = advance.totalAmount > 0 ? (advance.adjustedAmount / advance.totalAmount).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: advance.isSettled ? AppTheme.divider : AppTheme.purple.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          AvatarCircle(text: advance.clientName.isNotEmpty ? advance.clientName[0] : '?', bg: AppTheme.purpleLight, fg: AppTheme.purple, size: 42),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(advance.clientName, style: GoogleFonts.hindSiliguri(fontSize: 14, fontWeight: FontWeight.w600)),
            Text(advance.workDescription, style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('৳ ${advance.totalAmount.toStringAsFixed(0)}', style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.purple)),
            Text('${advance.receivedDate.day}/${advance.receivedDate.month}/${advance.receivedDate.year}', style: GoogleFonts.hindSiliguri(fontSize: 11, color: AppTheme.textHint)),
          ]),
        ]),
        const SizedBox(height: 12),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent.toDouble(),
            backgroundColor: AppTheme.purpleLight,
            valueColor: AlwaysStoppedAnimation<Color>(advance.isSettled ? AppTheme.primary : AppTheme.purple),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Text('সমন্বয়: ৳ ${advance.adjustedAmount.toStringAsFixed(0)}', style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary)),
          const Spacer(),
          if (advance.isSettled)
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3), decoration: BoxDecoration(color: AppTheme.primarySurface, borderRadius: BorderRadius.circular(20)), child: Text('পরিশোধিত', style: GoogleFonts.hindSiliguri(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w500)))
          else
            Text('বাকি: ৳ ${remaining.toStringAsFixed(0)}', style: GoogleFonts.hindSiliguri(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.danger)),
        ]),
        if (!advance.isSettled) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _showSettleDialog(context, advance),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: AppTheme.purple.withOpacity(0.3)), borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text('সমন্বয় করুন', style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.purple, fontWeight: FontWeight.w500))),
            ),
          ),
        ],
      ]),
    );
  }

  void _showSettleDialog(BuildContext context, AdvancePayment advance) {
    final ctrl = TextEditingController(text: advance.remainingAmount.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('অগ্রিম সমন্বয়', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('মোট অগ্রিম: ৳ ${advance.totalAmount.toStringAsFixed(0)}', style: GoogleFonts.hindSiliguri(fontSize: 13)),
          Text('ইতোমধ্যে সমন্বয়: ৳ ${advance.adjustedAmount.toStringAsFixed(0)}', style: GoogleFonts.hindSiliguri(fontSize: 13)),
          const SizedBox(height: 12),
          TextField(controller: ctrl, keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'সমন্বয়কৃত মোট পরিমাণ (৳)', hintText: '${advance.totalAmount.toStringAsFixed(0)}')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('বাতিল', style: GoogleFonts.hindSiliguri())),
          ElevatedButton(
            onPressed: () async {
              final val = double.tryParse(ctrl.text) ?? advance.totalAmount;
              await FirebaseService.settleAdvance(advance.id, val);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('সমন্বয় করুন', style: GoogleFonts.hindSiliguri()),
          ),
        ],
      ),
    );
  }
}

// ADD ADVANCE
class AddAdvanceScreen extends StatefulWidget {
  const AddAdvanceScreen({super.key});
  @override State<AddAdvanceScreen> createState() => _AddAdvanceScreenState();
}

class _AddAdvanceScreenState extends State<AddAdvanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _workCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime _receivedDate = DateTime.now();
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_nameCtrl,_phoneCtrl,_amountCtrl,_workCtrl,_notesCtrl]) c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final advance = AdvancePayment(
        id: '', clientId: '', clientName: _nameCtrl.text.trim(), clientPhone: _phoneCtrl.text.trim(),
        totalAmount: double.tryParse(_amountCtrl.text) ?? 0,
        receivedDate: _receivedDate, workDescription: _workCtrl.text.trim(), notes: _notesCtrl.text.trim(),
      );
      await FirebaseService.addAdvance(advance);
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('অগ্রিম সংরক্ষিত হয়েছে ✓'))); Navigator.pop(context); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ত্রুটি: $e'), backgroundColor: AppTheme.danger));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন অগ্রিম যোগ')),
      backgroundColor: AppTheme.background,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            FormSectionCard(title: 'ক্লায়েন্টের তথ্য', children: [
              AppFormField(label: 'ক্লায়েন্টের নাম', controller: _nameCtrl, hint: 'পূর্ণ নাম', isRequired: true),
              AppFormField(label: 'মোবাইল নম্বর', controller: _phoneCtrl, hint: '০১৭XXXXXXXX', keyboardType: TextInputType.phone),
            ]),
            FormSectionCard(title: 'অগ্রিমের তথ্য', children: [
              AppFormField(label: 'অগ্রিমের পরিমাণ (৳)', controller: _amountCtrl, hint: 'টাকার পরিমাণ', keyboardType: TextInputType.number, isRequired: true),
              GestureDetector(
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: _receivedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
                  if (d != null) setState(() => _receivedDate = d);
                },
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('গ্রহণের তারিখ', style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                    decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
                    child: Row(children: [
                      const Icon(Icons.calendar_today, size: 16, color: AppTheme.primary),
                      const SizedBox(width: 8),
                      Text('${_receivedDate.day}/${_receivedDate.month}/${_receivedDate.year}', style: GoogleFonts.hindSiliguri(fontSize: 13)),
                    ]),
                  ),
                  const SizedBox(height: 14),
                ]),
              ),
              AppFormField(label: 'কাজের বিবরণ', controller: _workCtrl, hint: 'কিসের জন্য অগ্রিম নেওয়া হয়েছে', isRequired: true),
              AppFormField(label: 'নোট', controller: _notesCtrl, hint: 'রশিদ নম্বর বা অন্যান্য তথ্য...', maxLines: 2),
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
