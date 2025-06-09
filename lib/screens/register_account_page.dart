import 'package:flutter/material.dart';

class RegisterAccountPage extends StatefulWidget {
  @override
  State<RegisterAccountPage> createState() => _RegisterAccountPageState();
}

class _RegisterAccountPageState extends State<RegisterAccountPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confirmPassword = '';

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password dan konfirmasi tidak sama')),
        );
        return;
      }

      // Simulasi register berhasil, balik ke login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Akun berhasil dibuat, silakan login')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Akun Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (val) => email = val,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Email wajib diisi';
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (val) => password = val,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Password wajib diisi';
                  if (val.length < 6)
                    return 'Password minimal 6 karakter';
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Konfirmasi Password'),
                obscureText: true,
                onChanged: (val) => confirmPassword = val,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Konfirmasi password wajib diisi';
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(onPressed: _register, child: Text('Daftar')),
            ],
          ),
        ),
      ),
    );
  }
}
