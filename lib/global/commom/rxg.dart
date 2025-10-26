class CommonRegExp {
  static final RegExp password =
      RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9]+$');
}
