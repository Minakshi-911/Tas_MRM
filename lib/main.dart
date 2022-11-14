// main.dart
import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for using json.decode()

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      title: 'Beer Catalog App',
      home: const HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String setText= "";
  late bool isLoading = true;
  List _RandomBeers = [];

  Future<void> _fetchData() async {
    const apiUrl = 'https://random-data-api.com/api/v2/beers?size=100&response_type=json';
    isLoading = true;
    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);
    if(response.statusCode==200){
      isLoading = false;
      setText = "No Error";
      setState(() {
        _RandomBeers = data;
      });
    }
    else if(response.statusCode == 403){
      isLoading = false;
      setText = "Forbidden";
    }
    else if(response.statusCode == 404){
      isLoading = false;
      setText = "404 - Not Found";
    }
    else if(response.statusCode == 404){
      isLoading = false;
      setText = "404 - Not Found";
    }
    else if(response.statusCode == 408){
      isLoading = false;
      setText = "Request Timed Out";
    }
    else{
      isLoading = false;
      setText = "An error occurred";
    }
     
    
    
// log(_RandomBeers[0]['id'].toString());
  }

Timer? timer;
  @override
  void initState() {

timer =     Timer.periodic(const Duration(seconds:10),(timer)=>_fetchData()); 

   
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    int list_length = 2 + Random().nextInt(100 - 2);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Beer Catalog App'),
        ),
        body: SafeArea(
            child: 
                  (isLoading == true)
                  ? const Center(child: CircularProgressIndicator(),)
                  :(setText == "No Error")
                  ?ListView.builder(
                    itemCount: list_length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: RichText(
                            text: TextSpan(
                              text:"${_RandomBeers[index]['name']} ",
                            children: [TextSpan(
                              text: 'by ${_RandomBeers[index]['brand']} (${_RandomBeers[index]['alcohol']} Alcohol)',
                              style: const TextStyle(color: Colors.black)
                            )],
                            style: TextStyle(
                              fontSize: 15,
                              color: (num.parse(_RandomBeers[index]['alcohol'].toString().split('%')[0].toString()) < 5)
                              ? Colors.green : Colors.red,
                            ),),
                          )),
                  );
                  }
                ):Center(child: Text("${setText}"))));
                         
              
  }
}