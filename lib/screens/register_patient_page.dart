import 'package:flutter/material.dart';

class RegisterPatientPage extends StatefulWidget {
  @override
  State<RegisterPatientPage> createState() => _RegisterPatientPageState();
}

class _RegisterPatientPageState extends State<RegisterPatientPage> {
  final _formKey = GlobalKey<FormState>();

  String noRkmMedis = '';
  String nmPasien = '';
  String noKtp = '';
  String jk = 'L';
  String tmpLahir = '';
  DateTime? tglLahir;
  String alamat = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data pasien berhasil didaftarkan')),
      );
      _formKey.currentState!.reset();
      setState(() {
        jk = 'L';
        tglLahir = null;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tglLahir ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != tglLahir) {
      setState(() {
        tglLahir = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple.shade700;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 16,
              shadowColor: primaryColor.withOpacity(0.6),
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Registrasi Pasien Baru',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 24),

                      _buildTextField(
                        label: 'No. RM',
                        onChanged: (val) => noRkmMedis = val,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'No. RM wajib diisi';
                          return null;
                        },
                        prefixIcon: Icons.confirmation_num_outlined,
                        keyboardType: TextInputType.text,
                      ),

                      SizedBox(height: 16),

                      _buildTextField(
                        label: 'Nama Pasien',
                        onChanged: (val) => nmPasien = val,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Nama pasien wajib diisi';
                          return null;
                        },
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                      ),

                      SizedBox(height: 16),

                      _buildTextField(
                        label: 'No. KTP',
                        onChanged: (val) => noKtp = val,
                        prefixIcon: Icons.credit_card_outlined,
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Jenis Kelamin',
                          prefixIcon: Icon(Icons.wc_outlined, color: Colors.deepPurple),
                          filled: true,
                          fillColor: Colors.deepPurple.shade50,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.deepPurple.shade100),
                          ),
                        ),
                        value: jk,
                        items: [
                          DropdownMenuItem(child: Text('Laki-laki'), value: 'L'),
                          DropdownMenuItem(child: Text('Perempuan'), value: 'P'),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => jk = val);
                        },
                      ),

                      SizedBox(height: 16),

                      _buildTextField(
                        label: 'Tempat Lahir',
                        onChanged: (val) => tmpLahir = val,
                        prefixIcon: Icons.location_city_outlined,
                        keyboardType: TextInputType.text,
                      ),

                      SizedBox(height: 16),

                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: _buildTextField(
                            label: 'Tanggal Lahir',
                            onChanged: (_) {},
                            prefixIcon: Icons.calendar_today_outlined,
                            validator: (_) {
                              if (tglLahir == null) return 'Tanggal lahir wajib dipilih';
                              return null;
                            },
                            keyboardType: TextInputType.datetime,
                            // custom hint text based on selected date
                            hintText: tglLahir == null
                                ? 'Pilih tanggal lahir'
                                : '${tglLahir!.toLocal()}'.split(' ')[0],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      _buildTextField(
                        label: 'Alamat',
                        onChanged: (val) => alamat = val,
                        prefixIcon: Icons.home_outlined,
                        keyboardType: TextInputType.multiline,
                      ),

                      SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                          ),
                          child: Text(
                            'Daftar Pasien',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
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
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    bool obscureText = false,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.deepPurple) : null,
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.deepPurple.shade100),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
      maxLines: keyboardType == TextInputType.multiline ? null : 1,
    );
  }
}
