import 'package:flutter/material.dart';
import 'package:flutter_biometric/Screens/finalpage.dart';
import 'package:flutter_biometric/authentication.dart';
import 'package:flutter_biometric/main.dart';

class SecondPage extends StatelessWidget {
  SecondPage({super.key});

  var screen_no = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0.0,
        title: const Text('Sign in'),
      ),
      // const SizedBox(height: 20);
      body: SizedBox(
          // height: 20,
          width: double.infinity,
          child: Center(
            child: ElevatedButton(
              onPressed: () async {
                Widget okButton = TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    if (screen_no == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FinalPage(title: "Final Page")));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RootPage()));
                    }
                  },
                );
                AlertDialog successAlert = AlertDialog(
                  title: const Text("Success"),
                  content: const Text("User logged in Successfully"),
                  actions: [
                    okButton,
                  ],
                );

                AlertDialog tryAgainAlert = AlertDialog(
                  // title: const Text("Warning"),
                  title: const Icon(Icons.warning_amber_outlined),
                  content: const Text("Too many attempts.\nTry Again!"),
                  actions: [
                    okButton,
                  ],
                );
                bool isAuthenticated =
                    await Authentication.authenticateWithBiometrics();
                if (isAuthenticated) {
                  screen_no = 1;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return successAlert;
                    },
                  );
                } else {
                  screen_no = 2;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return tryAgainAlert;
                    },
                  );
                }
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 20),
                ),
                backgroundColor:
                    const MaterialStatePropertyAll<Color>(Colors.orangeAccent),
                overlayColor: MaterialStateProperty.all(Colors.lightGreen),
                shadowColor: MaterialStateProperty.all(Colors.orange),
                elevation: MaterialStateProperty.all(15),

                // height: 100;
              ),
              child: const Text("Approve"),
            ),
          )),
    );
  }
}
