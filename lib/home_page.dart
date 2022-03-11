import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> food = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Food'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _handleClickButton,
              child: const Text('LOAD FOODS DATA'),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: food.length,
                    itemBuilder: (context, index) => buildCard(food[index])))
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _handleClickButton() async {
    final url = Uri.parse('https://cpsu-test-api.herokuapp.com/foods');
    var result = await http.get(url);
    var json = jsonDecode(result.body);
    food = json['data'];
    print(food);
  }

  Card buildCard(dynamic thread) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                ),
                Image.network(thread.image),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      thread.name,
                      style:
                          TextStyle(fontSize: 50.0,),
                    ),
                    Text(
                      '${thread.price} บาท',
                      style:
                          TextStyle(fontSize: 25.0,),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
