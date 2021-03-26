import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io';
//import 'dart:async';

_write(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/survey.txt');
  await file.writeAsString(text);
}

/*//WRITE FILE
//START:
//gets the path of the file
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

//gets the location of the file
Future<File> get _localFile async {
  final path = await _localPath;
  return new File('$path/survey.txt');
}

//write to file
Future<File> writeToFile(String message)async {
  final file = await _localFile;
  return file.writeAsString(message);
}*/

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  String _questionOne;
  String _questionTwo;
  String _questionThree;
  String _questionFour;

/*
  String _name;
  String _email;
  String _password;
  String _url;
  String _phoneNumber;
  String _calories;
*/

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildQuestionOne() {
    return TextFormField(
      decoration: InputDecoration(
          labelText:
              'How would you rate your ColorFind experience?',
          helperText:
              'Please enter a number from 1 to 10.'),
      maxLength: 2,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Required';
        }

        return null;
      },
      onSaved: (String value) {
        _questionOne = value;
      },
    );
  }

  Widget _buildQuestionTwo() {
    return TextFormField(
      maxLines: 2,
      decoration: InputDecoration(
          labelText:
          'Before your ColorFind session, how would you\nrate your stress levels?',
          helperText:
          'Please enter a number from 1 to 10.'),
      maxLength: 2,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Required';
        }

        return null;
      },
      onSaved: (String value) {
        _questionTwo = value;
      },
    );
  }

  Widget _buildQuestionThree() {
    return TextFormField(
      maxLines:2,
      decoration: InputDecoration(
          labelText:
          'After your ColorFind session, how would you\nrate your stress levels?',
          helperText:
          'Please enter a number from 1 to 10.'),
      maxLength: 2,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Required';
        }

        return null;
      },
      onSaved: (String value) {
        _questionThree = value;
      },
    );
  }

  Widget _buildQuestionFour() {
    return TextFormField(
      decoration: InputDecoration(
          labelText:
          'How can we improve?',
          helperText:
          'All suggestions are appreciated!'),
      maxLength: 200,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Required';
        }

        return null;
      },
      onSaved: (String value) {
        _questionFour = value;
      },
    );
  }

  /*
  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  Widget _buildURL() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Url'),
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _url = value;
      },
    );
  }

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone number'),
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Phone number is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _url = value;
      },
    );
  }

  Widget _buildCalories() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Calories'),
      keyboardType: TextInputType.number,
      validator: (String value) {
        int calories = int.tryParse(value);

        if (calories == null || calories <= 0) {
          return 'Calories must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        _calories = value;
      },
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Survey Form")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                _buildQuestionOne(),
                _buildQuestionTwo(),
                _buildQuestionThree(),
                _buildQuestionFour(),

                /*
                _buildName(),
                _buildEmail(),
                _buildPassword(),
                _buildURL(),
                _buildPhoneNumber(),
                _buildCalories(),
                 */

                SizedBox(height: 200),
                RaisedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();

                    Fluttertoast.showToast(
                        msg: "Your submission has been recorded.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );

                    String answer = _questionOne+", "+_questionTwo+", "+_questionThree+", "+_questionFour;
                    _write(answer);

                    /*
                    print(_name);
                    print(_email);
                    print(_phoneNumber);
                    print(_url);
                    print(_password);
                    print(_calories);
                    */
                    //Send to API
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}