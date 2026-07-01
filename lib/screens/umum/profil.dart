import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../models/auth_model.dart';
import '../../services/profil_service.dart';
import '../../services/auth_service.dart';

class HalamanProfil extends StatefulWidget {
  const HalamanProfil({super.key});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil> {
  final _f = GlobalKey<FormBuilderState>();
  bool muat = false;
  bool muatData = true;
  AuthModel? dataProfil;
  final _layProfil = ProfilService();
  final _layAuth = AuthService();

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  Future<void> ambilData() async {
    try {
      dataProfil = await _layProfil.ambilDataProfil();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e'), backgroundColor: Colors.red)
      );
    } finally {
      if (mounted) setState(() => muatData = false);
    }
  }

  Future<void> simpanPerubahan() async {
    if (!_f.currentState!.saveAndValidate()) return;
    setState(() => muat = true);

    try {
      final d = _f.currentState!.value;
      await _layProfil.perbaruiProfil({
        'nama': d['nama'],
        'noHp': d['noHp'],
      });

      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green)
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal simpan: $e'), backgroundColor: Colors.red)
      );
    } finally {
      if (mounted) setState(() => muat = false);
    }
  }

  Future<void> keluarAkun() async {
    await _layAuth.keluar();
    if (mounted) context.go('/masuk');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: SafeArea(
        child: muatData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: FormBuilder(
                key: _f,
                initialValue: {
                  'nama': dataProfil?.nama ?? '',
                  'email': dataProfil?.email ?? '',
                  'noHp': dataProfil?.noHp ?? '',
                },
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.warnaUtama,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 30),

                    FormBuilderTextField(
                      name: 'nama',
                      decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 15),

                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(labelText: 'Email', helperText: 'Email tidak bisa diubah'),
                      enabled: false,
                    ),
                    const SizedBox(height: 15),

                    FormBuilderTextField(
                      name: 'noHp',
                      decoration: const InputDecoration(labelText: 'Nomor HP'),
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.minLength(10),
                      ]),
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: muat ? null : simpanPerubahan,
                        child: muat
                          ? const SizedBox(width:22, height:22, child: CircularProgressIndicator(strokeWidth:2, color:Colors.white))
                          : const Text('SIMPAN PERUBAHAN', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text('Keluar Akun', style: TextStyle(color: Colors.red)),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text('Yakin ingin keluar dari akun ini?'),
                            actions: [
                              TextButton(onPressed: ()=>Navigator.pop(c), child: const Text('Batal')),
                              TextButton(onPressed: (){Navigator.pop(c); keluarAkun();}, child: const Text('Keluar', style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
