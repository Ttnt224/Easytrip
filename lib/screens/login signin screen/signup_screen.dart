import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapplication/screens/login%20signin%20screen/login_screen.dart';
import 'package:myapplication/widgets/textform_widget.dart';
//import 'package:myapplication/widgets/button_widget.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Image.network(
                            "https://img.freepik.com/premium-vector/travel-around-world-online-journey-couple-is-planning-their-trip-choosing-best-route-travel-agency-tour-abroad-color-vector-illustration-flat-style_776652-2239.jpg",
                            height: 300,
                            width: 300,
                            fit: BoxFit.contain,
                          ),
                          //email textfield
                          MyTextfield(
                            controller: emailController,
                            labeltext: "อีเมล",
                            hintText: "example@gmail.com",
                            obsecureText: passwordVisible,
                            prefixicon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "กรุณากรอกอีเมล";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          //password textfield
                          MyTextfield(
                            controller: passwordController,
                            labeltext: "รหัสผ่าน",
                            hintText: "",
                            obsecureText: passwordVisible,
                            prefixicon: Icons.lock,
                            suffixicon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "กรุณากรอกรหัสผ่าน";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          //button ปุ่ม sign up
                          FilledButton(
                            onPressed: () {
                              _formKey.currentState!.validate();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                21,
                                20,
                                95,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 125,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              "สร้างบัญชี",
                              style: GoogleFonts.kanit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text("หรือ", style: GoogleFonts.kanit()),
                              ),
                              Expanded(child: Divider(color: Colors.grey[300])),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "มีบัญชีแล้ว?",
                                style: GoogleFonts.kanit(fontSize: 18),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "เข้าสู่ระบบ",
                                  style: GoogleFonts.kanit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
