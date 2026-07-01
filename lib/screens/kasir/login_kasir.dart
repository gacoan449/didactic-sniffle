import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/kasir_provider.dart';

class HalamanLoginKasir extends ConsumerStatefulWidget {
  const HalamanLoginKasir({super.key});
  @override
  ConsumerState<HalamanLoginKasir> createState() => _HalamanLoginKasirState();
}

class _HalamanLoginKasirState extends ConsumerState<HalamanLoginKasir> {
  final _ctrlId = TextEditingController();
  final _ctrlPin = TextEditingController();
  bool _sedang = false;

  Future<void> _masuk() async {
    if (_ctrlId.text.trim().isEmpty) {
      _pesan('Harap isi ID Kasir');
      return;
    }
    if (_ctrlPin.text.trim().length < 4) {
      _pesan('PIN minimal 4 digit');
      return;
    }

    setState(() => _sedang = true);
    try {
      await ref.read(
        loginKasirProvider({
          'idKasir': _ctrlId.text.trim(),
          'pin': _ctrlPin.text.trim(),
        }).future,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/kasir-dashboard');
      }
    } catch (e) {
      if (mounted) _pesan(e.toString());
    } finally {
      if (mounted) setState(() => _sedang = false);
    }
  }

  void _pesan(String teks) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(teks), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Kasir')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.point_of_sale,
                    size: 80,
                    color: AppTheme.warnaUtama,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _ctrlId,
                    decoration: const InputDecoration(
                      labelText: 'ID Kasir / UID Akun',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    enabled: !_sedang,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ctrlPin,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'PIN Akses',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    enabled: !_sedang,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _sedang ? null : _masuk,
                      child: _sedang
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'MASUK KE SISTEM',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
