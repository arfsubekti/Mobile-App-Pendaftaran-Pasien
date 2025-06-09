import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientRegistrationPage extends StatefulWidget {
  const PatientRegistrationPage({super.key});

  @override
  State<PatientRegistrationPage> createState() => _PatientRegistrationPageState();
}

class _PatientRegistrationPageState extends State<PatientRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  DateTime? selectedBirthDate;
  String? selectedInsurance;

  final Color primaryColor = Colors.teal.shade700;

  final List<String> insuranceOptions = [
    'BPJS',
    'Inhealth',
    'Yankes Telkom',
    'Umum',
  ];

  void _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedBirthDate = picked);
    }
  }

  void _clearBirthDate() {
    setState(() => selectedBirthDate = null);
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih tanggal lahir')),
      );
      return;
    }
    if (selectedInsurance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih jenis asuransi')),
      );
      return;
    }

    String dataSummary = '''
Nama: ${nameController.text}
NIK: ${nikController.text}
Tanggal Lahir: ${DateFormat('dd MMMM yyyy').format(selectedBirthDate!)}
Alamat: ${addressController.text}
No. Telepon: ${phoneController.text}
Jenis Asuransi: $selectedInsurance
''';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pendaftaran Berhasil'),
        content: Text(dataSummary),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, 'success');
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    nikController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryColor, width: 2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Pasien Baru'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Nama Lengkap',
                controller: nameController,
                validator: (val) => val == null || val.isEmpty ? 'Nama wajib diisi' : null,
                icon: Icons.person,
                decoration: inputDecoration,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                label: 'NIK',
                controller: nikController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'NIK wajib diisi';
                  if (val.length != 16) return 'NIK harus 16 digit';
                  return null;
                },
                icon: Icons.badge,
                decoration: inputDecoration,
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tanggal Lahir',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade800),
                ),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _pickBirthDate,
                    child: InputDecorator(
                      decoration: inputDecoration.copyWith(
                        errorText: selectedBirthDate == null ? 'Tanggal lahir wajib dipilih' : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedBirthDate != null
                                ? DateFormat('dd MMMM yyyy').format(selectedBirthDate!)
                                : 'Pilih Tanggal Lahir',
                            style: TextStyle(
                              color: selectedBirthDate != null ? Colors.black87 : Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.calendar_today, color: primaryColor),
                        ],
                      ),
                    ),
                  ),
                  if (selectedBirthDate != null)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: InkWell(
                        onTap: _clearBirthDate,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.clear, size: 20),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              _buildTextField(
                label: 'Alamat',
                controller: addressController,
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'Alamat wajib diisi' : null,
                icon: Icons.home,
                decoration: inputDecoration,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                label: 'No. Telepon',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? 'No. telepon wajib diisi' : null,
                icon: Icons.phone,
                decoration: inputDecoration,
              ),
              const SizedBox(height: 20),

              // Dropdown Asuransi
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Jenis Asuransi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade800),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedInsurance,
                decoration: inputDecoration.copyWith(
                  labelText: 'Pilih Jenis Asuransi',
                ),
                items: insuranceOptions
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() => selectedInsurance = val);
                },
                validator: (val) => val == null || val.isEmpty ? 'Jenis asuransi wajib dipilih' : null,
                iconEnabledColor: primaryColor,
                dropdownColor: Colors.white,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Daftar Pasien Baru',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    IconData? icon,
    InputDecoration? decoration,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: decoration?.copyWith(
            labelText: label,
            prefixIcon: icon != null ? Icon(icon, color: Colors.teal.shade700) : null,
          ) ??
          InputDecoration(
            labelText: label,
            prefixIcon: icon != null ? Icon(icon, color: Colors.teal.shade700) : null,
            border: const OutlineInputBorder(),
          ),
    );
  }
}
