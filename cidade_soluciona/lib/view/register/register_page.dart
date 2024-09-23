import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components_style.dart';
import '../../components/style_form_field.dart';
import '../../database/services_db.dart';
import '../../main.dart';
import '../../service/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  submitForm(auth) async {
    if (formKey.currentState!.validate()) {
      FocusNode().unfocus();
      try {
        setState(() {
          loading = true;
        });
        await context.read<AuthService>().register(
              emailController.text,
              passwordController.text,
            );
        ServicesDB(auth: auth)
            .saveUser(
              nameController.text,
            )
            .whenComplete(
              () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
                (Route<dynamic> route) => false,
              ),
            );
      } on AuthException catch (e) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
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
            SizedBox(
              height: size.height,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              controller: nameController,
                              label: 'Nome',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Digite seu nome';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
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
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              child: Container(
                                width: size.width,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: const Color.fromARGB(255, 255, 244, 0),
                                ),
                                child: loading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text("Registrar"),
                              ),
                              onTap: () => submitForm(
                                Provider.of<AuthService>(context,
                                    listen: false),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
