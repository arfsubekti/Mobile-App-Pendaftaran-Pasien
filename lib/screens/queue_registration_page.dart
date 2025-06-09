import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class QueueRegistrationPage extends StatefulWidget {
  const QueueRegistrationPage({super.key});

  @override
  State<QueueRegistrationPage> createState() => _QueueRegistrationPageState();
}

class _QueueRegistrationPageState extends State<QueueRegistrationPage> {
  final Color primaryColor = Colors.teal.shade700;

  final List<String> poliList = ['Poli Umum', 'Poli Gigi', 'Poli Anak'];
  final Map<String, List<String>> dokterMap = {
    'Poli Umum': ['Dr. Andi', 'Dr. Sari'],
    'Poli Gigi': ['Drg. Budi', 'Drg. Rina'],
    'Poli Anak': ['Dr. Tono', 'Dr. Ayu'],
  };

  String? selectedPoli;
  String? selectedDokter;
  DateTime? selectedDate;
  TextEditingController keluhanController = TextEditingController();

  String? nomorAntrean;

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _submitAntrean() {
    if (selectedPoli == null ||
        selectedDokter == null ||
        selectedDate == null ||
        keluhanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
      return;
    }

    final nomor = 'A-${(1 + (DateTime.now().millisecondsSinceEpoch % 99)).toString().padLeft(2, '0')}';
    setState(() => nomorAntrean = nomor);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('✅ Pendaftaran Berhasil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nomor Antrean Anda:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              nomorAntrean!,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 16),
            Text('Tanggal: ${DateFormat('dd MMMM yyyy').format(selectedDate!)}'),
            Text('Poli: $selectedPoli'),
            Text('Dokter: $selectedDokter'),
            Text('Keluhan: ${keluhanController.text}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, nomorAntrean);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    keluhanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          '🩺 Daftar Antrean',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: primaryColor.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.local_hospital, size: 48, color: primaryColor),
                      const SizedBox(height: 8),
                      Text(
                        'Formulir Pendaftaran Antrean',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                _buildDropdown(
                  label: '🧑‍⚕️ Poli Tujuan',
                  value: selectedPoli,
                  items: poliList,
                  onChanged: (val) {
                    setState(() {
                      selectedPoli = val;
                      selectedDokter = null;
                    });
                  },
                ),
                const SizedBox(height: 20),

                _buildDropdown(
                  label: '👨‍⚕️ Pilih Dokter',
                  value: selectedDokter,
                  items: selectedPoli != null ? dokterMap[selectedPoli]! : [],
                  onChanged: (val) {
                    setState(() => selectedDokter = val);
                  },
                ),
                const SizedBox(height: 20),

                Text('📅 Tanggal Berobat', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate != null
                              ? DateFormat('dd MMMM yyyy').format(selectedDate!)
                              : 'Pilih Tanggal',
                          style: GoogleFonts.poppins(
                            color: selectedDate != null ? Colors.black : Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.calendar_today, color: primaryColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text('📝 Keluhan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: keluhanController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Masukkan keluhan Anda',
                    hintStyle: GoogleFonts.poppins(),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.how_to_reg),
                    onPressed: _submitAntrean,
                    label: Text(
                      'Ambil Nomor Antrean',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
} 
