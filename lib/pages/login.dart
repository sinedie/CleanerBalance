import 'package:clear_balance/db/auth.dart';
import 'package:clear_balance/utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  final Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  onSubmit() {
    if (_formKey.currentState!.validate()) {
      loginWithEmail(
        controllers['email']!.text,
        controllers['password']!.text,
      ).then((user) {
        if (context.mounted) {
          context.go("/transactions");
        }
      });

      return;
    }

    showSnackBar(context, "Error while logging in", type: "danger");
  }

  String? _validateEmail(String? value) {
    if (value == null ||
        value.isEmpty ||
        !value.contains('@') ||
        !value.contains('.')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid password';
    }
    return null;
  }

  _showPassword() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 15,
        alignment: WrapAlignment.center,
        children: [
          const Text(
            "Iniciar sesion",
            style: TextStyle(fontSize: 18),
          ),
          TextFormField(
            controller: controllers['email'],
            validator: _validateEmail,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
          ),
          TextFormField(
            controller: controllers['password'],
            obscureText: _isObscure,
            validator: _validatePassword,
            decoration: InputDecoration(
              labelText: "Password",
              suffixIcon: IconButton(
                onPressed: _showPassword,
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
          ),
          MaterialButton(
            minWidth: double.infinity,
            height: 45,
            color: Theme.of(context).primaryColor,
            onPressed: onSubmit,
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }
}
