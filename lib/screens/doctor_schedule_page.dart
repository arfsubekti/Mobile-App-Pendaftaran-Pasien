import 'package:flutter/material.dart';

class DoctorSchedulePage extends StatelessWidget {
  const DoctorSchedulePage({Key? key}) : super(key: key);

  final List<Map<String, String>> schedules = const [
    {
      'name': 'dr. Andi Setiawan',
      'specialist': 'Spesialis Anak',
      'day': 'Senin & Rabu',
      'time': '08:00 - 11:00'
    },
    {
      'name': 'dr. Maya Lestari',
      'specialist': 'Spesialis Kandungan',
      'day': 'Selasa & Kamis',
      'time': '10:00 - 13:00'
    },
    {
      'name': 'dr. Budi Santoso',
      'specialist': 'Dokter Umum',
      'day': 'Senin - Jumat',
      'time': '08:00 - 14:00'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.teal.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Dokter'),
        backgroundColor: primaryColor,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: schedules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = schedules[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              leading: Icon(Icons.person, size: 40, color: primaryColor),
              title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['specialist']!),
                  const SizedBox(height: 4),
                  Text('${item['day']} • ${item['time']}',
                      style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
