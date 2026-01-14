import 'package:equatable/equatable.dart';

final class TokenResponseModel extends Equatable {
  final String? accessToken;
  final String? refreshToken;

  const TokenResponseModel({this.accessToken, this.refreshToken});

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) {
    return TokenResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
