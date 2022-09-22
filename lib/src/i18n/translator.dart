import 'package:get/get.dart';

class Translator extends Translations {
  Map<String, Map<String, String>>? _cachedKeys;
  @override
  Map<String, Map<String, String>> get keys => _cachedKeys ??= {
        "vi": {
          "defaultButtonLabel": "Default Button Label",
          "email": "Email",
          "password": "Password",
          "select": "Select",
          "errorHappen": "Error Happen",
          "pleaseLoginFirst": "Please Login First",
          "inputAtLeastChars(@p1)": "Input At Least Chars(@p1)",
          "pleaseInputEmail": "Please Input Email",
          "passwordNotMatch": "Password Not Match",
          "mustContains(@p1)": "Must Contains(@p1)",
          "invalidValue": "Invalid Value",
          "existedValue": "Existed Value",
          "error": "Error",
          "login": "Login"
        },
        "en": {
          "defaultButtonLabel": "Default Button Label",
          "email": "Email",
          "password": "Password",
          "select": "Select",
          "errorHappen": "Error Happen",
          "pleaseLoginFirst": "Please Login First",
          "inputAtLeastChars(@p1)": "Input At Least Chars(@p1)",
          "pleaseInputEmail": "Please Input Email",
          "passwordNotMatch": "Password Not Match",
          "mustContains(@p1)": "Must Contains(@p1)",
          "invalidValue": "Invalid Value",
          "existedValue": "Existed Value",
          "error": "Error",
          "login": "Login"
        }
      };
}
