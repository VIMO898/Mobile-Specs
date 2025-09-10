class FormValidationHelper {
  static String? validateEmail(String? value) => value == null || value.isEmpty
      ? 'Email is required'
      : !RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)
          ? 'Invalid email address'
          : null;

  static String? validateUsername(String? value) =>
      value == null || value.isEmpty
          ? 'Username is required'
          : value.length < 4
              ? 'Username must be at least 4 characters long'
              : null;

  static String? validatePassword(String? value) =>
      value == null || value.isEmpty
          ? 'Password is required'
          : value.length < 6
              ? 'Password must be at least 6 characters long'
              : null;
}
