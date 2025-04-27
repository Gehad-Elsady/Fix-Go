// ignore_for_file: unused_local_variable, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_mate/location/model/locationmodel.dart';
import 'package:road_mate/notifications/model/notification_model.dart';
import 'package:road_mate/screens/Provider/engneers/model/eng_model.dart';
import 'package:road_mate/screens/Provider/home/model/accepted_model.dart';
import 'package:road_mate/screens/cart/model/cart-model.dart';
import 'package:road_mate/screens/contact/model/contact-model.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';
import 'package:road_mate/screens/Provider/add-services/model/service-model.dart';
import 'package:road_mate/Auth/model/usermodel.dart';

class FirebaseFunctions {
  //-----------------------Login and SignUp--------------------------
  static SignUp(
      {required Function onSuccess,
      required Function onError,
      required String firstName,
      required String lastName,
      required String role,
      required String emailAddress,
      String imageUrl = "",
      required String password,
      required int phoneNumber}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      credential.user?.sendEmailVerification();
      UserModel userModel = UserModel(
        role: role,
        phoneNumber: phoneNumber,
        email: emailAddress,
        firstName: firstName,
        lastName: lastName,
        id: credential.user!.uid,
        imageUrl: imageUrl,
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
          price: data['price'] ?? 'No Price',
          createdAt: data['createdAt'] ?? 'No Date',
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

  static Future<void> deleteService(String id, Timestamp createdAt) async {
    try {
      // Query to find the service with matching `id` and `createdAt`
      final querySnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('id', isEqualTo: id)
          .where('createdAt', isEqualTo: createdAt)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If a matching document is found, delete it
        await querySnapshot.docs.first.reference.delete();
        print('Service deleted successfully!');
      } else {
        print('Service not found for the given id and createdAt');
      }
    } catch (e) {
      print('Error deleting service: $e');
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

  static Future<void> orderHistory(HistoryModel order) async {
    try {
      // Reference to the 'History' collection
      final historyCollection =
          FirebaseFirestore.instance.collection('History');

      // Debug log: Check collection size
      print('Fetching the highest existing order ID...');

      // Get the highest existing order ID
      final snapshot = await historyCollection
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      int newId = 1; // Default to 1 if no orders exist
      if (snapshot.docs.isNotEmpty) {
        final lastId = snapshot.docs.first.data()['id'];

        // Debug log: Output the last ID
        print('Last order ID retrieved: $lastId');

        // Parse last ID safely and increment
        newId = (int.tryParse(lastId?.toString() ?? '0') ?? 0) + 1;

        // Debug log: Output the new ID
        print('New order ID to be used: $newId');
      }

      // Fetch user profile asynchronously
      final userProfile =
          await getUserProfile(FirebaseAuth.instance.currentUser!.uid).first;

      if (userProfile == null) {
        print('User profile not found!');
        return;
      }

      // Debug log: Output user profile
      print('User profile retrieved: ${userProfile.firstName}');

      // Create a new order
      final newOrder = HistoryModel(
        totalPrice: order.totalPrice,
        id: newId.toString(),
        userId: FirebaseAuth.instance.currentUser!.uid,
        items: order.items,
        orderType: order.orderType,
        serviceModel: order.serviceModel,
        locationModel: order.locationModel,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        orderStatus: "Pending",
        orderOwnerName: userProfile.firstName,
        orderOwnerPhone: userProfile.phoneNumber,
      );

      // Add the new order to Firestore
      await historyCollection.add(newOrder.toJson());

      // Clear the user's cart
      await clearCart(FirebaseAuth.instance.currentUser!.uid);

      print('Order added successfully with ID: $newId');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  static Stream<List<HistoryModel>> getHistoryStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return _firestore
        .collection('History')
        .where('userId', isEqualTo: uid) // Filter by current user's ID
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return HistoryModel(
          timestamp: data['timestamp'] ?? 0,
          userId: data['userId'] ?? "no id",
          serviceModel: data['serviceModel'] != null
              ? ServiceModel.fromJson(data['serviceModel'])
              : null,
          locationModel: data['locationModel'] != null
              ? LocationModel.fromMap(data['locationModel'])
              : null,
          items: data['items'] != null
              ? (data['items'] as List<dynamic>)
                  .map((item) => CartModel.fromMap(item))
                  .toList()
              : [],
          orderType: data['OrderType'] ?? "No Order Type",
          id: data['id'] ?? "No Id",
          orderStatus: data['orderStatus'] ?? "No Status",
          orderOwnerName: data['orderOwnerName'] ?? "No Name",
          orderOwnerPhone: data['orderOwnerPhone'] ?? "No Phone",
          totalPrice: data['totalPrice'] != null
              ? double.tryParse(data['totalPrice'].toString())
              : 0.0,
        );
      }).toList();
    });
  }

  static Future<void> deleteHistoryOrder(int timestamp) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      print('User is not authenticated.');
      return;
    }

    try {
      // Get the document(s) that match the userId and itemId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('History')
          .where('timestamp', isEqualTo: timestamp)
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

  //----------------------------------Admin Functions-----------------------------------------
  static Stream<List<HistoryModel>> getAdminRequestStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore.collection('History').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return HistoryModel(
          timestamp: data['timestamp'] ?? 0,
          userId: data['userId'] ?? "no id",
          serviceModel: data['serviceModel'] != null
              ? ServiceModel.fromJson(data['serviceModel'])
              : null,
          locationModel: data['locationModel'] != null
              ? LocationModel.fromMap(data['locationModel'])
              : null,
          items: data['items'] != null
              ? (data['items'] as List<dynamic>)
                  .map((item) => CartModel.fromMap(item))
                  .toList()
              : [],
          orderType: data['OrderType'] ?? "No Order Type",
          id: data['id'] ?? "No Id",
          orderStatus: data['orderStatus'] ?? "No Status",
          orderOwnerName: data['orderOwnerName'] ?? "No Name",
          orderOwnerPhone: data['orderOwnerPhone'] ?? "No Phone",
          totalPrice: data['totalPrice'] != null
              ? double.tryParse(data['totalPrice'].toString())
              : 0.0,
        );
      }).toList();
    });
  }

  static Future<void> addOrderToMyList(AcceptedModel order) async {
    try {
      await FirebaseFirestore.instance
          .collection('MyOrders')
          .withConverter<AcceptedModel>(
            fromFirestore: (snapshot, _) =>
                AcceptedModel.fromJson(snapshot.data()!),
            toFirestore: (order, _) => order.toJson(),
          )
          .add(
              order); // Use .add() instead of .doc().set() unless you need a custom ID
      print('Order added successfully!');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  /// Returns a stream of AcceptedModel orders from the "MyOrders" collection
  static Stream<List<AcceptedModel>> getMyOrderStream() {
    return FirebaseFirestore.instance
        .collection('MyOrders')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AcceptedModel(
          orderStatus: data['orderStatus'] ?? "no status",
          userId: data['userId'] ?? "no user",
          totalPrice: (data['totalPrice'] ?? 0).toDouble(),
          items: (data['items'] as List<dynamic>? ?? [])
              .map((item) => CartModel.fromMap(item))
              .toList(),
          serviceModel: data['serviceModel'] != null
              ? ServiceModel.fromJson(data['serviceModel'])
              : null,
          orderType: data['orderType'] ?? "No Order Type",
          orderTime: data['orderTime'] ?? "",
          historyModel: HistoryModel.fromJson(data['historyModel']),
        );
      }).toList();
    });
  }

  static Future<void> cancelMyOrder(int timestamp) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      print('User is not authenticated.');
      return;
    }

    try {
      // Get the document(s) that match the userId and itemId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('MyOrders')
          .where('orderTime', isEqualTo: timestamp)
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

  static Future<void> acceptedOrder(String id, int timestamp) async {
    // Query to find the document based on `id` and `createdAt`
    final querySnapshot = await FirebaseFirestore.instance
        .collection('History')
        .where('userId', isEqualTo: id)
        .where('timestamp', isEqualTo: timestamp)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If the document exists, update it
      final docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance.collection('History').doc(docId).update({
        'orderStatus': 'Accepted',
      });
      print('Service updated successfully!');
    }
  }

  static Future<void> cancelOrder(String id, int timestamp) async {
    // Query to find the document based on `id` and `createdAt`
    final querySnapshot = await FirebaseFirestore.instance
        .collection('History')
        .where('userId', isEqualTo: id)
        .where('timestamp', isEqualTo: timestamp)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If the document exists, update it
      final docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance.collection('History').doc(docId).update({
        'orderStatus': 'Pending',
      });
      print('Service updated successfully!');
    }
  }

  //-----------------------------Engineer Functions-----------------------------------
  static Stream<List<EngModel>> getSEngineerStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore.collection('engineers').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return EngModel(
          userId: data['userId'] ?? "no id",
          name: data['name'] ?? 'No Name',
          image: data['image'] ?? 'default_image.png', // Adjust if needed
          bio: data['bio'] ?? 'No Description',
          price: data['price'] ?? 'No Price',
          createdAt: data['createdAt'] ?? 'No Date',
          phone: data['phone'] ?? 'No Phone',
          address: data['address'] ?? 'No Address',
        );
      }).toList();
    });
  }

  static Future<void> deleteEngineer(String id, Timestamp createdAt) async {
    try {
      // Query to find the service with matching `id` and `createdAt`
      final querySnapshot = await FirebaseFirestore.instance
          .collection('engineers')
          .where('id', isEqualTo: id)
          .where('createdAt', isEqualTo: createdAt)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If a matching document is found, delete it
        await querySnapshot.docs.first.reference.delete();
        print('Engineer deleted successfully!');
      } else {
        print('Engineer not found for the given id and createdAt');
      }
    } catch (e) {
      print('Error deleting engineer: $e');
    }
  }

  //--------------------------Notifications--------------------------

  static Future<void> addDeviceTokens(NotificationModel token) async {
    try {
      await FirebaseFirestore.instance
          .collection('UserTokens')
          .doc(token.id)
          .withConverter<NotificationModel>(
        fromFirestore: (snapshot, options) {
          return NotificationModel.fromJson(snapshot.data()!);
        },
        toFirestore: (value, options) {
          return value.toJson();
        },
      ).set(token);
      print('token added successfully!');
    } catch (e) {
      print('Error adding token: $e');
    }
  }

  static Stream<String?> getUserDeviceTokenStream(String userId) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore
        .collection('UserTokens')
        .doc(
            userId) // Directly reference the document with the userId as the document ID.
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return data['deviceToken'] as String?; // Return the deviceToken field.
      }
      return null; // Return null if the document does not exist.
    });
  }
}
