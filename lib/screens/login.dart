import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../helpers/alert.dart';
import '../widgets/scroll.dart';
import '../widgets/spinner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true, _loading = false;
  String? _emailErrorText, _passwordErrorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  void _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text;
    if (email.isEmpty) {
      setState(() {
        _emailErrorText = 'Please enter your email';
      });
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        showAlert(context, 'Password Reset',
            'A password reset email has been sent to $email');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          setState(() {
            _emailErrorText = 'Please enter a valid email address';
          });
        case 'user-not-found':
          setState(() {
            _emailErrorText = 'No user exists with the given email';
          });
        default:
          if (mounted) {
            showErrorAlert(context);
          }
      }
    } catch (e) {
      if (mounted) {
        showErrorAlert(context);
      }
    }
  }

  Future<void> _login() async {
    setState(() {
      _emailErrorText = _passwordErrorText = null;
    });
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    final (email, password) = (_emailController.text, _passwordController.text);
    setState(() {
      _loading = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          setState(() {
            _emailErrorText = 'Please enter a valid email address';
          });
        case 'user-disabled':
          setState(() {
            _emailErrorText = 'The user with the given email has been disabled';
          });
        case 'invalid-credential' || 'user-not-found' || 'wrong-password':
          setState(() {
            _emailErrorText = _passwordErrorText = 'Wrong email or password';
          });
        default:
          if (mounted) {
            showErrorAlert(context);
          }
      }
    } catch (e) {
      if (mounted) {
        showErrorAlert(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: Scroll(
        child: Center(
          child: SizedBox(
            width: 480.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
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
                      onFieldSubmitted: (value) {
                        if (!_loading) {
                          _login();
                        }
                      },
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: _forgotPassword,
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loading ? null : _login,
                        child: _loading ? const Spinner() : const Text('Login'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            context.go('/signup');
                          },
                          child: const Text('Sign up'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
