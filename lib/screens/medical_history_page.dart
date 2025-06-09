import 'package:flutter/material.dart';

class MedicalHistoryPage extends StatelessWidget {
  const MedicalHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.teal.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Berobat'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Text(
          'Belum ada data riwayat berobat.',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
