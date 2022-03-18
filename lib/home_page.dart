import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:untitled1/api_result.dart';
import 'package:untitled1/food_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<FoodItem> _food = [];

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
                    itemCount: _food.length,
                    itemBuilder: (context, index) => buildCard(_food[index])))
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _handleClickButton() async {
    final url = Uri.parse('https://cpsu-test-api.herokuapp.com/foods');
    var result = await http.get(url);
    var json = jsonDecode(result.body);
    var apiResult = ApiResult.fromJson(json);

    /*List<dynamic> data= json['data'];
    print(data);*/

    setState(() {
      for(var i in apiResult.data){
        var foodItem = FoodItem.fromJson(i);
        _food.add(foodItem);
      }
    });
  }

  Card buildCard(FoodItem thread) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(thread.image,width: 80,height: 80,),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      thread.name,
                      style:
                          TextStyle(fontSize: 30.0,),
                    ),
                    Text(
                      '${thread.price} บาท',
                      style:
                          TextStyle(fontSize: 15.0,),
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
