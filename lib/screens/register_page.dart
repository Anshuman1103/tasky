import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A StatefulWidget for the user registration page.
/// It contains a form for the user to enter their email and password
/// and handles the registration logic with Firebase Authentication.
class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.showLoginPage,
  });

  final VoidCallback showLoginPage;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

  /// Handles the user registration process.
  /// This function validates the form, sets the loading state,
  /// and attempts to create a new user with Firebase Authentication.
  Future<void> _register() async {
    // First, validate all form fields using the form key.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Use Firebase's createUserWithEmailAndPassword method to create a new user.
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // Catch and handle specific Firebase authentication exceptions.
      if (e.code == 'weak-password') {
        _showErrorSnackbar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorSnackbar('The account already exists for that email.');
      } else {
        // Handle any other unexpected errors.
        _showErrorSnackbar('An error occurred. Please try again.');
        print(e); // You can log the full error for debugging purposes.
      }
    } finally {
      // Always reset the loading state, regardless of success or failure.
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
                    // Title and subtitle text.
                    Text(
                      "Hello there!",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Please, fill up your details",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Email input field.
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

                    // Password input field.
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
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Confirm Password input field.
                    TextFormField(
                      obscureText: true,
                      controller: _confirmPasswordController,
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
                        hintText: "Confirm Password",
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
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text.trim()) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Register button. Shows a loading indicator when registering.
                    InkWell(
                      onTap: _isLoading ? null : _register,
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
                                  "Register",
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

                    // "Already a member?" row to navigate to the login page.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already a member? ",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: widget.showLoginPage,
                          child: Text(
                            "Sign in now",
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
