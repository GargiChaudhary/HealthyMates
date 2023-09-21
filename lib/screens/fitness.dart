// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:healthy_mates/models/exercise.dart';
import 'package:healthy_mates/models/exercise_api.dart';
import 'package:healthy_mates/screens/search_exercise.dart';
import 'package:healthy_mates/utils/colors.dart';
import 'package:healthy_mates/widgets/exercise_card.dart';

class Fitness extends StatefulWidget {
  const Fitness({super.key});

  @override
  State<Fitness> createState() => _FitnessState();
}

class _FitnessState extends State<Fitness> {
  // List<Exercise> _exercise = [];
  // late List<Exercise> _exercise;
  ExerciseApi _exercise = ExerciseApi();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> getExercises() async {
  //   // _exercise = await ExerciseApi.getExercise();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Center(
            child: Text(
          'Exercises',
          style: TextStyle(
              color: Colors.white, fontFamily: 'Montserrat', fontSize: 20),
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchExercise());
            },
          )
        ],
      ),
      body: Container(
          child: FutureBuilder<List<Exercise>>(
        future: _exercise.getExercise(''),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Exercise>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return ExerciseCard(
                  name: data![index].name,
                  bodyPart: data[index].bodyPart,
                  target: data[index].target,
                  gifUrl: data[index].gifUrl,
                  equipment: data[index].equipment,
                );
              });
        },
      )),
    );
  }
}
