class Data {
  String? message;
  String? accessToken;
  String? refreshToken;
  String? accessTokenExpiresIn;
  String? refreshTokenExpiresIn;

  Data({
    this.message,
    this.accessToken,
    this.refreshToken,
    this.accessTokenExpiresIn,
    this.refreshTokenExpiresIn,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json['message'] as String?,
    accessToken: json['access_token'] as String?,
    refreshToken: json['refresh_token'] as String?,
    accessTokenExpiresIn: json['access_token_expires_in'] as String?,
    refreshTokenExpiresIn: json['refresh_token_expires_in'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'access_token_expires_in': accessTokenExpiresIn,
    'refresh_token_expires_in': refreshTokenExpiresIn,
  };
}
