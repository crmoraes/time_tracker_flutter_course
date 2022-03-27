import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

enum EmailSignFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final String email;
  final String password;
  final EmailSignFormType formType;
  final bool isLoading;
  final bool submitted;

  String get primaryButtonText {
    return formType == EmailSignFormType.signIn ? 'Sign In' : 'Create an Account';
  }

  String get secondaryText {
    return formType == EmailSignFormType.signIn
        ? 'Need an Account? Register'
        : 'Have an Account? Sign In';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool showErrorText =
        submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
