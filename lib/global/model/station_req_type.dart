import 'package:oil_business_app/global/enum/common.dart';

class GetStationRequest {
  final int page;
  final int pageSize;
  final List<StationStatus> statuses;

  GetStationRequest(
      {required this.page, required this.pageSize, required this.statuses});

  Map<String, dynamic> toJson() => {
        'page': page,
        'pageSize': pageSize,
        'statuses': statuses.map((e) => e.name).toList(),
      };
}
