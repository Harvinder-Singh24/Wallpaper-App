import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:wallpaper/screens/emailverify_screen.dart';
import 'package:wallpaper/utils/colors.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  bool _isVisible = true;
  bool _isvisibleConfirm = true;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ShowUpAnimation(
            animationDuration: const Duration(seconds: 1),
            curve: Curves.bounceIn,
            direction: Direction.horizontal,
            offset: 0.2,
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                  ),
                  const Text(
                    "Create a new account",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 80),
                  TextFormField(
                    style: const TextStyle(color: Colors.black87),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "name is required";
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Image.asset('assets/icons/user.png'),
                        border: InputBorder.none,
                        hintText: "Name",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.black87),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon:
                            Image.asset('assets/icons/personalcard.png'),
                        border: InputBorder.none,
                        hintText: "email",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.black87),
                    obscureText: _isVisible,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Image.asset('assets/icons/lock1.png'),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isVisible = !_isVisible;
                              });
                            },
                            child: _isVisible
                                ? const Icon(Icons.visibility_rounded,
                                    color: Colors.grey)
                                : const Icon(Icons.visibility_off_rounded,
                                    color: Colors.grey)),
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _confirmpasswordController,
                    style: const TextStyle(color: Colors.black87),
                    obscureText: _isvisibleConfirm,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Confirm password is required";
                      }
                    },
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isvisibleConfirm = !_isvisibleConfirm;
                              });
                            },
                            child: _isvisibleConfirm
                                ? const Icon(Icons.visibility_rounded,
                                    color: Colors.grey)
                                : const Icon(Icons.visibility_off_rounded,
                                    color: Colors.grey)),
                        prefixIcon: Image.asset('assets/icons/lock1.png'),
                        border: InputBorder.none,
                        hintText: "Confirm Pasword",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_key.currentState!.validate()) {
                        setState(() {
                          _authService.isLoading = true;
                        });

                        if (_passwordController.text ==
                            _confirmpasswordController.text) {
                          _authService
                              .signUp(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) => {
                                    if (value == null)
                                      {
                                        print("Registered"),
                                        setState(() {
                                          _authService.isLoading = false;
                                        }),
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EmailVerification(
                                              user_email: _emailController.text,
                                            ),
                                          ),
                                        ),
                                      }
                                    else
                                      {
                                        setState(() {
                                          _authService.isLoading = false;
                                        }),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            value,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        )),
                                      }
                                  });
                        }
                      } else {
                        setState(() {
                          _authService.isLoading = false;
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Password Incorrect",
                            style: TextStyle(fontSize: 16),
                          ),
                        ));
                      }
                    },
                    child: Container(
                      width: 349,
                      height: 66,
                      decoration: BoxDecoration(
                        color: Colors.indigo[600],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: _authService.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text("Confirm",
                                style: TextStyle(
                                    color: backgroundColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
