import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_mates/screens/comments_screen.dart';
import 'package:healthy_mates/utils/colors.dart';
import 'package:healthy_mates/utils/utils.dart';

import '../resources/auth_methods.dart';
import '../resources/firestore_methods.dart';
import '../widgets/follow_button.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

//will adding
class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //get posts length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
            ),
            body: ListView(
              children: [
                const SizedBox(
                  height: 35,
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(58),
                          boxShadow: const [
                            BoxShadow(
                              // offset: Offset(7, 10),
                              color: Color.fromRGBO(8, 8, 8, 0.932),
                              blurRadius: 20.0,
                            )
                          ]),
                      child: CircleAvatar(
                        radius: 58,
                        backgroundColor: primaryColor,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userData['photoUrl']),
                          radius: 55,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      capitalizeAllWord(userData['username']),
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      capitalizeAllWord(userData['bio']),
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                            ? FollowButton(
                                text: 'Sign out',
                                backgroundColor: mobileBackgroundColor,
                                textColor: primaryColor,
                                borderColor: Colors.grey,
                                function: () async {
                                  await AuthMethods().signOut();

                                  if (context.mounted) {
                                    // clearUserData();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  }
                                },
                              )
                            : isFollowing
                                ? FollowButton(
                                    text: 'Unfollow',
                                    backgroundColor: whiteColor,
                                    textColor: Colors.black,
                                    borderColor: Colors.grey,
                                    function: () async {
                                      await FirestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid']);
                                      setState(() {
                                        isFollowing = false;
                                        followers--;
                                      });
                                    },
                                  )
                                : FollowButton(
                                    text: 'Follow',
                                    backgroundColor: primaryColor,
                                    textColor: whiteColor,
                                    borderColor: primaryColor,
                                    function: () async {
                                      await FirestoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        userData['uid'],
                                      );
                                      setState(() {
                                        isFollowing = true;
                                        followers++;
                                      });
                                    },
                                  )
                      ],
                    ),
                    const SizedBox(
                      height: 10, //chnge 4
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: 60,
                          width: 110,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(10, 10),
                                  color: Color.fromARGB(255, 14, 14, 14),
                                  blurRadius: 10)
                            ],
                            color: mobileBackgroundColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                postLen.toString(),
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Posts',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        // const VerticalDivider(
                        //   width: 20,
                        //   thickness: 5,
                        //   indent: 20,
                        //   endIndent: 10,
                        //   color: primaryColor,
                        // ),
                        Container(
                          height: 60,
                          width: 110,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(10, 10),
                                  color: Color.fromARGB(255, 14, 14, 14),
                                  blurRadius: 10)
                            ],
                            color: mobileBackgroundColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                followers.toString(),
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Followers',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 110,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(10, 10),
                                  color: Color.fromARGB(255, 14, 14, 14),
                                  blurRadius: 10)
                            ],
                            color: mobileBackgroundColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                following.toString(),
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Following',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];

                          return SizedBox(
                            child: Image(
                              image: NetworkImage(snap['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    })
              ],
            ),
          );
  }
}
