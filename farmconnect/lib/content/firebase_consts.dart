import 'package:cloud_firestore/cloud_firestore.dart';

firebaseAuth auth = firebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

const usersCollection = "Users";
