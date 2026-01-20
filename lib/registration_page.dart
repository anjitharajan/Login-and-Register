import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String name = '';
  String email = '';
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value != null && value.isNotEmpty
                          ? null
                          : 'Enter name',
                  onSaved: (value) => name = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value != null && value.contains('@')
                          ? null
                          : 'Enter valid email',
                  onSaved: (value) => email = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration:
                      const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value != null && value.length >= 6
                          ? null
                          : 'Minimum 6 characters',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                      labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) =>
                      value == _passwordController.text
                          ? null
                          : 'Passwords do not match',
                ),
                const SizedBox(height: 16),
                if (errorMessage != null)
                  Text(errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 24),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        child: const Text('Register'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() => isLoading = true);

                            final error =
                                await authService.register(
                              name,
                              email,
                              _passwordController.text,
                            );

                            setState(() {
                              isLoading = false;
                              errorMessage = error;
                            });

                            if (error == null) {
                              Navigator.pushReplacementNamed(
                                  context, '/login');
                            }
                          }
                        },
                      ),
                      SizedBox(height: 16,),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
