import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import '../../common_widget/custom_elevated_button.dart';
import '../../services/auth.dart';

enum EmailSignFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInForm({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignFormType _formType = EmailSignFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  void _submit() async {
    //print('email: ${_emailController.text}, password ${_passwordController.text}');
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      if (_formType == EmailSignFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email) ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignFormType.signIn
          ? EmailSignFormType.register
          : EmailSignFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignFormType.signIn ? 'Sign In' : 'Create an Account';
    final secondaryText = _formType == EmailSignFormType.signIn
        ? 'Need an Account? Register'
        : 'Have an Account? Sign In';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) && !_isLoading;

    return [
      _buildEmailTextField(),
      const SizedBox(height: 8.0),
      _buildPasswordTextField(),
      const SizedBox(height: 8.0),
      CustomElevatedButton(
        child: Text(
          primaryText,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        color:
            _formType == EmailSignFormType.signIn ? Colors.indigo : Colors.teal,
        onPressed: submitEnabled ? _submit : null,
      ),
      const SizedBox(height: 8.0),
      TextButton(
        child: Text(secondaryText),
        onPressed: !_isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText = _submitted && !widget.passwordValidator.isValid(_password);
    print('$showErrorText');
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
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

  void _updateState() {
    setState(() {});
  }
}
