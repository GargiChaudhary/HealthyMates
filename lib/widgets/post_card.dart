// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_mates/models/user.dart';
import 'package:healthy_mates/providers/user_provider.dart';
import 'package:healthy_mates/resources/firestore_methods.dart';
import 'package:healthy_mates/screens/comments_screen.dart';
import 'package:healthy_mates/utils/colors.dart';
import 'package:healthy_mates/utils/utils.dart';
import 'package:healthy_mates/widgets/like_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  var userData = {};

  @override
  void initState() {
    super.initState();
    getComments();
  }

  getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FirestoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
        // color: mobileBackgroundColor,
        decoration: BoxDecoration(
            color: mobileBackgroundColor,
            boxShadow: const [BoxShadow(offset: Offset(6, 6), blurRadius: 6)],
            border: Border.all(
              color: const Color.fromARGB(255, 87, 87, 87),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  //header section
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: primaryColor,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.snap['profileImage'].toString()),
                      radius: 20,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalizeAllWord(
                                widget.snap['username'].toString()),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                                fontSize: 15),
                          ),
                          Text(
                            widget.snap['bio'].toString(),
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.snap['uid'].toString() == user.uid
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map((e) => InkWell(
                                                onTap: () {
                                                  deletePost(
                                                    widget.snap['postId']
                                                        .toString(),
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: Text(e),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(Icons.more_vert))
                      : Container()
                ],
              ),
            ),

            //image section
            GestureDetector(
              onDoubleTap: () async {
                await FirestoreMethods().likePost(
                    widget.snap['postId'], user.uid, widget.snap['likes']);
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap['postUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.star,
                        color: primaryColor,
                        size: 120,
                      ),
                    ),
                  )
                ],
              ),
            ),

            //like, comment section
            Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                          widget.snap['postId'].toString(),
                          user.uid,
                          widget.snap['likes']);
                      // setState(() {
                      //   isLikeAnimating = true;
                      // });
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.star,
                            color: primaryColor,
                            size: 25,
                          )
                        : const Icon(
                            Icons.star_border,
                            color: primaryColor,
                            size: 24,
                          ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(snap: widget.snap))),
                  icon: const Icon(
                    CupertinoIcons.ellipses_bubble_fill,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(Icons.send),
                // ),
                // Expanded(
                //   child: Align(
                //     alignment: Alignment.bottomRight,
                //     child: IconButton(
                //       icon: const Icon(Icons.bookmark_border),
                //       onPressed: () {},
                //     ),
                //   ),
                // )
              ],
            ),

            //description and number of comments
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    // style: Theme.of(context)
                    //     .textTheme
                    //     .subtitle2!
                    //     .copyWith(fontWeight: FontWeight.w800),
                    style: const TextStyle(fontFamily: 'Montserrat'),
                    child: Text(
                      '${widget.snap['likes'].length} likes, $commentLen comments',
                      // style: Theme.of(context).textTheme.bodyText2,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: secondaryColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: whiteColor),
                          children: [
                            TextSpan(
                                text:
                                    capitalizeAllWord(widget.snap['username']),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    color: whiteColor)),
                            TextSpan(
                                text: ' ${widget.snap['description']}',
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w300))
                          ]),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) =>
                  //           CommentScreen(snap: widget.snap))),
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 4),
                  //     child: Text(
                  //       'View all $commentLen comments',
                  //       style: const TextStyle(
                  //           fontSize: 14,
                  //           color: secondaryColor,
                  //           fontFamily: 'Montserrat'),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                          fontSize: 11,
                          color: secondaryColor,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ],
              ),
            )
          ],
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
