enum EmailSignFormType { signIn, register }

class EmailSignInModel {
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
