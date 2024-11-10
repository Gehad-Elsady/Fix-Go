// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_mate/screens/cart/model/cart-model.dart';
import 'package:road_mate/screens/contact/model/contact-model.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';
import 'package:road_mate/screens/add-services/model/service-model.dart';
import 'package:road_mate/Auth/model/usermodel.dart';

class FirebaseFunctions {
  //-----------------------Login and SignUp--------------------------
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
    // Callback for unverified email
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      // Check if the user's email is verified
      if (credential.user?.emailVerified ?? false) {
        onSuccess();
      } else {
        onError('Email not verified. Please verify your email.');
      }
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    }
  }

  static signOut() {
    FirebaseAuth.instance.signOut();
  }
  //--------------------------------------------------
  //---------------------------User Profile---------------------------

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
      }
    }).handleError((e) {
      print('Error fetching user profile: $e');
      return null; // Handle errors by returning null
    });
  }

//----------------------------------------------------------------
//---------------------------Services---------------------------

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

  static Future<void> addService(ServiceModel service) async {
    try {
      await FirebaseFirestore.instance
          .collection('services')
          .doc()
          .withConverter<ServiceModel>(
        fromFirestore: (snapshot, options) {
          return ServiceModel.fromJson(snapshot.data()!);
        },
        toFirestore: (value, options) {
          return value.toJson();
        },
      ).set(service);
      print('Service added successfully!');
    } catch (e) {
      print('Error adding service: $e');
    }
  }

  //---------------------------------------------------------------------------
  //---------------------------Contact---------------------------

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
  //---------------------------------------------------------------------------
  //---------------------------Cart---------------------------

  static Stream<List<CartModel>> getCardStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return _firestore
        .collection('cart')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CartModel(
          userId: data['userId'] ?? "no id",
          serviceModel: ServiceModel.fromJson(data['serviceModel']),
          itemId: data['itemId'] ?? "no id",
        );
      }).toList();
    });
  }

  static Future<void> addCartService(CartModel model) async {
    // Get the highest existing itemId and increment it
    final cartCollection = FirebaseFirestore.instance.collection('cart');
    final snapshot =
        await cartCollection.orderBy('itemId', descending: true).limit(1).get();

    int newId = 1; // Default to 1 if no items are in the collection
    if (snapshot.docs.isNotEmpty) {
      final lastId = int.parse(snapshot.docs.first['itemId']);
      newId = lastId + 1;
    }

    final cartItem = CartModel(
      itemId: newId.toString(),
      serviceModel: model.serviceModel,
      userId: model.userId,
    );

    await cartCollection.add(cartItem.toMap());
  }

  static Future<void> deleteCartService(String itemId) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      print('User is not authenticated.');
      return;
    }

    try {
      // Get the document(s) that match the userId and itemId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('itemId', isEqualTo: itemId)
          .where('userId',
              isEqualTo: uid) // Ensure the item belongs to the current user
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No items found to delete.');
        return;
      }

      // Delete each document found
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('Service deleted successfully!');
    } catch (e) {
      print('Error deleting service: $e');
    }
  }

  static Future<void> checkOut(
      int totalPrice, Function onSuccess, Function onError) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Listen to the user profile stream
    await for (var profileData in getUserProfile(uid)) {
      if (profileData != null) {
        onSuccess(); // Profile is valid, proceed with success
        return; // Exit after success is handled
      } else {
        onError(); // Handle the error if profile data is null
        return; // Exit after error is handled
      }
    }
  }

  static Future<void> clearCart(String uid) async {
    final cartCollection = FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: uid);
    await cartCollection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  static Future<void> orderHistory(
    Historymaodel order,
  ) async {
    try {
      // Get the highest existing orderId and increment it
      final historyCollection =
          FirebaseFirestore.instance.collection('History');
      final snapshot = await historyCollection
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      int newId = 1; // Default to 1 if no orders are in the collection
      if (snapshot.docs.isNotEmpty) {
        final lastId = snapshot.docs.first['id']; // Use 'id' to compare
        if (lastId != null) {
          newId = int.tryParse(lastId) ?? 1; // Parse as int, fallback to 1
          newId += 1; // Increment the orderId
        }
      }

      // Manually include additional fields from order.toJson()
      final newOrder = Historymaodel(
          id: newId.toString(),
          userId: FirebaseAuth.instance.currentUser!
              .uid, // Include additional fields explicitly
          items: order.items,
          OrderType: order.OrderType,
          serviceModel: order.serviceModel);

      // Add the new order to the 'History' collection with the generated orderId
      await historyCollection
          .doc() // Firestore automatically generates the document ID
          .set(newOrder.toJson()); // Use toJson() to save the data

      // Clear the cart for the current user
      clearCart(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  //---------------------------------------------------------------------------
}
