import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

// Import dashboard_page.dart agar bisa navigasi ke DashboardPage asli
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback loginCallback;

  const LoginPage({Key? key, required this.loginCallback}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String loginType = 'Email';
  String identifier = '';
  String password = '';
  bool rememberMe = false;
  final List<String> loginTypes = ['Email', 'NIK', 'BPJS', 'Nomor Asuransi'];

  late AnimationController _buttonAnimationController;
  late AnimationController _googleButtonController;
  late AnimationController _appleButtonController;

  final LocalAuthentication auth = LocalAuthentication();

  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = _createAnimationController();
    _googleButtonController = _createAnimationController();
    _appleButtonController = _createAnimationController();
  }

  AnimationController _createAnimationController() {
    return AnimationController(
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _googleButtonController.dispose();
    _appleButtonController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    setState(() {
      _isAuthenticating = true;
      _authorized = 'Authenticating';
    });
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Login dengan biometrik',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      });
      if (authenticated) {
        widget.loginCallback();
        _navigateToDashboard();
      }
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DashboardPage(logoutCallback: () {}),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide dari kanan ke kiri
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ));
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      widget.loginCallback();
      _navigateToDashboard();
    }
  }

  String? _validateIdentifier(String? val) {
    if (val == null || val.isEmpty) return '$loginType wajib diisi';
    switch (loginType) {
      case 'Email':
        if (!val.contains('@')) return 'Email tidak valid';
        break;
      case 'NIK':
        if (!RegExp(r'^\d{16}$').hasMatch(val)) return 'NIK harus 16 digit angka';
        break;
      case 'BPJS':
        if (!RegExp(r'^\d{13}$').hasMatch(val)) return 'BPJS harus 13 digit angka';
        break;
      case 'Nomor Asuransi':
        if (val.length < 6) return 'Nomor Asuransi minimal 6 karakter';
        break;
    }
    return null;
  }

  IconData _getPrefixIcon() {
    switch (loginType) {
      case 'Email':
        return Icons.email_outlined;
      case 'NIK':
        return Icons.badge_outlined;
      case 'BPJS':
        return Icons.assignment_ind_outlined;
      case 'Nomor Asuransi':
        return Icons.medical_services_outlined;
      default:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background gradient yang adaptif dengan tema
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.black, Colors.grey[900]!]
                    : [primaryColor.withOpacity(0.9), theme.scaffoldBackgroundColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Lingkaran dekoratif dengan opacity
          Positioned(
            top: -100,
            left: -50,
            child: _buildCircle(200, primaryColor.withOpacity(0.3)),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: _buildCircle(300, primaryColor.withOpacity(0.1)),
          ),

          // Konten utama login
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  // Logo dengan animasi simple fade-in
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) => Opacity(opacity: value, child: child),
                    child: Image.asset(
                      isDark ? 'assets/logo_dark.png' : 'assets/logo.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Card(
                    elevation: 18,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    shadowColor: primaryColor.withOpacity(0.5),
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Selamat Datang',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                shadows: [
                                  Shadow(
                                    color: primaryColor.withOpacity(0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Silakan masuk untuk melanjutkan',
                              style: TextStyle(
                                fontSize: 16,
                                color: primaryColor.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 32),

                            DropdownButtonFormField<String>(
                              value: loginType,
                              decoration: InputDecoration(
                                labelText: 'Pilih Metode Login',
                                prefixIcon: Icon(Icons.login, color: primaryColor),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              items: loginTypes
                                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  loginType = val!;
                                  identifier = '';
                                });
                              },
                            ),

                            const SizedBox(height: 20),

                            TextFormField(
                              keyboardType: loginType == 'Email'
                                  ? TextInputType.emailAddress
                                  : TextInputType.number,
                              onChanged: (val) => identifier = val,
                              validator: _validateIdentifier,
                              decoration: InputDecoration(
                                prefixIcon: Icon(_getPrefixIcon(), color: primaryColor),
                                labelText: loginType,
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),

                            const SizedBox(height: 20),

                            TextFormField(
                              obscureText: true,
                              onChanged: (val) => password = val,
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Password wajib diisi';
                                if (val.length < 6) return 'Password minimal 6 karakter';
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                                labelText: 'Password',
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                                child: Text(
                                  'Lupa Password?',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            CheckboxListTile(
                              value: rememberMe,
                              onChanged: (val) => setState(() => rememberMe = val ?? false),
                              title: const Text('Ingat saya'),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: primaryColor,
                              contentPadding: EdgeInsets.zero,
                            ),

                            const SizedBox(height: 20),

                            GestureDetector(
                              onTapDown: (_) => _buttonAnimationController.forward(),
                              onTapUp: (_) => _buttonAnimationController.reverse(),
                              onTapCancel: () => _buttonAnimationController.reverse(),
                              onTap: _login,
                              child: AnimatedBuilder(
                                animation: _buttonAnimationController,
                                builder: (context, child) {
                                  double scale = 1 - _buttonAnimationController.value;
                                  return Transform.scale(scale: scale, child: child);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [primaryColor, primaryColor.withOpacity(0.8)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.6),
                                        offset: const Offset(0, 6),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            ElevatedButton.icon(
                              icon: const Icon(Icons.fingerprint),
                              label: Text(_isAuthenticating
                                  ? 'Mengenali...'
                                  : 'Login dengan Biometrik'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: _isAuthenticating ? null : _authenticate,
                            ),

                            const SizedBox(height: 24),

                            Text(
                              'Atau login dengan',
                              style: TextStyle(
                                color: primaryColor.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialButton(
                                  controller: _googleButtonController,
                                  icon: Image.asset('assets/google_icon.png', height: 20),
                                  label: 'Google',
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black87,
                                  onTap: () {
                                    // Placeholder Google Sign-In integration
                                    // TODO: Implement actual Google Sign-In here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Google Sign-In belum diimplementasi')),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                _buildSocialButton(
                                  controller: _appleButtonController,
                                  icon: Image.asset('assets/apple_icon.png', height: 20),
                                  label: 'Apple',
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  onTap: () {
                                    // Placeholder Apple Sign-In integration
                                    // TODO: Implement actual Apple Sign-In here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Apple Sign-In belum diimplementasi')),
                                    );
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text(
                                'Belum punya akun? Daftar di sini',
                                style: TextStyle(
                                  color: primaryColor,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildSocialButton({
    required AnimationController controller,
    required Widget icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTapDown: (_) => controller.forward(),
      onTapUp: (_) => controller.reverse(),
      onTapCancel: () => controller.reverse(),
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          double scale = 1 - controller.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: ElevatedButton.icon(
          onPressed: null,
          icon: icon,
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            minimumSize: const Size(140, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 5,
          ),
        ),
      ),
    );
  }
}
