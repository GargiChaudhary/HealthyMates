import 'dart:convert';
import 'package:healthy_mates/models/exercise.dart';
import 'package:http/http.dart' as http;

class ExerciseApi {
  var data = [];
  List<Exercise> results = [];
  Future<List<Exercise>> getExercise(String? query) async {
    var uri = Uri.https('exercisedb.p.rapidapi.com', '/exercises');
    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': 'API_KEY',
      'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com'
    });
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      results = data.map((e) => Exercise.fromJson(e)).toList();
      if (query != null) {
        results = results
            .where((element) =>
                element.name.toLowerCase().contains((query.toLowerCase())) ||
                element.target.toLowerCase().contains((query.toLowerCase())) ||
                element.bodyPart.toLowerCase().contains((query.toLowerCase())))
            .toList();
      } else {
        print('fetch error');
      }
    }
    return results;
  }
}
