import 'package:flutter/material.dart';
import 'package:flutter_biometric/Screens/sign_in.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                // return const SignUpPage();
                return const SignIn();
              },
            ));
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(150, 30)),
            textStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 25),
            ),
            overlayColor: MaterialStateProperty.all(
              Colors.cyan,
            ),
            shadowColor: MaterialStateProperty.all(Colors.yellow),
            elevation: MaterialStateProperty.all(15),
            padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
          ),
          // child: const Text('Scan QR')),
          child: const Text('Sign Up')),
    );
  }
}
