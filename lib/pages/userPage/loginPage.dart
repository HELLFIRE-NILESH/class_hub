import 'package:flutter/material.dart';
import '../../api_data/login.dart';
import '../../nav/navbar.dart';
import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _rollNoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// **Login User**
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final response = await ApiService.login(_rollNoController.text, _passwordController.text,);

      setState(() => _isLoading = false);

      if (response["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login successful')));

        // Navigate to Home Page (NavView) and replace login screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavView()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response["message"])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/icons/logo2.png', height: 100),
                      const SizedBox(height: 24),
                
                      // Roll No Field
                      TextFormField(
                        controller: _rollNoController,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                          labelText: 'Roll No',
                          prefixIcon: const Icon(Icons.person),
                        ),
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        validator: (value) => value == null || value.isEmpty ? 'Enter Roll No' : null,
                      ),
                
                      const SizedBox(height: 16),
                
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscureText = !_obscureText),
                          ),
                        ),
                        obscureText: _obscureText,
                        textInputAction: TextInputAction.done,
                        validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
                      ),
                      const SizedBox(height: 20),
                
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,

                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Login', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 20),

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
}
