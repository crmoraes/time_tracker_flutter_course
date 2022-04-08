import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<Job> jobStream({required String jobId});
  Stream<List<Job>> jobsStream();

  Future<void> createEntry(Entry entry);
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job? job});
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  // Jobs
  @override
  Future<void> createJob(Job job) async => await _service.addData(
        path: APIPath.jobs(uid),
        data: job.toMap(),
      );

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) => _service.deleteData(
        path: APIPath.job(uid, job.id),
      );

  @override
  Stream<Job> jobStream({required String jobId}) => _service.documentStream(
        path: APIPath.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  // Entries
  @override
  Future<void> createEntry(Entry entry) async => await _service.addData(
        path: APIPath.entries(uid),
        data: entry.toMap(),
      );

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: APIPath.entry(uid, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentId) => Entry.fromMap(data, documentId),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
