import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

// ═══════════════════════════════════════════════════════════════
// LOGIN SCREEN — lib/screens/login_screen.dart
// ═══════════════════════════════════════════════════════════════

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _obscurePass = true;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animCtrl, curve: const Interval(0.2, 1, curve: Curves.easeOut)));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseService.signIn(_emailCtrl.text.trim(), _passCtrl.text);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('লগইন ব্যর্থ হয়েছে। ইমেইল ও পাসওয়ার্ড যাচাই করুন।'),
          backgroundColor: AppTheme.danger,
        ));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Expanded(
                flex: 2,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                        ),
                        child: const Icon(Icons.map_outlined, size: 44, color: Colors.white),
                      ),
                      const SizedBox(height: 18),
                      Text('ভূমি সার্ভে',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white,
                        )),
                      Text('ম্যানেজমেন্ট সিস্টেম',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 16, color: Colors.white.withOpacity(0.8),
                        )),
                    ],
                  ),
                ),
              ),

              // Login Form
              Expanded(
                flex: 3,
                child: SlideTransition(
                  position: _slideAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F7F5),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('স্বাগতম',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 24, fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                )),
                              const SizedBox(height: 4),
                              Text('আপনার অ্যাকাউন্টে লগইন করুন',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 14, color: AppTheme.textSecondary,
                                )),
                              const SizedBox(height: 28),

                              // Email
                              Text('ইমেইল',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 13, fontWeight: FontWeight.w500,
                                  color: AppTheme.textSecondary,
                                )),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.hindSiliguri(fontSize: 15),
                                decoration: const InputDecoration(
                                  hintText: 'example@gmail.com',
                                  prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primary, size: 20),
                                ),
                                validator: (v) => v == null || !v.contains('@') ? 'সঠিক ইমেইল দিন' : null,
                              ),
                              const SizedBox(height: 16),

                              // Password
                              Text('পাসওয়ার্ড',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 13, fontWeight: FontWeight.w500,
                                  color: AppTheme.textSecondary,
                                )),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passCtrl,
                                obscureText: _obscurePass,
                                style: GoogleFonts.hindSiliguri(fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primary, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: AppTheme.textHint, size: 20,
                                    ),
                                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                                  ),
                                ),
                                validator: (v) => v == null || v.length < 6 ? 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষর' : null,
                              ),
                              const SizedBox(height: 28),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _login,
                                  child: _loading
                                      ? const SizedBox(
                                          width: 22, height: 22,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : Text('লগইন করুন',
                                          style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
