import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
   LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title:  Text('Login')),
      body: Padding(
        padding:  EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration:  InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value != null && value.contains('@')
                        ? null
                        : 'Enter valid email',
                onSaved: (value) => email = value!.trim(),
              ),
               SizedBox(height: 16),
              TextFormField(
                decoration:  InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value != null && value.length >= 6
                        ? null
                        : 'Minimum 6 characters',
                onSaved: (value) => password = value!,
              ),
                Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child:  Text('Forgot Password?'),
                ),
              ),
               SizedBox(height: 16),
              if (errorMessage != null)
                Text(errorMessage!, style:  TextStyle(color: Colors.red)),
               SizedBox(height: 16),
              isLoading
                  ?  CircularProgressIndicator()
                  : ElevatedButton(
                      child:  Text('Login'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() => isLoading = true);

                          final error =
                              await authService.login(email, password);

                          setState(() {
                            isLoading = false;
                            errorMessage = error;
                          });
                        }
                      },
                    ),
               SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child:  Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
