import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

// ═══════════════════════════════════════════════════════════════
// SCHEDULE SCREEN — lib/screens/schedule_screen.dart
// ═══════════════════════════════════════════════════════════════

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সিডিউল ক্যালেন্ডার'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddScheduleScreen())),
          ),
        ],
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Calendar
          Container(
            color: Colors.white,
            child: TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: _focusedDay,
              selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
              calendarFormat: _calendarFormat,
              onFormatChanged: (f) => setState(() => _calendarFormat = f),
              onDaySelected: (sel, foc) => setState(() {
                _selectedDay = sel;
                _focusedDay = foc;
              }),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.3), shape: BoxShape.circle),
                selectedDecoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                todayTextStyle: GoogleFonts.hindSiliguri(color: AppTheme.primary, fontWeight: FontWeight.w700),
                selectedTextStyle: GoogleFonts.hindSiliguri(color: Colors.white, fontWeight: FontWeight.w700),
                defaultTextStyle: GoogleFonts.hindSiliguri(),
                weekendTextStyle: GoogleFonts.hindSiliguri(color: AppTheme.danger),
              ),
              headerStyle: HeaderStyle(
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                formatButtonTextStyle: GoogleFonts.hindSiliguri(color: AppTheme.primary, fontSize: 12),
                titleTextStyle: GoogleFonts.hindSiliguri(fontSize: 15, fontWeight: FontWeight.w600),
                leftChevronIcon: const Icon(Icons.chevron_left, color: AppTheme.primary),
                rightChevronIcon: const Icon(Icons.chevron_right, color: AppTheme.primary),
              ),
            ),
          ),
          const Divider(height: 1),

          // Selected day label
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Row(children: [
              Container(width: 4, height: 18, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 10),
              Text(
                '${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year} — সিডিউল',
                style: GoogleFonts.hindSiliguri(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ]),
          ),

          // Schedule list for selected day
          Expanded(
            child: StreamBuilder<List<SurveySchedule>>(
              stream: FirebaseService.getUpcomingSchedules(),
              builder: (ctx, snap) {
                final allSchedules = snap.data ?? [];
                final daySchedules = allSchedules.where((s) =>
                  isSameDay(s.scheduledAt, _selectedDay)).toList();

                if (daySchedules.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.event_note_outlined,
                    title: 'এই দিনে কোনো সিডিউল নেই',
                    subtitle: 'নতুন সিডিউল যোগ করতে + ট্যাপ করুন',
                    buttonLabel: 'সিডিউল যোগ করুন',
                    onButtonTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AddScheduleScreen(preSelectedDate: _selectedDay))),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: daySchedules.length,
                  itemBuilder: (ctx, i) {
                    final s = daySchedules[i];
                    return _ScheduleDetailTile(schedule: s);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => AddScheduleScreen(preSelectedDate: _selectedDay))),
        icon: const Icon(Icons.add),
        label: Text('নতুন সিডিউল', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _ScheduleDetailTile extends StatelessWidget {
  final SurveySchedule schedule;
  const _ScheduleDetailTile({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final h = schedule.scheduledAt.hour.toString().padLeft(2, '0');
    final m = schedule.scheduledAt.minute.toString().padLeft(2, '0');
    final color = _typeColor(schedule.scheduleType);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Color bar + time
            Container(
              width: 64,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(h, style: GoogleFonts.hindSiliguri(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
                Container(width: 20, height: 1.5, color: color.withOpacity(0.4)),
                Text(m, style: GoogleFonts.hindSiliguri(fontSize: 14, color: color)),
              ]),
            ),
            Container(width: 3, color: color),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(
                      child: Text(schedule.clientName,
                        style: GoogleFonts.hindSiliguri(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                    StatusBadge.forStatus(schedule.status),
                  ]),
                  const SizedBox(height: 4),
                  Text('${schedule.mouzaName} মৌজা${schedule.dagNumber.isNotEmpty ? " • দাগ: ${schedule.dagNumber}" : ""}',
                    style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary)),
                  const SizedBox(height: 6),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(schedule.scheduleType,
                        style: GoogleFonts.hindSiliguri(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
                    ),
                    if (schedule.clientPhone.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.phone_outlined, size: 12, color: AppTheme.textHint),
                      const SizedBox(width: 3),
                      Text(schedule.clientPhone, style: GoogleFonts.hindSiliguri(fontSize: 11, color: AppTheme.textHint)),
                    ],
                  ]),
                  if (schedule.notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(schedule.notes,
                      style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                  // Action buttons
                  const SizedBox(height: 8),
                  Row(children: [
                    _ActionChip(label: 'সম্পন্ন', color: AppTheme.primary, onTap: () =>
                      FirebaseService.updateScheduleStatus(schedule.id, 'সম্পন্ন')),
                    const SizedBox(width: 8),
                    _ActionChip(label: 'বাতিল', color: AppTheme.danger, onTap: () =>
                      FirebaseService.updateScheduleStatus(schedule.id, 'বাতিল')),
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _typeColor(String type) {
    if (type.contains('পরিমাপ')) return AppTheme.primary;
    if (type.contains('দলিল')) return AppTheme.teal;
    if (type.contains('নামজারী')) return AppTheme.purple;
    if (type.contains('ডেলিভারি')) return AppTheme.info;
    return AppTheme.accent;
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionChip({required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: GoogleFonts.hindSiliguri(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// ADD SCHEDULE SCREEN
// ═══════════════════════════════════════════════════════════════

class AddScheduleScreen extends StatefulWidget {
  final DateTime? preSelectedDate;
  const AddScheduleScreen({super.key, this.preSelectedDate});
  @override State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameCtrl = TextEditingController();
  final _clientPhoneCtrl = TextEditingController();
  final _mouzaCtrl = TextEditingController();
  final _dagCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _scheduleType = 'জমি পরিমাপ';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedDate != null) _selectedDate = widget.preSelectedDate!;
  }

  @override
  void dispose() {
    _clientNameCtrl.dispose(); _clientPhoneCtrl.dispose();
    _mouzaCtrl.dispose(); _dagCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: AppTheme.primary)),
        child: child!,
      ),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context, initialTime: _selectedTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: AppTheme.primary)),
        child: child!,
      ),
    );
    if (t != null) setState(() => _selectedTime = t);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final scheduledAt = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day,
        _selectedTime.hour, _selectedTime.minute,
      );
      final schedule = SurveySchedule(
        id: '',
        clientId: '',
        clientName: _clientNameCtrl.text.trim(),
        clientPhone: _clientPhoneCtrl.text.trim(),
        mouzaName: _mouzaCtrl.text.trim(),
        dagNumber: _dagCtrl.text.trim(),
        scheduleType: _scheduleType,
        scheduledAt: scheduledAt,
        notes: _notesCtrl.text.trim(),
      );
      await FirebaseService.addSchedule(schedule);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('সিডিউল সংরক্ষিত হয়েছে ✓')));
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
      appBar: AppBar(title: const Text('নতুন সিডিউল যোগ')),
      backgroundColor: AppTheme.background,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // Date & Time picker
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primarySurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
              ),
              child: Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('তারিখ', style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.primary)),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.calendar_today, color: AppTheme.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primary),
                        ),
                      ]),
                    ]),
                  ),
                ),
                Container(width: 1, height: 40, color: AppTheme.primary.withOpacity(0.2)),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickTime,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('সময়', style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.primary)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.access_time, color: AppTheme.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                            style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primary),
                          ),
                        ]),
                      ]),
                    ),
                  ),
                ),
              ]),
            ),

            FormSectionCard(
              title: 'ক্লায়েন্টের তথ্য',
              children: [
                AppFormField(label: 'ক্লায়েন্টের নাম', controller: _clientNameCtrl, hint: 'মো. রহিম উদ্দিন', isRequired: true),
                AppFormField(label: 'মোবাইল নম্বর', controller: _clientPhoneCtrl, hint: '০১৭XXXXXXXX', keyboardType: TextInputType.phone),
              ],
            ),
            FormSectionCard(
              title: 'জমির তথ্য ও সেবা',
              children: [
                AppFormField(label: 'মৌজার নাম', controller: _mouzaCtrl, hint: 'মৌজার নাম', isRequired: true),
                AppFormField(label: 'দাগ নম্বর', controller: _dagCtrl, hint: 'দাগ নং'),
                AppDropdownField(
                  label: 'সিডিউলের ধরন',
                  value: _scheduleType,
                  items: ['জমি পরিমাপ', 'দলিল রেজিস্ট্রি', 'নামজারী শুনানি', 'ডকুমেন্ট ডেলিভারি', 'সিডিউল পরিমাপ', 'অন্যান্য'],
                  onChanged: (v) => setState(() => _scheduleType = v!),
                ),
                AppFormField(label: 'নোট', controller: _notesCtrl, hint: 'অতিরিক্ত তথ্য...', maxLines: 3),
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
