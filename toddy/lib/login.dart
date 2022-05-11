import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toddy/ResetPassoword.dart';
import 'package:toddy/SignUp.dart';
import 'package:http/http.dart' as http;

import 'onboarding.dart';
import 'user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// Future<http.Response> login(String email, String password) async {
//   return http.post(
//     Uri.parse('http://127.0.0.1:8000/api/login/'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       "email": email,
//       "password": password,
//     }),
//   );
// }

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  String email = "";
  String password = "";

  Future alertDialog(String text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          title: Text("Alerta!", style: TextStyle(fontSize: 28)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 15,
                child: Text(
                  //'Please rate with star',
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmailTF() {
    email = emailController.text;
    return SizedBox(
      width: 300,
      child: TextFormField(
        validator: (value) {
          if (value!.length < 5) {
            return "Email muito curto";
          } else if (!value.contains("@")) {
            return "Email Inválido";
          }
          return null;
        },
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(
            fontSize: 22,
            color: Color(0xffFFFFFF),
          ),
          filled: true,
          fillColor: Color(0xffBDBDBD),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(
              color: Color(0xffBDBDBD),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTF() {
    return SizedBox(
      width: 300,
      child: TextFormField(
        validator: (value) {
          if (value!.length < 5) {
            return "Senha muito curto";
          }
          return null;
        },
        controller: passwordController,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: TextStyle(
            fontSize: 22,
            color: Color(0xffFFFFFF),
          ),
          filled: true,
          fillColor: Color(0xffBDBDBD),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(
              color: Color(0xffBDBDBD),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  String _buildSignUpTF() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );

    return '$email, $password';
  }

  String _buildResetPasswordTF() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgetPassword()),
    );

    return '$email, $password';
  }

  Future<Object?> _buildLoginDateTF() async {
    email = emailController.text.toString();
    password = passwordController.text.toString();

    var url = Uri.parse('http://127.0.0.1:8000/api/login/');
    var response = await http
        .post(url, body: {'email': '$email', 'password': '$password'});

    if (email.length < 5) {
      return alertDialog("Email muito pequeno!");
    } else if (!email.contains("@")) {
      alertDialog("Email inválido!");
    } else if (password.length < 6) {
      return alertDialog("Senha muito pequena!");
    } else if (response.statusCode == 202)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    else
      alertDialog("Dados Incorretos!");
    return '$email, $password';
  }
  //   if (response.statusCode == 202)
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => OnboardingScreen()),
  //     );
  //   else
  //     alertDialog("Email inválido?");
  //   return '$email, $password';
  // }

  Widget _buildLoginTF() {
    email = emailController.text.toString();
    password = passwordController.text.toString();

    return TextButton(
      onPressed: () => print(_buildLoginDateTF()),
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xffFF5252),
        fixedSize: const Size(90, 40),
        primary: Colors.black,
      ),
      child: const Text(
        "Acessar",
        style: TextStyle(
          color: Color(0xffFFFFFF),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSignupTF() {
    return TextButton(
      onPressed: () => print(_buildSignUpTF()),
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xffFF5252),
        fixedSize: const Size(90, 40),
        primary: Colors.black,
      ),
      child: const Text(
        "Cadastrar",
        style: TextStyle(
          color: Color(0xffFFFFFF),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildForgetPasswordTF() {
    return TextButton(
      onPressed: (() => _buildResetPasswordTF()),
      style: TextButton.styleFrom(
        primary: Colors.black,
      ),
      child: const Text(
        "Perdi a senha",
        style: TextStyle(
          color: Color(0xff212121),
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Column(
          children: [
            Container(
              color: const Color(0xff388E3C),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              alignment: Alignment.topCenter,
            ),
            Container(
              height: 120,
              width: 120,
              margin: const EdgeInsets.all(30),
              child: SvgPicture.asset(
                'lib/assets/images/leaf.svg',
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Horti em Casa",
              style: TextStyle(
                fontSize: 28,
                color: Color(0xff212121),
              ),
            ),
            const SizedBox(height: 80),
            _buildEmailTF(),
            const SizedBox(height: 30),
            _buildPasswordTF(),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildLoginTF(),
              const SizedBox(width: 120),
              _buildSignupTF(),
            ]),
            const SizedBox(height: 30),
            _buildForgetPasswordTF(),
          ],
        ),
      ]),
    );
    throw UnimplementedError();
  }
}
