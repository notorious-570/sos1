import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:telephony/telephony.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final telephony = Telephony.instance;
  TextEditingController contact1Controller = TextEditingController();

  String contact1 = '';

  TextEditingController contact2Controller = TextEditingController();

  String contact2 = '';

  TextEditingController contact3Controller = TextEditingController();

  String contact3 = '';
  bool isEnable = true;
  String statusText = "";
  static int counter = 0;

  late ShakeDetector detector;

  @override
  void initState() {
    super.initState();
    loadContacts();
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        _sendSMS(contact1, contact2, contact3);
        setState(() {
          statusText = "sms sent";
        });
      },
    );
  }

  void loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      contact1 = (prefs.getString('contact1') ?? "");
      contact2 = (prefs.getString('contact2') ?? "");
      contact3 = (prefs.getString('contact3') ?? "");
    });
    contact1Controller.text = contact1;
    contact2Controller.text = contact2;
    contact3Controller.text = contact3;

  }

  void _sendSMS(String contact1, String contact2, String contact3) async {
    if (contact1 != null || contact1.trim() != "") {
      telephony.sendSms(to: contact1, message: "I am in danger, Help me!");
    } else {
      setState(() {
        statusText = "please add emergency contact";
      });
    }
    if (contact2 != null || contact2.trim() != "") {
      telephony.sendSms(to: contact2, message: "I am in danger, Help me!");
    }
    if (contact3 != null || contact3.trim() != "") {
      telephony.sendSms(to: contact3, message: "I am in danger, Help me!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add contacts"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  enabled: isEnable,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Emergence Contact 1',
                    hintText: 'Emergence Contact 1',
                  ),
                  controller: contact1Controller,
                  onChanged: (text) {
                    setState(() {
                      contact1 = text;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  enabled: isEnable,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Emergence Contact 2',
                    hintText: 'Emergence Contact 2',
                  ),
                  controller: contact2Controller,
                  onChanged: (text) {
                    setState(() {
                      contact2 = text;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  enabled: isEnable,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Emergence Contact 3',
                    hintText: 'Emergence Contact 3',
                  ),
                  controller: contact3Controller,
                  onChanged: (text) {
                    setState(() {
                      contact3 = text;
                    });
                  },
                ),
              ),
              ElevatedButton(
                child: Container(
                  child: Text(
                    isEnable
                        ? 'Add Emergencey Contact'
                        : "Update Emergencey Contact",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  setState(() {
                    prefs.setString('contact1', contact1);
                    prefs.setString('contact2', contact2);
                    prefs.setString('contact3', contact3);
                    isEnable = !isEnable;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Container(
                    child: Text(
                  "Send Signal",
                  style: TextStyle(color: Colors.white),
                )),
                onPressed: () {
                  String message = "This is a test message!";
                  List<String> recipents = ["8446842249", "8623986326"];

                  _sendSMS(contact1, contact2, contact3);
                },
              ),
              Text(statusText),
            ],
          ),
        ),
      ),
    );
  }
}
