import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

//  Sign In ka function
Future<User?> signInWithGoogle() async{
  // Signing in with google
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

  // Creating Credential for Firebase
  final AuthCredential credential = GoogleAuthProvider.credential(
    idToken: googleSignInAuthentication?.idToken,
    accessToken: googleSignInAuthentication?.accessToken,
  );

  // Signing in with Credential & Making a User in Firebase and Getting user class
  final userCredential = await _auth.signInWithCredential(credential);
  final User? user = userCredential.user;

  // Checking is ON
  assert(user!.isAnonymous);
  assert(await user?.getIdToken() != null);

  final User? currentUser = await _auth.currentUser;
  assert(currentUser?.uid == user?.uid);
  print(user);
  return user;
}
