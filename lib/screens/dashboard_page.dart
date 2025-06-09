import 'dart:async';
import 'package:flutter/material.dart';

import 'medical_history_page.dart';
import 'doctor_schedule_page.dart';
import 'queue_registration_page.dart';
import 'patient_registration_page.dart';
import 'profile_page.dart';

// Buat placeholder halaman Berita dan FAQ dulu supaya lengkap
class BeritaPage extends StatelessWidget {
  const BeritaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Halaman Berita', style: TextStyle(fontSize: 20)));
  }
}

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Halaman FAQ', style: TextStyle(fontSize: 20)));
  }
}

class DashboardPage extends StatefulWidget {
  final VoidCallback logoutCallback;

  const DashboardPage({Key? key, required this.logoutCallback}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Color primaryColor = Colors.teal.shade700;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedIndex = 0;
  Timer? _timer;

  final List<String> images = [
    'https://picsum.photos/800/400?image=1050',
    'https://picsum.photos/800/400?image=1049',
    'https://picsum.photos/800/400?image=1062',
  ];

  @override
  void initState() {
    super.initState();
    // Timer untuk ganti gambar carousel otomatis
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _currentPage = (_currentPage + 1) % images.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Daftar halaman BottomNavigationBar
  late final List<Widget> _pages = [
    _buildHomePage(),
    const BeritaPage(),
    const FAQPage(),
    ProfilePage(
      onLogout: () {
        widget.logoutCallback();
        Navigator.pushReplacementNamed(context, '/login');
      },
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              widget.logoutCallback();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: const Text(
                'Selamat Datang',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                // TODO: Navigasi ke halaman pengaturan
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang Aplikasi'),
              onTap: () {
                // TODO: Tampilkan info aplikasi atau navigasi
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Berita'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'FAQ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                  ),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 10 : 8,
                height: _currentPage == index ? 10 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? primaryColor : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildMenuButton('Jadwal Dokter', Icons.calendar_today, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DoctorSchedulePage()),
                  );
                }),
                _buildMenuButton('Riwayat Berobat', Icons.history, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MedicalHistoryPage()),
                  );
                }),
                _buildMenuButton('Pelayanan Pendaftaran\n(Antrean)', Icons.list_alt, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QueueRegistrationPage()),
                  );
                }),
                _buildMenuButton('Pasien Baru', Icons.person_add_alt_1, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PatientRegistrationPage()),
                  );
                }),
                _buildMenuButton('Konsultasi Dokter', Icons.chat_bubble_outline, () {
                  // TODO: Navigasi ke halaman konsultasi dokter
                }),
                _buildMenuButton('Pengaduan', Icons.report_problem_outlined, () {
                  // TODO: Navigasi ke halaman pengaduan
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: primaryColor),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
