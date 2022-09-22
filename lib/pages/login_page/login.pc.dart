part of 'login.page.dart';

class _LoginPc extends _Login$Ctrl {
  final email = StringInput('Email')..email();
  final password = StringInput('Password', isObscure: true)
    ..minLength(3)
    ..maxLength(20);

  Future<bool> validateLogin() async {
    bool result = true;
    for (var element in [email, password]) {
      await element.validate();
      result &= element.isSuccess;
    }
    return result;
  }

  login() async {
    if (await validateLogin()) {
      final result = await AuthService.login(email.value!, password.value!);
      if (result.isSuccess) {
        await AppUser.fetchCurrentUser();
        PlayerPage.goOff();
      } else {
        result.showError();
      }
    }
  }
}
