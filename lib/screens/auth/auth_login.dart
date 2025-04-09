import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kelimbo_admin/screens/main_dashboard.dart';
import 'package:kelimbo_admin/services/auth_methods.dart';
import 'package:kelimbo_admin/utils/color.dart';
import 'package:kelimbo_admin/utils/image_utils.dart';
import 'package:kelimbo_admin/widgets/save_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool showPassword = false; // Moved here to persist state

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pass = TextEditingController();

  // Toggle password visibility
  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 180,
                ),
                const SizedBox(height: 10),
                // Email Input Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: iconColor,
                      ),
                      filled: true,
                      fillColor: textColor,
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22)),
                          borderSide: BorderSide(
                            color: textColor,
                          )),
                      border: InputBorder.none,
                      hintText: "Correo electrónico",
                      hintStyle: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        color: iconColor,
                      ),
                    ),
                  ),
                ),
                // Password Input Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: !showPassword,
                    controller: pass,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(22)),
                            borderSide: BorderSide(
                              color: textColor,
                            )),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: textColor,
                        hintText: "Contraseña",
                        hintStyle: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          color: iconColor,
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: iconColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: toggleShowPassword,
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: iconColor,
                          ),
                        )),
                  ),
                ),
                const SizedBox(height: 40),
                // Login Button or Loading Indicator
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SaveButton(
                          title: "Iniciar sesión",
                          onTap: () async {
                            if (emailController.text.isEmpty ||
                                pass.text.isEmpty) {
                              showMessageBar(
                                  "Se requiere correo electrónico y contraseña",
                                  context);
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              String result = await AuthMethods().loginUpUser(
                                email: emailController.text.trim(),
                                pass: pass.text.trim(),
                              );
                              if (result == 'success') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => MainDashboard()),
                                );
                              } else {
                                showMessageBar(result, context);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
