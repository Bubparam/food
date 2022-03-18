import 'package:flutter/material.dart';
import 'package:untitled1/api_result.dart';
import 'package:untitled1/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  static const buttonSize = 60.0;

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _input = '';
  String _input2 = '123456';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(color: Colors.yellow.shade50, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: Offset(2.0, 5.0),
              blurRadius: 5.0,
              spreadRadius: 2.0,
            )
          ]),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock,
                              size: 80.0,
                              color: Colors.deepOrangeAccent,
                            ),
                            Text(
                              'กรุณาใส่รหัสผ่าน',
                              style: TextStyle(
                                  fontSize: 25.0, color: Color(0x80FF0000)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < _input.length; i++)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.limeAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  width: 35.0,
                                  height: 35.0,
                                ),
                              ),
                            for (var i = 0;
                                i < (_input2.length - _input.length);
                                i++)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  width: 35.0,
                                  height: 35.0,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 1; i <= 3; i++) buildButton(i),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 4; i <= 6; i++) buildButton(i),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 7; i <= 9; i++) buildButton(i),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            print("Delete");
                            setState(() {
                              _input = "";
                            });
                          },
                          borderRadius:
                              BorderRadius.circular(LoginPage.buttonSize / 2),
                          child: Container(
                            alignment: Alignment.center,
                            width: LoginPage.buttonSize,
                            height: LoginPage.buttonSize,
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                      buildButton(0),
                      buildButton(-1),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      child: Text('ลืมรหัสผ่าน'),
                      style: TextButton.styleFrom(
                        primary: Colors.lime,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(int num) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () async {
          if (num == -1) {
            print('Backspace');

            setState(() {
              var length = _input.length;
              _input = _input.substring(0, length - 1);
            });
          } else {
            if (_input.length < 6) {
              setState(() {
                _input = '$_input$num';
              });
            }
          }
          final url = Uri.parse('https://cpsu-test-api.herokuapp.com/login');
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'pin': _input}),
          );
          var json = jsonDecode(response.body);
          var apiResult = ApiResult.fromJson(json);

          if (apiResult.data == true) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (_input2 != _input && _input.length == 6) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Incorrect PIN'),
                    content: Text('กรุณากรอกใหม่'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      )
                    ],
                  );
                });
          }
        },
        borderRadius: BorderRadius.circular(LoginPage.buttonSize / 2),
        child: Container(
          decoration: (num == -1)
              ? null
              : BoxDecoration(
                  color: Colors.lime,
                  shape: BoxShape.circle,
                ),
          alignment: Alignment.center,
          width: LoginPage.buttonSize,
          height: LoginPage.buttonSize,
          child: (num == -1)
              ? Icon(Icons.backspace)
              : Text(
                  '$num',
                  style: TextStyle(color: Color(0xffffffff)),
                ),
        ),
      ),
    );
  }
}
