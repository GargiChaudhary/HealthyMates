import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthy_mates/screens/profile_screen.dart';
import 'package:healthy_mates/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Container(
            margin: EdgeInsets.symmetric(
              horizontal: width > 600 ? width * 0.3 : 0,
              vertical: width > 600 ? 15 : 5,
            ),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Search for a user'),
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowUser = true;
                });
              },
            ),
          ),
        ),
        body: isShowUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    // itemCount: (snapshot.data! as dynamic).docs.length,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width > 600 ? width * 0.3 : 0,
                          vertical: width > 600 ? 15 : 2,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        uid: (snapshot.data! as dynamic)
                                            .docs[index]['uid']))),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['photoUrl']),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['username'],
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat', fontSize: 14),
                                  ),
                                  Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['bio'],
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 11,
                                        color: secondaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    'assets/search.svg',
                    height: 100,
                    width: 100,
                  ),
                ),
              ));
  }
}

String capitalizeAllWord(String value) {
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " ") {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
    }
  }
  return result;
}
