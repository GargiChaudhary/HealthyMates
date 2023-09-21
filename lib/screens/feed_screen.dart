import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_mates/screens/chatbot.dart';
import 'package:healthy_mates/utils/colors.dart';
import 'package:healthy_mates/utils/global_variables.dart';
import 'package:healthy_mates/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.blueAccent,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: const Text(
                'HealthyMates',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ChatBot())),
                  icon: const Icon(
                    CupertinoIcons.bubble_left_bubble_right_fill,
                    color: primaryColor,
                    size: 25,
                  ),
                )
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            // itemBuilder: (context, index) => PostCard(
            //   snap: snapshot.data!.docs[index].data(),
            // ),
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 5,
              ),
              child: PostCard(
                // uid: FirebaseAuth.instance.currentUser!.uid,
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
