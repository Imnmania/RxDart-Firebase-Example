import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rx_dart_example_11_firebase/helpers/if_debugging.dart';
import 'package:rx_dart_example_11_firebase/helpers/type_definitions.dart';

class RegisterScreen extends HookWidget {
  final RegisterCallback register;
  final VoidCallback goToLoginView;

  const RegisterScreen({
    required this.register,
    required this.goToLoginView,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
      text: "niloyb@live.com".ifDebugging,
    );

    final passwordController = useTextEditingController(
      text: "foobar123@".ifDebugging,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter email',
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter password',
              ),
              keyboardType: TextInputType.name,
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              obscuringCharacter: "#",
            ),
            TextButton(
              child: const Text('Register'),
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                register(email, password);
              },
            ),
            TextButton(
              onPressed: goToLoginView,
              child: const Text('Already registered? Click here to login!'),
            ),
          ],
        ),
      ),
    );
  }
}
