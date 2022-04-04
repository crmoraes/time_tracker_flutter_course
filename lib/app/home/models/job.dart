
class Job {
  Job({required this.name, required this.ratePerHour,});

  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data) {
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(
      name: name,
      ratePerHour: ratePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    final createdDate = DateTime.now();
    return {
      'name': name,
      'ratePerHour': ratePerHour,
      'createdDate': createdDate,
    };
  }
}