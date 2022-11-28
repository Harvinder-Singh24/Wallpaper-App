import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:wallpaper/services/auth_service.dart';
import 'package:wallpaper/utils/colors.dart';
import '../provider/connectivity_provider.dart';
import '../utils/helper.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isVisible = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthService _authService = AuthService();
  bool _isLoading = false;
  @override
  void initState() {
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: finalUI(),
    );
  }

  Widget finalUI() {
    return Consumer<ConnectivityProvider>(builder: (context, model, child) {
      if (model.isOnline != null) {
        return model.isOnline ?? false ? loginUI() : NoInternet();
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget loginUI() {
    return SafeArea(
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
                    "Login",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                  ),
                  const Text(
                    "Login to your account",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 80),
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
                        prefixIcon: Image.asset('assets/icons/lock1.png'),
                        border: InputBorder.none,
                        hintText: "password",
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
                    onTap: () async {
                      if (_key.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        SharedPreferences sharedpreference =
                            await SharedPreferences.getInstance();
                        _authService
                            .signIn(
                                email: _emailController.text,
                                password: _passwordController.text)
                            .then((value) => {
                                  if (value == null)
                                    {
                                      setState(() {
                                        _isLoading = false;
                                      }),
                                      sharedpreference.setBool('islogin', true),
                                      sharedpreference.setString(
                                          "email", _emailController.text),
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ))
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          value,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      )),
                                    }
                                });
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
                            : Text(
                                "Login",
                                style: TextStyle(
                                    color: backgroundColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                      ),
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
