// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:healthy_mates/screens/comments_screen.dart';
import 'package:healthy_mates/utils/colors.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: capitalizeAllWord(widget.snap['name']),
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: whiteColor,
                            fontSize: 14)),
                    TextSpan(
                        text:
                            '  ${DateFormat.yMMMd().format(widget.snap['datePublished'].toDate())}',
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: secondaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w300)),
                  ]),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${widget.snap['text']}',
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: whiteColor,
                          fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
