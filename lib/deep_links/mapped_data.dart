class MappedDeepLinkData {
  final String id;
  final String resource;
  final Map data;
  final Map rawData;
  final dynamic extraData;

  MappedDeepLinkData(
      {required this.id,
      required this.resource,
      required this.data,
      required this.rawData,
      this.extraData
      });
}
