// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.onLogin});
  final VoidCallback? onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String _role = 'Citizen';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, bc) {
      final width = bc.maxWidth;
      final cardW = width < 600 ? width * 0.94 : 480.0;
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: cardW),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 6),
                    Text('Welcome', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('Sign in to continue', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 18),
                    TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: DropdownButtonFormField<String>(value: _role, items: const [DropdownMenuItem(value: 'Citizen', child: Text('Citizen')), DropdownMenuItem(value: 'NGO', child: Text('NGO'))], onChanged: (v) => setState(() => _role = v ?? 'Citizen'))),
                    ]),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          MockDataService.setRole(_role);
                          widget.onLogin?.call();
                          // if no callback provided, pop
                          if (widget.onLogin == null) Navigator.of(context).pop();
                        },
                        child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Login')),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(onPressed: () {}, child: const Text('Need help?'))
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
