import 'package:cloud_firestore/cloud_firestore.dart';

// User class for storing user data for easier access
class User {
  final String username;
  final String uid;
  final String photoUrl;
  final String email;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
  });

  //Returns user data in a map/JSON
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'photoUrl': photoUrl,
        'email': email,
        'bio': bio,
        'followers': followers,
        'following': following,
      };

  //Converts snapshot from FireBase (JSON) into a user instance
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
