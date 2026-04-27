import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/models.dart';
import 'client_screen.dart';
import 'schedule_screen.dart';
import 'dalil_screen.dart';
import 'advance_screen.dart';
import 'khajna_screen.dart';
import 'login_screen.dart';

// ═══════════════════════════════════════════════════════════════
// MAIN SCREEN — lib/screens/main_screen.dart
// ═══════════════════════════════════════════════════════════════

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ClientScreen(),
    ScheduleScreen(),
    DalilScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppTheme.divider, width: 0.5)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'ড্যাশবোর্ড', index: 0, selected: _selectedIndex, onTap: () => setState(() => _selectedIndex = 0)),
                _NavItem(icon: Icons.people_outline, activeIcon: Icons.people, label: 'ক্লায়েন্ট', index: 1, selected: _selectedIndex, onTap: () => setState(() => _selectedIndex = 1)),
                _NavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month, label: 'সিডিউল', index: 2, selected: _selectedIndex, onTap: () => setState(() => _selectedIndex = 2)),
                _NavItem(icon: Icons.description_outlined, activeIcon: Icons.description, label: 'দলিল', index: 3, selected: _selectedIndex, onTap: () => setState(() => _selectedIndex = 3)),
                _NavItem(icon: Icons.more_horiz, activeIcon: Icons.more_horiz, label: 'আরও', index: 4, selected: _selectedIndex, onTap: () => setState(() => _selectedIndex = 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final int index, selected;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.index, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primarySurface : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected ? AppTheme.primary : AppTheme.textHint),
            const SizedBox(height: 3),
            Text(label,
              style: GoogleFonts.hindSiliguri(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.primary : AppTheme.textHint,
              )),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DASHBOARD SCREEN
// ═══════════════════════════════════════════════════════════════

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AppUser? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await FirebaseService.getCurrentUserProfile();
    if (mounted) setState(() => _user = user);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = now.hour < 12 ? 'সুপ্রভাত' : now.hour < 17 ? 'শুভ অপরাহ্ন' : 'শুভ সন্ধ্যা';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$greeting! 👋',
                                    style: GoogleFonts.hindSiliguri(fontSize: 13, color: Colors.white70)),
                                  Text(_user?.name ?? 'লোড হচ্ছে...',
                                    style: GoogleFonts.hindSiliguri(
                                      fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,
                                    )),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showProfileMenu(context),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Text(
                                  _user?.name.isNotEmpty == true ? _user!.name[0] : '?',
                                  style: GoogleFonts.hindSiliguri(
                                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${now.day}/${now.month}/${now.year} — আজকের সব কাজ দেখুন',
                          style: GoogleFonts.hindSiliguri(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: FutureBuilder<Map<String, int>>(
              future: FirebaseService.getDashboardStats(),
              builder: (context, snap) {
                final stats = snap.data ?? {};
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      StatCard(label: 'মোট ক্লায়েন্ট', value: '${stats['totalClients'] ?? 0}', icon: Icons.people, color: AppTheme.primary),
                      StatCard(label: 'চলমান কাজ', value: '${stats['activeWork'] ?? 0}', icon: Icons.work_outline, color: AppTheme.info),
                      StatCard(label: 'আসন্ন সিডিউল', value: '${stats['upcomingSchedules'] ?? 0}', icon: Icons.calendar_today, color: AppTheme.accent),
                      StatCard(label: 'বকেয়া অগ্রিম', value: '${stats['pendingAdvances'] ?? 0}', icon: Icons.account_balance_wallet_outlined, color: AppTheme.danger),
                    ],
                  ),
                );
              },
            ),
          ),

          // Today's Schedules
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'আজকের সিডিউল', subtitle: 'আজ যেসব কাজ নির্ধারিত আছে'),
          ),

          StreamBuilder<List<SurveySchedule>>(
            stream: FirebaseService.getTodaySchedules(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  )),
                );
              }
              final schedules = snap.data ?? [];
              if (schedules.isEmpty) {
                return SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Row(children: [
                      const Icon(Icons.event_available, color: AppTheme.primary, size: 28),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('আজকে কোনো সিডিউল নেই', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w500)),
                        Text('নতুন সিডিউল যোগ করতে + ট্যাপ করুন', style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary)),
                      ]),
                    ]),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => ScheduleCard(
                    clientName: schedules[i].clientName,
                    mouzaName: schedules[i].mouzaName,
                    scheduleType: schedules[i].scheduleType,
                    scheduledAt: schedules[i].scheduledAt,
                    isToday: true,
                  ),
                  childCount: schedules.length,
                ),
              );
            },
          ),

          // Upcoming (next 7 days)
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'আসন্ন সিডিউল', subtitle: 'পরবর্তী ৭ দিনের কাজ'),
          ),

          StreamBuilder<List<SurveySchedule>>(
            stream: FirebaseService.getUpcomingSchedules(),
            builder: (context, snap) {
              final schedules = (snap.data ?? []).where((s) => !s.isToday).take(5).toList();
              if (schedules.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox(height: 20));
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => ScheduleCard(
                    clientName: schedules[i].clientName,
                    mouzaName: schedules[i].mouzaName,
                    scheduleType: schedules[i].scheduleType,
                    scheduledAt: schedules[i].scheduledAt,
                    isToday: false,
                  ),
                  childCount: schedules.length,
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.divider, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            CircleAvatar(radius: 32, backgroundColor: AppTheme.primarySurface,
              child: Text(_user?.name.isNotEmpty == true ? _user!.name[0] : '?',
                style: GoogleFonts.hindSiliguri(fontSize: 28, color: AppTheme.primary, fontWeight: FontWeight.w700))),
            const SizedBox(height: 12),
            Text(_user?.name ?? '', style: GoogleFonts.hindSiliguri(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(_user?.email ?? '', style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.textSecondary)),
            Text(_user?.isAdmin == true ? '👑 অ্যাডমিন' : '👤 কর্মচারী',
              style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.primary)),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.danger),
              title: Text('লগআউট', style: GoogleFonts.hindSiliguri(color: AppTheme.danger)),
              onTap: () async {
                await FirebaseService.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MORE SCREEN (Advance + Khajna links)
// ═══════════════════════════════════════════════════════════════

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('আরও সেবা')),
      backgroundColor: AppTheme.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MoreTile(
            icon: Icons.account_balance_wallet_outlined,
            color: AppTheme.purple,
            title: 'অগ্রিম টাকার হিসাব',
            subtitle: 'ক্লায়েন্টের অগ্রিম পরিশোধ ও বকেয়া ট্র্যাক করুন',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdvanceScreen())),
          ),
          const SizedBox(height: 10),
          _MoreTile(
            icon: Icons.receipt_long_outlined,
            color: AppTheme.teal,
            title: 'খাজনার দাখিলা',
            subtitle: 'ভূমি উন্নয়ন কর পরিশোধের রেকর্ড সংরক্ষণ করুন',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KhajnaScreen())),
          ),
          const SizedBox(height: 24),
          // Pending advance summary
          StreamBuilder<double>(
            stream: FirebaseService.getTotalPendingAdvance(),
            builder: (ctx, snap) {
              final total = snap.data ?? 0;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.dangerLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.danger.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_outlined, color: AppTheme.danger),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('মোট বকেয়া অগ্রিম', style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.danger)),
                      Text('৳ ${total.toStringAsFixed(0)}',
                        style: GoogleFonts.hindSiliguri(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.danger)),
                    ])),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final VoidCallback onTap;
  const _MoreTile({required this.icon, required this.color, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: GoogleFonts.hindSiliguri(fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(subtitle, style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary)),
            ])),
            Icon(Icons.chevron_right, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }
}
