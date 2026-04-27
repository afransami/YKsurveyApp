import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════
// REUSABLE WIDGETS — lib/widgets/common_widgets.dart
// ═══════════════════════════════════════════════════════════════

// ─── Status Badge ────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeStyle style;
  const StatusBadge({super.key, required this.label, required this.style});

  factory StatusBadge.forStatus(String status) {
    BadgeStyle style;
    switch (status) {
      case 'চলমান': style = AppBadges.active; break;
      case 'সম্পন্ন': style = AppBadges.done; break;
      case 'মুলতবি': style = AppBadges.pending; break;
      case 'জরুরি': style = AppBadges.urgent; break;
      case 'নামজারী': style = AppBadges.namjari; break;
      case 'দলিল': style = AppBadges.dalil; break;
      default: style = AppBadges.active;
    }
    return StatusBadge(label: status, style: style);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.hindSiliguri(
          fontSize: 11, fontWeight: FontWeight.w600, color: style.text,
        ),
      ),
    );
  }
}

// ─── Avatar Circle ───────────────────────────────────────────
class AvatarCircle extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final double size;
  const AvatarCircle({
    super.key, required this.text,
    this.bg = AppTheme.primarySurface, this.fg = AppTheme.primary,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(
        child: Text(text,
          style: GoogleFonts.hindSiliguri(
            fontSize: size * 0.35, fontWeight: FontWeight.w600, color: fg,
          )),
      ),
    );
  }
}

// ─── Section Header ──────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const SectionHeader({super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                if (subtitle != null)
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─── Stat Card ───────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const StatCard({
    super.key, required this.label, required this.value,
    required this.icon, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value,
            style: GoogleFonts.hindSiliguri(
              fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textPrimary,
            )),
          const SizedBox(height: 2),
          Text(label,
            style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─── Schedule Card ───────────────────────────────────────────
class ScheduleCard extends StatelessWidget {
  final String clientName;
  final String mouzaName;
  final String scheduleType;
  final DateTime scheduledAt;
  final bool isToday;
  final VoidCallback? onTap;
  const ScheduleCard({
    super.key, required this.clientName, required this.mouzaName,
    required this.scheduleType, required this.scheduledAt,
    this.isToday = false, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isToday ? AppTheme.primarySurface : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isToday ? AppTheme.primary.withOpacity(0.3) : AppTheme.divider,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: isToday ? AppTheme.primary : AppTheme.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(timeStr.split(':')[0],
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: isToday ? Colors.white : AppTheme.primary,
                    )),
                  Text(timeStr.split(':')[1],
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 11,
                      color: isToday ? Colors.white70 : AppTheme.textSecondary,
                    )),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(clientName,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary,
                    )),
                  const SizedBox(height: 3),
                  Text('$mouzaName মৌজা',
                    style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            StatusBadge.forStatus(scheduleType.contains('পরিমাপ') ? 'চলমান' : 'নামজারী'),
          ],
        ),
      ),
    );
  }
}

// ─── Client List Tile ─────────────────────────────────────────
class ClientListTile extends StatelessWidget {
  final String name;
  final String mouzaName;
  final String dagNumbers;
  final String phone;
  final String serviceType;
  final String status;
  final VoidCallback? onTap;
  const ClientListTile({
    super.key, required this.name, required this.mouzaName,
    this.dagNumbers = '', required this.phone, required this.serviceType,
    this.status = 'চলমান', this.onTap,
  });

  Color get _avatarColor {
    final colors = [AppTheme.primary, AppTheme.info, AppTheme.purple, AppTheme.teal];
    return colors[name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty ? name.trim().split(' ').take(2).map((w) => w[0]).join() : '?';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            AvatarCircle(
              text: initials,
              bg: _avatarColor.withOpacity(0.12),
              fg: _avatarColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 15, fontWeight: FontWeight.w600,
                    )),
                  const SizedBox(height: 3),
                  Text(
                    dagNumbers.isNotEmpty
                        ? '$mouzaName মৌজা • দাগ: $dagNumbers'
                        : '$mouzaName মৌজা',
                    style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  Text(phone,
                    style: GoogleFonts.hindSiliguri(fontSize: 12, color: AppTheme.textHint)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge.forStatus(status),
                const SizedBox(height: 5),
                Text(serviceType,
                  style: GoogleFonts.hindSiliguri(fontSize: 11, color: AppTheme.textHint)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State Widget ──────────────────────────────────────
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonTap;
  const EmptyStateWidget({
    super.key, required this.icon, required this.title, required this.subtitle,
    this.buttonLabel, this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primarySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppTheme.primary.withOpacity(0.5)),
            ),
            const SizedBox(height: 20),
            Text(title,
              style: GoogleFonts.hindSiliguri(
                fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary,
              )),
            const SizedBox(height: 8),
            Text(subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.hindSiliguri(fontSize: 14, color: AppTheme.textSecondary)),
            if (buttonLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onButtonTap,
                icon: const Icon(Icons.add, size: 18),
                label: Text(buttonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────
class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  const AppSearchBar({super.key, required this.controller, required this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.hindSiliguri(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.hindSiliguri(fontSize: 14, color: AppTheme.textHint),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textHint, size: 20),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18, color: AppTheme.textHint),
                  onPressed: () { controller.clear(); onChanged?.call(''); },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        ),
      ),
    );
  }
}

// ─── Info Row (label + value) ─────────────────────────────────
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  const InfoRow({super.key, required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                child: Text(label,
                  style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.textSecondary)),
              ),
              Expanded(
                child: Text(value,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary,
                  )),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

// ─── Form Section Card ────────────────────────────────────────
class FormSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const FormSectionCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: AppTheme.primarySurface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(width: 3, height: 16, color: AppTheme.primary,
                  margin: const EdgeInsets.only(right: 10)),
                Text(title,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary,
                  )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ],
      ),
    );
  }
}

// ─── Form Field Wrapper ───────────────────────────────────────
class AppFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool isRequired;
  const AppFormField({
    super.key, required this.label, required this.controller,
    this.hint, this.keyboardType, this.maxLines = 1, this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(text: TextSpan(
          text: label,
          style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
          children: isRequired ? [const TextSpan(text: ' *', style: TextStyle(color: AppTheme.danger))] : [],
        )),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.hindSiliguri(fontSize: 14, color: AppTheme.textPrimary),
          decoration: InputDecoration(hintText: hint ?? label),
          validator: isRequired ? (v) => (v == null || v.isEmpty) ? '$label প্রয়োজন' : null : null,
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

// ─── Dropdown Field ───────────────────────────────────────────
class AppDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const AppDropdownField({
    super.key, required this.label, required this.value,
    required this.items, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.hindSiliguri(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          style: GoogleFonts.hindSiliguri(fontSize: 14, color: AppTheme.textPrimary),
          decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

// ─── Amount Card ──────────────────────────────────────────────
class AmountCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final String prefix;
  const AmountCard({
    super.key, required this.label, required this.amount,
    this.color = AppTheme.primary, this.prefix = '৳',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.hindSiliguri(fontSize: 11, color: color.withOpacity(0.8))),
          const SizedBox(height: 4),
          Text('$prefix ${_format(amount)}',
            style: GoogleFonts.hindSiliguri(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  String _format(double v) {
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)} লক্ষ';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}
