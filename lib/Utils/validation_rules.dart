const String regularExpressionphone = r"^(3[0-7][0-9])[0-9]{7}$";
const String regularExpressionEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@(?:gmail\.com|yahoo\.com|hotmail\.com|outlook\.com)$";

class ValidationRules {
  String? normal(String? value) {
    if (value == null || value.isEmpty) {
      return "   * Required";
    }
    return null;
  }

  email(String? value) {
    RegExp regExp = RegExp(regularExpressionEmail);
    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (value.contains('@')) {
      if (!value.endsWith('@gmail.com') &&
          !value.endsWith('@yahoo.com') &&
          !value.endsWith('@hotmail.com') &&
          !value.endsWith('@outlook.com')) {
        return 'Unsupported email provider';
      }
    } else if (!regExp.hasMatch(value)) {
      return 'Enter Valid Email Address';
    } else {
      return null;
    }
  }

  password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one capital letter';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    if (value.length < 8) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  phone(String? value) {
    RegExp regExp = RegExp(regularExpressionphone);
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    } else if (!RegExp(r'^3[0-7][0-9]').hasMatch(value)) {
      return 'Dial code is not supported.';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter Valid phone number';
    } else {
      return null;
    }
  }
}
