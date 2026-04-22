enum FileUploadType {
  userProfile('user-profile'),
  passport('passport'),
  unknown('unknown');

  final String apiValue;

  const FileUploadType(this.apiValue);
}
