import 'package:flutter/material.dart';
import 'form_pendaftaran_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.teal.shade700;
    final secondaryColor = Colors.teal.shade200;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Pendaftaran Pasien', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor.withOpacity(0.3), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuButton(
                context,
                icon: Icons.person_add_alt_1,
                label: 'Daftar Pasien Baru',
                color: primaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FormPendaftaranScreen()),
                  );
                },
              ),
              SizedBox(height: 32),
              _buildMenuButton(
                context,
                icon: Icons.schedule,
                label: 'Cek Jadwal / Status',
                color: primaryColor.withOpacity(0.8),
                onPressed: () {
                  // nanti disiapkan
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fitur ini akan segera hadir')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(double.infinity, 60),
        elevation: 6,
        shadowColor: color.withOpacity(0.5),
      ),
      onPressed: onPressed,
    );
  }
}
