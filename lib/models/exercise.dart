class Exercise {
  final String bodyPart;
  final String equipment;
  final String gifUrl;
  final String id;
  final String name;
  final String target;

  Exercise(
      {required this.name,
      required this.target,
      required this.bodyPart,
      required this.equipment,
      required this.gifUrl,
      required this.id});

  factory Exercise.fromJson(dynamic json) {
    return Exercise(
        name: json['name'] as String,
        target: json['target'] as String,
        bodyPart: json['bodyPart'] as String,
        equipment: json['equipment'] as String,
        gifUrl: json['gifUrl'] as String,
        id: json['id'] as String);
  }

  static List<Exercise> exerciseFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Exercise.fromJson(data);
    }).toList();
  }
  // @override
  // String toString() {
  //   return 'Exercise {name: $name, target: $target, bodyPart: $bodyPart, equipment: $equipment, gifUrl: $gifUrl, id: $id}';
  // }
}



// bodyPart:"waist"
// equipment:"body weight"
// gifUrl:"https://api.exercisedb.io/image/wuVdy2Kp0JIYyt"
// id:"0001"
// name:"3/4 sit-up"
// target:"abs"