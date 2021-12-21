class Profile {
  String firstname;
  String lastname;
  int age;
  bool gender;
  double height;
  String secret;
  List<String> hobbies = [];
  String favoriteLang;

  Profile({
    String this.firstname = "",
    this.lastname = "",
    this.age = 0,
    this.gender = false,
    this.height = 0.0,
    this.secret = "",
    this.hobbies = const [],
    this.favoriteLang = "Dart",
  });

  String setName() => "$firstname $lastname";

  String setAge() {
    String ageString = "$age years old";
    if (age > 1) {
      ageString += "s";
    }
    return ageString;
  }

  String genderString() => (gender) ? "Female" : "Male";

  String setHeight() => "${height.toInt()} cm";

  String setHobbies() {
    String toHobbiesString = "";
    if(hobbies.length == 0){
      return toHobbiesString;

    } else {
      hobbies.forEach((hobby) {
        toHobbiesString += " $hobby,";
      });

      return toHobbiesString;
    }
  }
}
