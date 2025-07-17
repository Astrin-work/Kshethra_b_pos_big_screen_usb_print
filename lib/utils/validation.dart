class Validation {
  static String? nameValidation(String? value) {
    RegExp regex = RegExp(r'^[a-zA-Z\s]+$');
    final name = value ?? "";
    if (name.isEmpty) {
      return "Enter your name";
    }
    if (!regex.hasMatch(name)) {
      return "Name should not contain special characters & numbers";
    }
    return null;
  }

  static String? phoneValidation(String? value) {
    final phone = value?.trim() ?? "";
    if (phone.isEmpty) {
      return "Phone number is required";
    }

    final cleanedPhone = phone.replaceAll(RegExp(r'^(\+91|91|0)'), '');

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanedPhone)) {
      return "Enter a valid phone number";
    }

    if (RegExp(r'^(\d)\1{9}$').hasMatch(cleanedPhone)) {
      return "Phone number cannot have all digits the same";
    }

    return null;
  }

  static String? numberValidation(
      String? value,
      String nullMsg,
      String invldMsg,
      ) {
    RegExp regex = RegExp(r'^[0-9]+$');
    final number = value ?? "";
    if (number.isEmpty) {
      return nullMsg;
    }
    if (!regex.hasMatch(number)) {
      return invldMsg;
    }
    return null;
  }

  static String? emptyValidation(String? value, String msg) {
    final input = value ?? "";
    if (input.isEmpty) {
      return msg;
    }
    return null;
  }

  static String? validateStarSelection(String selectedStar) {
    if (selectedStar.isEmpty || selectedStar == 'Select') {
      return 'Please select a star';
    }
    return null;
  }
}
