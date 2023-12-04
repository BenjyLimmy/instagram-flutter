import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SizedBox(
          height: 40,
          child: TextFormField(
            controller: searchController,
            onTap: () {
              setState(() {
                isShowUsers = true;
              });
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              fillColor: const Color.fromARGB(66, 112, 99, 99),
              filled: true,
              focusedBorder: border,
              enabledBorder: border,
              hintText: 'Search',
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 10.0),
                child: Icon(
                  Icons.search,
                  color: primaryColor,
                ),
              ),
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
                debugPrint(searchController.text);
              });
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data!.docs[index]['photoUrl'],
                        ),
                        radius: 16,
                      ),
                      title: Text(
                        (snapshot.data! as dynamic).docs[index]['username'],
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return MasonryGridView.count(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                    fit: BoxFit.cover,
                  ),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}