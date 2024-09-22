import 'dart:core';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../../components/components_style.dart';
import '../../components/style_form_field.dart';
import '../../service/auth_service.dart';
import '../register/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  bool loading = false;

  final sombra = const [
    BoxShadow(
      color: Colors.black26, // Cor da sombra
      blurRadius: 8.0, // Raio de desfoque
      offset: Offset(0, 4), // Posição da sombra
    ),
  ];

  _submitForm() async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          loading = true;
          FocusNode().unfocus();
        });
        FocusNode().unfocus();
        await context.read<AuthService>().login(
              emailController.text,
              passwordController.text,
            );
      } on AuthException catch (e) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Text(e.message),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white, // Cor superior (branco)
              Colors.lightBlueAccent, // Cor inferior (azul claro)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ComponentsStyle.appBar(size),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromARGB(255, 184, 233, 255),
                    ),
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormFieldComponent(
                            controller: emailController,
                            label: 'Email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite seu email';
                              } else if (!EmailValidator.validate(value)) {
                                return 'Digite um email valido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormFieldComponent(
                            controller: passwordController,
                            label: 'senha',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite sua senha';
                              } else if (value.length < 6) {
                                return 'Sua senha deve contar no minimo 6 digitos';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color.fromARGB(255, 255, 244, 0),
                                boxShadow: sombra,
                              ),
                              child: loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text("Entrar"),
                            ),
                            onTap: () => _submitForm(),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Caso não tenha uma conta, clique em cadastrar',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.lightBlueAccent,
                                  boxShadow: sombra),
                              child: loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text("Cadastrar"),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
