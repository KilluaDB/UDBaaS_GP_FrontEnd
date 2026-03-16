class Data {
  String? accessToken;
  String? user_id;

  Data({this.accessToken, this.user_id});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(accessToken: json['access_token'] as String?,user_id: json['user_id'] as String?);

  Map<String, dynamic> toJson() => {'access_token': accessToken,'user_id':user_id};
}
