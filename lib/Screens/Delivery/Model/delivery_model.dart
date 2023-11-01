class DeliveryModel {
  late String firstName, lastname, emailAddress, phoneNumber, countryName, addressLocation, addressType;

  DeliveryModel(this.firstName, this.lastname, this.emailAddress, this.phoneNumber, this.countryName, this.addressLocation, this.addressType);

  DeliveryModel.fromJson(Map<dynamic, dynamic> json)
      : firstName = json['firstName'] as String,
        lastname = json['lastname'] as String,
        emailAddress = json['emailAddress'] as String,
        phoneNumber = json['phoneNumber'] as String,
        countryName = json['countryName'] as String,
        addressLocation = json['addressLocation'] as String,
        addressType = json['addressType'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'firstName': firstName,
        'lastname': lastname,
        'emailAddress': emailAddress,
        'phoneNumber': phoneNumber,
        'countryName': countryName,
        'addressLocation': addressLocation,
        'addressType': addressType,
      };
}
