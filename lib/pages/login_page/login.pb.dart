part of 'login.page.dart';

@Page_(skins: [MenuSkin])
class LoginBuilder extends Login$Builder {
  @override
  String get title => 'Login';

  @override
  Widget build() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ctrl.email.ui(),
        ctrl.password.ui(),
        TextButton(
          onPressed: ctrl.login,
          child: const Text('Đăng nhập'),
        )
      ],
    );
  }
}
