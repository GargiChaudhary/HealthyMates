import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final String name;
  final String target;
  final String bodyPart;
  final String gifUrl;
  final String equipment;
  const ExerciseCard({
    super.key,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.gifUrl,
    required this.equipment,
  });

  //Column ( image, row of target and bodypart, name)
  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color.fromRGBO(30, 30, 30, 1),
        elevation: 4.0,
        child: Column(
          children: [
            ListTile(
              title: Text(target.capitalize()),
              subtitle: Text(bodyPart.capitalize()),
              // trailing: Icon(Icons.favorite_outline),
            ),
            Container(
              height: 200.0,
              child: Ink.image(
                image: NetworkImage(gifUrl),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(name.capitalize()),
            ),
            // ButtonBar(
            //   children: [
            //     TextButton(
            //       child: const Text('CONTACT AGENT'),
            //       onPressed: () {/* ... */},
            //     ),
            //     TextButton(
            //       child: const Text('LEARN MORE'),
            //       onPressed: () {/* ... */},
            //     )
            //   ],
            // )
          ],
        ));
    // return Container(
    //   margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
    //   width: MediaQuery.of(context).size.width,
    //   height: 180,
    //   decoration: BoxDecoration(
    //     color: Colors.black,
    //     borderRadius: BorderRadius.circular(15),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.6),
    //         offset: const Offset(
    //           0.0,
    //           10.0,
    //         ),
    //         blurRadius: 10.0,
    //         spreadRadius: -6.0,
    //       ),
    //     ],
    //     image: DecorationImage(
    //       colorFilter: ColorFilter.mode(
    //         Colors.black.withOpacity(0.35),
    //         BlendMode.multiply,
    //       ),
    //       image: NetworkImage(gifUrl),
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    //   child: Stack(
    //     children: [
    //       Align(
    //         alignment: Alignment.center,
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 5.0),
    //           child: Text(
    //             name,
    //             style: const TextStyle(
    //                 fontSize: 20,
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.bold),
    //             overflow: TextOverflow.ellipsis,
    //             maxLines: 2,
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //       ),
    //       Align(
    //         alignment: Alignment.bottomLeft,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Container(
    //               padding: const EdgeInsets.all(5),
    //               margin: const EdgeInsets.all(10),
    //               decoration: BoxDecoration(
    //                 color: Colors.black.withOpacity(0.4),
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //               child: Row(
    //                 children: [
    //                   const Icon(
    //                     Icons.star,
    //                     color: Colors.yellow,
    //                     size: 18,
    //                   ),
    //                   const SizedBox(width: 7),
    //                   Text(
    //                     target,
    //                     style: const TextStyle(
    //                       color: Colors.white,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               padding: const EdgeInsets.all(5),
    //               margin: const EdgeInsets.all(10),
    //               decoration: BoxDecoration(
    //                 color: Colors.black.withOpacity(0.4),
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //               child: Row(
    //                 children: [
    //                   const Icon(
    //                     Icons.schedule,
    //                     color: Colors.yellow,
    //                     size: 18,
    //                   ),
    //                   const SizedBox(width: 7),
    //                   Text(
    //                     bodyPart,
    //                     style: const TextStyle(
    //                       color: Colors.white,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
