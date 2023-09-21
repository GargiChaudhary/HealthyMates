// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:healthy_mates/models/exercise_api.dart';

import '../models/exercise.dart';
import '../widgets/exercise_card.dart';

class SearchExercise extends SearchDelegate {
  ExerciseApi _exercise = ExerciseApi();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: _exercise.getExercise(query),
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search exercises suggestions'),
    );
  }
}
