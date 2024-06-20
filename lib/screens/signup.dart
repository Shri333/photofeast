import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photofeast/helpers/snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _hidePassword = true, _loading = false;
  String? _emailErrorText, _passwordErrorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords must match';
    }
    return null;
  }

  void _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  Future<void> _signup() async {
    if (!_signupFormKey.currentState!.validate()) {
      return;
    }
    final (email, password) = (_emailController.text, _passwordController.text);
    setState(() {
      _loading = true;
    });
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          setState(() {
            _emailErrorText = 'This email is already in use';
          });
        case 'weak-password':
          setState(() {
            _passwordErrorText = 'Password is too weak';
          });
        default:
          if (mounted) {
            showErrorSnackbar(context);
          }
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context);
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 480.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _signupFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Signup',
                    style: themeData.textTheme.displayMedium?.copyWith(
                      color: themeData.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail),
                      labelText: 'Email',
                      errorText: _emailErrorText,
                      border: const UnderlineInputBorder(),
                    ),
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Password',
                      errorText: _passwordErrorText,
                      border: const UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _toggleHidePassword,
                      ),
                    ),
                    validator: _passwordValidator,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Confirm password',
                      border: const UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _toggleHidePassword,
                      ),
                    ),
                    validator: _confirmPasswordValidator,
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _loading ? null : _signup,
                      child: _loading
                          ? const SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.0),
                            )
                          : const Text('Signup'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: themeData.textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: 'Log in',
                          style: themeData.textTheme.bodyMedium?.copyWith(
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go('/login');
                            },
                        ),
                      ],
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