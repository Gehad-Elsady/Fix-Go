// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_mate/screens/cart/model/cart-model.dart';
import 'package:road_mate/screens/contact/model/contact-model.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';
import 'package:road_mate/screens/add-services/model/service-model.dart';
import 'package:road_mate/Auth/model/usermodel.dart';

class FirebaseFunctions {
  static SignUp(String emailAddress, String password,
      {required Function onSuccess,
      required Function onError,
      required String userName,
      required int age}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      credential.user?.sendEmailVerification();
      UserModel userModel = UserModel(
        age: age,
        email: emailAddress,
        name: userName,
        id: credential.user!.uid,
      );
      addUser(userModel);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    } catch (e) {
      print(e);
    }
  }

  static Login(
    String emailAddress,
    String password, {
    required Function onSuccess,
    required Function onError,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    }
  }

  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, options) {
        return UserModel.fromJason(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJason();
      },
    );
  }

  static Future<void> addUser(UserModel user) {
    var collection = getUserCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static Future<UserModel?> readUserData() async {
    var collection = getUserCollection();

    DocumentSnapshot<UserModel> docUser =
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    return docUser.data();
  }

  static signOut() {
    FirebaseAuth.instance.signOut();
  }

  static CollectionReference<ProfileModel> getUserProfileCollection() {
    return FirebaseFirestore.instance
        .collection("UsersProfile")
        .withConverter<ProfileModel>(
      fromFirestore: (snapshot, options) {
        return ProfileModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJson();
      },
    );
  }

  static Future<void> addUserProfile(ProfileModel user) {
    var collection = getUserProfileCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static Stream<ProfileModel?> getUserProfile(String uid) {
    return FirebaseFirestore.instance
        .collection('UsersProfile')
        .doc(uid)
        .snapshots()
        .map((userProfileSnapshot) {
      if (userProfileSnapshot.exists) {
        var data = userProfileSnapshot.data() as Map<String, dynamic>;
        return ProfileModel.fromJson(
            data); // Assuming ProfileModel has a fromJson constructor
      } else {
        print('User profile not found');
        return null; // Return null if the document does not exist
      }
    }).handleError((e) {
      print('Error fetching user profile: $e');
      return null; // Handle errors by returning null
    });
  }

  static Stream<List<ServiceModel>> getServicesStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore.collection('services').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ServiceModel(
          userId: data['userId'] ?? "no id",
          name: data['name'] ?? 'No Name',
          image: data['image'] ?? 'default_image.png', // Adjust if needed
          description: data['description'] ?? 'No Description',
          price: data['price'] ?? 'No Price',
        );
      }).toList();
    });
  }

  static Future<void> addService(CartModel service) async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc()
          .withConverter<CartModel>(
        fromFirestore: (snapshot, options) {
          return CartModel.fromMap(snapshot.data()!);
        },
        toFirestore: (value, options) {
          return value.toMap();
        },
      ).set(service);
      print('Service added successfully!');
    } catch (e) {
      print('Error adding service: $e');
    }
  }

  static Future<void> addProblem(ContactModel problem) async {
    try {
      await FirebaseFirestore.instance
          .collection('Problem')
          .doc()
          .withConverter<ContactModel>(
        fromFirestore: (snapshot, options) {
          return ContactModel.fromJson(snapshot.data()!);
        },
        toFirestore: (value, options) {
          return value.toJson();
        },
      ).set(problem);
      print('problem added successfully!');
    } catch (e) {
      print('Error adding problem: $e');
    }
  }
}
