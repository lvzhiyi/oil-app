class UploadSignatureRequest {
  final String bizPrefix;
  final String contentType;
  final int contentLength;

  UploadSignatureRequest(
      {required this.bizPrefix,
      required this.contentType,
      required this.contentLength});

  Map<String, dynamic> toJson() => {
        'bizPrefix': bizPrefix,
        'contentType': contentType,
        'contentLength': contentLength,
      };
}
