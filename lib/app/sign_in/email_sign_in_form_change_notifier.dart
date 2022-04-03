import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/common_widget/show_exception_alert_dialog.dart';
import '../../common_widget/custom_elevated_button.dart';
import '../../common_widget/show_alert_dialog.dart';
import '../../services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier({Key? key, required this.model})
      : super(key: key);
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      bool? confirmedCreate = false;
      if (model.formType == EmailSignFormType.register) {
        confirmedCreate = await showAlertDialog(
          context,
          title: 'New Account',
          content: 'Create new Account?',
          cancelActionText: 'No',
          defaultActionText: 'Yes',
        );
      }
      print('{Form type ${model.formType} & confirmation $confirmedCreate');
      if ((model.formType == EmailSignFormType.signIn) ||
          (confirmedCreate == true)) {
        await model.submit();
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in Failed',
        exception: e,
      );
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      const SizedBox(height: 8.0),
      _buildPasswordTextField(),
      const SizedBox(height: 8.0),
      CustomElevatedButton(
        child: Text(
          model.primaryButtonText,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        color: Colors.indigo,
        onPressed: model.canSubmit ? _submit : null,
      ),
      const SizedBox(height: 8.0),
      TextButton(
        child: Text(model.secondaryText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      //onChanged: (password) => widget.bloc.updateWith(password: password),
      // line below pass the password implicit as the method signature receives only password
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      //onChanged: (email) => widget.bloc.updateWith(email: email),
      // line below pass the email implicit as the method signature receives only email
      onChanged: model.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
