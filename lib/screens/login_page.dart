import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.showRegisterPage});
  final VoidCallback showRegisterPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Use a GlobalKey to uniquely identify the Form and enable validation.
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State to manage loading and error messages
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // A helper function to show a snackbar with an error message
  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _signIn() async {
    // Check if the form is valid before attempting to sign in
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential' ||
          e.code == 'invalid-email') {
        _showErrorSnackbar('Invalid email or password.');
      } else {
        // Fallback for other unexpected errors.
        _showErrorSnackbar('An unknown error occurred. Please try again.');
        print('Firebase Auth Error: ${e.code}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.8),
              const Color.fromARGB(255, 128, 92, 212)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App Icon/Logo
                    Icon(
                      Icons.checklist_rtl_rounded,
                      size: 100,
                      color: theme.colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 10),
                    // Title
                    Text(
                      "Hello Again!",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Subtitle
                    Text(
                      "Welcome back, you've been missed!",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Email Text Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.poppins(
                          color: theme.colorScheme.onPrimary),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: theme.colorScheme.onPrimary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colorScheme.onPrimary, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Email",
                        hintStyle: GoogleFonts.poppins(
                            color:
                                theme.colorScheme.onPrimary.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.email_outlined,
                            color:
                                theme.colorScheme.onPrimary.withOpacity(0.8)),
                        fillColor: theme.colorScheme.secondary.withOpacity(0.2),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Password Text Field
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      style: GoogleFonts.poppins(
                          color: theme.colorScheme.onPrimary),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: theme.colorScheme.onPrimary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colorScheme.onPrimary, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Password",
                        hintStyle: GoogleFonts.poppins(
                            color:
                                theme.colorScheme.onPrimary.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.lock_outline,
                            color:
                                theme.colorScheme.onPrimary.withOpacity(0.8)),
                        fillColor: theme.colorScheme.secondary.withOpacity(0.2),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        // A basic length check for password validation
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    // Sign In Button
                    InkWell(
                      onTap: _isLoading ? null : _signIn,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: _isLoading
                                ? theme.colorScheme.onPrimary.withOpacity(0.5)
                                : theme.colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ]),
                        child: Center(
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: theme.colorScheme.primary)
                              : Text(
                                  "Sign in",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member? ",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: widget.showRegisterPage,
                          child: Text(
                            "Sign up now",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimary,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
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
