import 'package:freezed_annotation/freezed_annotation.dart';

part 's3_urls.freezed.dart';

part 's3_urls.g.dart';

@freezed
class S3Urls with _$S3Urls {
  const factory S3Urls({
    required String normal,
    required String comp,
    required String thumb,
  }) = _S3Urls;

  factory S3Urls.fromJson(Map<String, Object?> json) => _$S3UrlsFromJson(json);
}
