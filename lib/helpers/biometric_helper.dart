import 'package:local_auth/local_auth.dart';
// import 'package:flutter/services.dart';

class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> hasEnrolledBiometrics() async {
    final List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> authenticate() async {
   try{
     final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(biometricOnly: true));
    return didAuthenticate;
   }
   catch(e){
    return false;
   }
  }

  // static Future<bool> faceauthenticate() async {
  //   bool authenticated = false;
  //   try {
  //     authenticated = await const MethodChannel('com.example.faceid')
  //         .invokeMethod('authenticateWithFaceID');
  //   } on PlatformException catch (e) {
  //     print(e.message);
  //   }
  //   return authenticated;
  // }
}
