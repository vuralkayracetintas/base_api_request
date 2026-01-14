import 'package:equatable/equatable.dart';

// Coordinates Model
final class Coordinates extends Equatable {
  final double? lat;
  final double? lng;

  const Coordinates({this.lat, this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }

  @override
  List<Object?> get props => [lat, lng];
}

// Address Model
final class Address extends Equatable {
  final String? address;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? postalCode;
  final Coordinates? coordinates;
  final String? country;

  const Address({
    this.address,
    this.city,
    this.state,
    this.stateCode,
    this.postalCode,
    this.coordinates,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      stateCode: json['stateCode'],
      postalCode: json['postalCode'],
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'stateCode': stateCode,
      'postalCode': postalCode,
      'coordinates': coordinates?.toJson(),
      'country': country,
    };
  }

  @override
  List<Object?> get props => [
    address,
    city,
    state,
    stateCode,
    postalCode,
    coordinates,
    country,
  ];
}

// Hair Model
final class Hair extends Equatable {
  final String? color;
  final String? type;

  const Hair({this.color, this.type});

  factory Hair.fromJson(Map<String, dynamic> json) {
    return Hair(color: json['color'], type: json['type']);
  }

  Map<String, dynamic> toJson() {
    return {'color': color, 'type': type};
  }

  @override
  List<Object?> get props => [color, type];
}

// Bank Model
final class Bank extends Equatable {
  final String? cardExpire;
  final String? cardNumber;
  final String? cardType;
  final String? currency;
  final String? iban;

  const Bank({
    this.cardExpire,
    this.cardNumber,
    this.cardType,
    this.currency,
    this.iban,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      cardExpire: json['cardExpire'],
      cardNumber: json['cardNumber'],
      cardType: json['cardType'],
      currency: json['currency'],
      iban: json['iban'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardExpire': cardExpire,
      'cardNumber': cardNumber,
      'cardType': cardType,
      'currency': currency,
      'iban': iban,
    };
  }

  @override
  List<Object?> get props => [cardExpire, cardNumber, cardType, currency, iban];
}

// Company Model
final class Company extends Equatable {
  final String? department;
  final String? name;
  final String? title;
  final Address? address;

  const Company({this.department, this.name, this.title, this.address});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      department: json['department'],
      name: json['name'],
      title: json['title'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department': department,
      'name': name,
      'title': title,
      'address': address?.toJson(),
    };
  }

  @override
  List<Object?> get props => [department, name, title, address];
}

// Crypto Model
final class Crypto extends Equatable {
  final String? coin;
  final String? wallet;
  final String? network;

  const Crypto({this.coin, this.wallet, this.network});

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      coin: json['coin'],
      wallet: json['wallet'],
      network: json['network'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'coin': coin, 'wallet': wallet, 'network': network};
  }

  @override
  List<Object?> get props => [coin, wallet, network];
}

// GetMe Model (Main User Model)
final class GetMeModel extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? maidenName;
  final int? age;
  final String? gender;
  final String? email;
  final String? phone;
  final String? username;
  final String? password;
  final String? birthDate;
  final String? image;
  final String? bloodGroup;
  final double? height;
  final double? weight;
  final String? eyeColor;
  final Hair? hair;
  final String? ip;
  final Address? address;
  final String? macAddress;
  final String? university;
  final Bank? bank;
  final Company? company;
  final String? ein;
  final String? ssn;
  final String? userAgent;
  final Crypto? crypto;
  final String? role;

  const GetMeModel({
    this.id,
    this.firstName,
    this.lastName,
    this.maidenName,
    this.age,
    this.gender,
    this.email,
    this.phone,
    this.username,
    this.password,
    this.birthDate,
    this.image,
    this.bloodGroup,
    this.height,
    this.weight,
    this.eyeColor,
    this.hair,
    this.ip,
    this.address,
    this.macAddress,
    this.university,
    this.bank,
    this.company,
    this.ein,
    this.ssn,
    this.userAgent,
    this.crypto,
    this.role,
  });

  factory GetMeModel.fromJson(Map<String, dynamic> json) {
    return GetMeModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      maidenName: json['maidenName'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      password: json['password'],
      birthDate: json['birthDate'],
      image: json['image'],
      bloodGroup: json['bloodGroup'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      eyeColor: json['eyeColor'],
      hair: json['hair'] != null ? Hair.fromJson(json['hair']) : null,
      ip: json['ip'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      macAddress: json['macAddress'],
      university: json['university'],
      bank: json['bank'] != null ? Bank.fromJson(json['bank']) : null,
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
      ein: json['ein'],
      ssn: json['ssn'],
      userAgent: json['userAgent'],
      crypto: json['crypto'] != null ? Crypto.fromJson(json['crypto']) : null,
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'maidenName': maidenName,
      'age': age,
      'gender': gender,
      'email': email,
      'phone': phone,
      'username': username,
      'password': password,
      'birthDate': birthDate,
      'image': image,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'eyeColor': eyeColor,
      'hair': hair?.toJson(),
      'ip': ip,
      'address': address?.toJson(),
      'macAddress': macAddress,
      'university': university,
      'bank': bank?.toJson(),
      'company': company?.toJson(),
      'ein': ein,
      'ssn': ssn,
      'userAgent': userAgent,
      'crypto': crypto?.toJson(),
      'role': role,
    };
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    maidenName,
    age,
    gender,
    email,
    phone,
    username,
    password,
    birthDate,
    image,
    bloodGroup,
    height,
    weight,
    eyeColor,
    hair,
    ip,
    address,
    macAddress,
    university,
    bank,
    company,
    ein,
    ssn,
    userAgent,
    crypto,
    role,
  ];
}
