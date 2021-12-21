import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mon_profil/profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Profile myProfile = Profile(firstname: "Daniel", lastname: "Visage");
  late TextEditingController firstname;
  late TextEditingController lastname;
  late TextEditingController secret;
  late TextEditingController age;
  bool showSecret = false;

  Map<String, bool> hobbies = {
    "Yoga": false,
    "Video games": false,
    "Coding": false,
    "Reading": false,
  };

  ImagePicker picker = ImagePicker();
  File? imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstname = TextEditingController();
    lastname = TextEditingController();
    secret = TextEditingController();
    age = TextEditingController();
    firstname.text = myProfile.firstname;
    lastname.text = myProfile.lastname;
    secret.text = myProfile.secret;
    age.text = myProfile.age.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    firstname.dispose();
    lastname.dispose();
    secret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width / 4;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            color: Colors.blue.shade200,
            elevation: 7,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(myProfile.setName()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: (imageFile == null)
                            ? Image.network("https://codabee.com/wp-content/uploads/2018/03/cropped-Artboard-2.png")
                            : Image.file(imageFile!, height:imageSize, width:imageSize),
                      ),
                      Column(
                        children: [
                          Text("Age: ${myProfile.setAge()}"),
                          Text("Taille: ${myProfile.setHeight()}"),
                          Text("Gender: ${myProfile.genderString()}"),
                        ],
                      ),
                    ],
                  ),
                  Text("Hobbies: ${myProfile.setHobbies()}"),
                  Text(
                      "Favorite programming language: ${myProfile.favoriteLang}"),
                  ElevatedButton(
                      onPressed: updateSecret,
                      child:
                          Text((showSecret) ? "Hide secret" : "Show secret")),
                  (showSecret)
                      ? Text(myProfile.secret)
                      : Container(height: 0, width: 0),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                onPressed: (() => getImage(source: ImageSource.camera)),
                icon: Icon(Icons.camera_alt_rounded),
                color: Colors.blueGrey,
              ),
              IconButton(
                onPressed: (() => getImage(source: ImageSource.gallery)),
                icon: Icon(Icons.photo_album_outlined),
                color: Colors.blueGrey,
              )
            ],
          ),
          const Divider(color: Colors.blueGrey, thickness: 2),
          myTitle("Edit info"),
          myTextField(controller: firstname, hint: "Enter your first name"),
          myTextField(controller: lastname, hint: "Enter your last name"),
          myTextField(
              controller: secret, hint: "Tell me a secret", isSecret: true),
          myTextField(
              controller: age,
              hint: "Enter your age",
              type: TextInputType.number),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Gender: ${myProfile.genderString()}"),
              Switch(
                  value: myProfile.gender,
                  onChanged: ((newBool) {
                    setState(() {
                      myProfile.gender = newBool;
                    });
                  })),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Height: ${myProfile.setHeight()}",
              ),
              Slider(
                value: myProfile.height,
                min: 0,
                max: 250,
                onChanged: ((newHeight) {
                  setState(() {
                    myProfile.height = newHeight;
                  });
                }),
              )
            ],
          ),
          const Divider(
            color: Colors.blueGrey,
            thickness: 2,
          ),
          myHobbies(),
          const Divider(
            color: Colors.blueGrey,
            thickness: 2,
          ),
          myRadios(),
        ],
      )),
    );
  }

  void updateUser() {
    setState(() {
      myProfile = Profile(
        firstname: (firstname.text != myProfile.firstname)
            ? firstname.text
            : myProfile.firstname,
        lastname: (lastname.text != myProfile.lastname)
            ? lastname.text
            : myProfile.lastname,
        secret: secret.text,
        favoriteLang: myProfile.favoriteLang,
        hobbies: myProfile.hobbies,
        height: myProfile.height,
        age: int.parse(age.text),
        gender: myProfile.gender,
      );
    });
  }

  TextField myTextField(
      {required TextEditingController controller,
      required String hint,
      bool isSecret = false,
      TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
      ),
      obscureText: isSecret,
      onSubmitted: ((newValue) {
        updateUser();
      }),
    );
  }

  updateSecret() {
    setState(() {
      showSecret = !showSecret;
    });
  }

  Column myHobbies() {
    List<Widget> widgets = [myTitle("My Hobbies")];
    hobbies.forEach((hobby, like) {
      Row r = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(hobby),
          Checkbox(
              value: like,
              onChanged: (newBool) {
                setState(() {
                  hobbies[hobby] = newBool ?? false;
                  List<String> str = [];
                  hobbies.forEach((key, value) {
                    if (value == true) {
                      str.add(key);
                    }
                  });
                  myProfile.hobbies = str;
                });
              })
        ],
      );
      widgets.add(r);
    });
    return Column(children: widgets);
  }

  Column myRadios() {
    List<Widget> w = [];
    List<String> langs = ["Dart", "Kotlin", "Swift", "Javascript", "Python"];
    int index =
        langs.indexWhere((lang) => lang.startsWith(myProfile.favoriteLang));

    for (var x = 0; x < langs.length; x++) {
      Column c = Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(langs[x]),
          Radio(
              value: x,
              groupValue: index,
              onChanged: (newValue) {
                setState(() {
                  myProfile.favoriteLang = langs[newValue as int];
                });
              })
        ],
      );
      w.add(c);
    }
    return Column(
      children: [
        myTitle("My Favorite Language"),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: w),
      ],
    );
  }

  Text myTitle(String text) {
    return Text(text,
        style: TextStyle(
          color: Colors.blue[900],
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ));
  }

  Future getImage({required ImageSource source}) async {
    final chosenFile = await picker.getImage(source: source);

    setState(() {
      if (chosenFile == null) {
        print('nothing to add');
      } else {
        imageFile = File(chosenFile.path);
      }
    });
  }
}
