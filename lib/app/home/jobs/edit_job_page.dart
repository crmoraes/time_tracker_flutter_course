import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widget/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widget/show_exception_alert_dialog.dart';

import '../../../services/database.dart';
import '../models/job.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({
    Key? key,
    required this.database,
    this.job,
  }) : super(key: key);

  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context, {required Database database, Job? job}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _id = '';
  String _name = '';
  int _ratePerHour = 0;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _id = widget.job!.id;
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        if (widget.job == null) {
          // CREATE
          final jobs = await widget.database.jobsStream().first;
          final allNames = jobs.map((job) => job.name).toList();
          if (allNames.contains(_name)) {
            showAlertDialog(
              context,
              title: 'Name already used',
              content: 'Please choose a different name',
              defaultActionText: 'OK',
            );
          } else {
            final job = Job(id: _id, name: _name, ratePerHour: _ratePerHour);
            await widget.database.createJob(job);
            Navigator.of(context).pop();
          }
        } else {
          // UPDATE
          final job = Job(id: _id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation Failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Job Name'),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be Empty',
        onSaved: (value) => _name = value ?? '',
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Rate Per Hour'),
        initialValue: _ratePerHour != 0 ? '$_ratePerHour' : null,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
      )
    ];
  }
}
