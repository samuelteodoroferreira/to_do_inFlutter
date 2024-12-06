import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // Initialize Firebase
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      await _auth.setPersistence(Persistence.LOCAL);
    } catch (e) {
      _logger.e("Erro de Inicializacao do Firebase: $e");
    }
  }

  // Authentication
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      _logger.e("Erro ao fazer login: $e");
      return null;
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      _logger.e("Erro ao criar conta: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _logger.e("Erro ao fazer logout: $e");
    }
  }

  // CRUD operations
  Future<void> addItem(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (e) {
      _logger.e("Erro ao adicionar item: $e");
    }
  }

  Future<void> updateItem(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      _logger.e("Erro ao atualizar item: $e");
    }
  }

  Future<void> deleteItem(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      _logger.e("Erro ao deletar item: $e");
    }
  }

  Stream<QuerySnapshot> getItems(String collection) {
    return _firestore.collection(collection).snapshots();
  }
}