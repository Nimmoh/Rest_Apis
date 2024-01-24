import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:rest_api/model/user.dart';
import 'package:rest_api/model/user_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
    

    @override
    void initState(){
      super.initState();
      fetchUsers();
    }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Rest Api Call"),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index){
          final user = users[index];
          final email = user.email;
          final Color = user.gender == 'male' ? Colors.blue : Colors.green;
          
        return ListTile(
          title: Text(user.fullName),
          subtitle:Text(user.phone),
          //tileColor: Color,
        );
    },
      ),
      //floatingActionButton: FloatingActionButton(onPressed: fetchUsers,),
    );

    }
    Future<void> fetchUsers() async{
      final response =await UserApi.fetchUsers();
      setState(() {
        users =response;
      });
    }
  }
  Future<List<void>> fetchUsers() async {
    var logger = Logger();

    print("fetchUsers called");
    const url = 'https://randomuser.me/api/?results=5000';
    final uri = Uri.parse(url);
    final response =await http.get(uri);
    final body = response.body;

    final json = jsonDecode(body);
     logger.t(json);

    final results = json['results'] as List<dynamic>;
    final Transformed = results.map((e){
      final name = UserName(
        title: e['user']['title'],
        first: e['user']['first'], 
        last: e['user']['last'], 
      );
        
        return User(
          cell: e['cell'],
          email: e['email'],
          gender: e['nat'],
          nat: e['nat'],
          phone: e['phone'],
          name: name,
        );
      
        
      }).toList();
      return Transformed;




    setState(() {
      users = Transformed;
    });
    log('fetch users completed' as num);
  }
