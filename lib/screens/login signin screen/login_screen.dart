import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapplication/screens/login%20signin%20screen/signup_screen.dart';
import 'package:myapplication/widgets/textform_widget.dart';
//import 'package:myapplication/widgets/button_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          //ไล่สี
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
                        horizontal: 20,
                        vertical: 30,
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          //Logo
                          Image.network(
                            "https://img.freepik.com/premium-vector/welcome-illustration-this-friendly-design-featuring-welcoming-figure-is-perfect-websites_146120-1612.jpg",
                            height: 250,
                            width: 250,
                            fit: BoxFit.contain,
                          ),
                          //textformfield login
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
                          //textformfield password
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
                          const SizedBox(height: 7),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  //ไว้ใส่ path ตอนกดลืมรหัสผ่าน
                                },
                                child: Text(
                                  "ลืมรหัสผ่าน?",
                                  style: GoogleFonts.kanit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          ////button for login
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
                              "เข้าสู่ระบบ",
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
                          SizedBox(height: 15),
                          //text and textbutt for navi signup page
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "ยังไม่มีบัญชีใช่ไหม?",
                                  style: GoogleFonts.kanit(fontSize: 18),
                                ),
                                TextButton(
                                  //navi to sign up page
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Signup(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "สร้างบัญชี",
                                    style: GoogleFonts.kanit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
