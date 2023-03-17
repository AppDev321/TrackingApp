class LoginResponse {
  String? token;
  User? user;

  LoginResponse({this.token, this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstname;
  String? middlename;
  String? lastname;
  String? contactNo;
  String? officialEmail;
  String? personalEmail;
  String? dateOfBirth;
  String? gender;
  String? emergencyContactRelationship;
  String? emergencyContact;
  String? emergencyContactAddress;
  String? currentAddress;
  String? permanentAddress;
  String? city;
  String? picture;
  String? joiningDate;
  String? exitDate;
  String? fullName;

  User(
      {this.id,
        this.firstname,
        this.middlename,
        this.lastname,

        this.contactNo,
        this.officialEmail,
        this.personalEmail,

        this.dateOfBirth,
        this.gender,
        this.emergencyContactRelationship,
        this.emergencyContact,
        this.emergencyContactAddress,
        this.currentAddress,
        this.permanentAddress,
        this.city,

        this.picture,
        this.joiningDate,
        this.exitDate,

        this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    middlename = json['middlename'];
    lastname = json['lastname'];

    contactNo = json['contact_no'];
    officialEmail = json['official_email'];
    personalEmail = json['personal_email'];

    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    emergencyContactRelationship = json['emergency_contact_relationship'];
    emergencyContact = json['emergency_contact'];
    emergencyContactAddress = json['emergency_contact_address'];
    currentAddress = json['current_address'];
    permanentAddress = json['permanent_address'];
    city = json['city'];

    picture = json['picture'];
    joiningDate = json['joining_date'];
    exitDate = json['exit_date'];

    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['middlename'] = this.middlename;
    data['lastname'] = this.lastname;

    data['contact_no'] = this.contactNo;
    data['official_email'] = this.officialEmail;
    data['personal_email'] = this.personalEmail;

    data['date_of_birth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['emergency_contact_relationship'] = this.emergencyContactRelationship;
    data['emergency_contact'] = this.emergencyContact;
    data['emergency_contact_address'] = this.emergencyContactAddress;
    data['current_address'] = this.currentAddress;
    data['permanent_address'] = this.permanentAddress;
    data['city'] = this.city;

    data['picture'] = this.picture;
    data['joining_date'] = this.joiningDate;
    data['exit_date'] = this.exitDate;


    data['full_name'] = this.fullName;
    return data;
  }
}