class CustomerModel {
  late String customerName, phoneNumber, type, profilePicture, emailAddress, customerAddress, dueAmount;

  CustomerModel(this.customerName, this.phoneNumber, this.type, this.profilePicture, this.emailAddress, this.customerAddress, this.dueAmount);

  CustomerModel.fromJson(Map<dynamic, dynamic> json)
      : customerName = json['customerName'] as String,
        phoneNumber = json['phoneNumber'] as String,
        type = json['type'] as String,
        profilePicture = json['profilePicture'] as String,
        emailAddress = json['emailAddress'] as String,
        customerAddress = json['customerAddress'] as String,
        dueAmount = json['due'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'customerName': customerName,
        'phoneNumber': phoneNumber,
        'type': type,
        'profilePicture': profilePicture,
        'emailAddress': emailAddress,
        'customerAddress': customerAddress,
        'due': dueAmount,
      };
}
