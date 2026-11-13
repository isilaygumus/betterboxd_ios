import 'package:flutter/material.dart';
import '../../api_service.dart';
import '../../auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();

  bool _loading = false;

  static final _usernameRegex = RegExp(r'^[a-zA-Z0-9._-]+$');
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*\d).+$');

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String? _validateUsername(String? value){
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Kullanıcı adı zorunludur.';
    if (v.length < 3 || v.length > 20) return 'Kullanıcı adı 3-20 karakter olmalı.';
    if (!_usernameRegex.hasMatch(v)){
      return 'Sadece İngilizce harf, rakam ve . _ - kullanılabilir.';
    }
    return null;
  }

  String? _validateEmail(String? value){
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'E-posta zorunludur.';
    if (!_emailRegex.hasMatch(v)) return 'Geçerli bir e-posta girin.';
    return null;

  }

  String? _validatePassword(String? value){
    final v = value ?? '';
    if (v.isEmpty) return 'Şifre zorunludur.';
    if (v.length < 8) return 'Şifre en az 8 karakter olmalı.';
    if (!_passwordRegex.hasMatch(v)){
      return 'Şifre en az bir küçük harf, bir büyük harf, bir rakam ve bir özel karakter içermelidir.';
    }
    return null;
  }

    String? _validatePassword2(String? value) {
    if (value == null || value.isEmpty) return 'Şifreyi tekrar girin.';
    if (value != _passwordController.text) return 'Şifreler eşleşmiyor.';
    return null;
  }


  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final user = await ApiService().registerUser(
        _usernameController.text.trim(), 
        _emailController.text.trim(), 
        _passwordController.text,
        );

      if (!mounted) return;

      AuthService.login(user);
      _showMessage('Hoş geldin, ${AuthService.userName}!');
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      _showMessage('Sunucuya bağlanılamadı');
      
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Icon(Icons.person_add_alt_1_outlined, size: 72),
                  const SizedBox(height: 16),
                  const Text(
                    'Aramıza Katıl',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 36),
                  TextFormField(
                    controller: _usernameController,
                    validator: _validateUsername,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'E-posta',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    validator: _validatePassword,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      helperText: 'En az 8 karakter, bir küçük harf, bir büyük harf, bir özel karakter ve bir rakam.',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password2Controller,
                    validator: _validatePassword2,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _loading ? null : _register(),
                    decoration: const InputDecoration(
                      labelText: 'Şifre Tekrar',
                      prefixIcon: Icon(Icons.lock_reset_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Hesap Oluştur'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Zaten bir hesabın var mı? Giriş Yap'),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}