enum BaseUrl {
  reqRel._(reqReslUrl),
  jsonPlaceHolder._(jsonPlaceHolderUrl);

  const BaseUrl._(this.key);
  final int key;

  static const reqReslUrl = 0;
  static const jsonPlaceHolderUrl = 1;
}
