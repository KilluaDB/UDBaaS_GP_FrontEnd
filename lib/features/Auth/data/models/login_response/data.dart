class Data {
  String? accessToken;

  Data({this.accessToken});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(accessToken: json['access_token'] as String?);

  Map<String, dynamic> toJson() => {'access_token': accessToken};
}
