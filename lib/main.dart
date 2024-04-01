import 'dart:async';

import 'package:bloc_api/blocs/app_blocs.dart';
import 'package:bloc_api/blocs/app_events.dart';
import 'package:bloc_api/blocs/app_states.dart';
import 'package:bloc_api/repos/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/user_model.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: RepositoryProvider(
        create: (context) => UserRepository(),
        child: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
        RepositoryProvider.of<UserRepository>(context),
      )..add(LoadUserEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,

          title: Text("BLOC APP", style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
        body: BlocListener<UserBloc,UserState>(
          listener: (context, state) {
            if(state is UserLoadingState){
              showDialog(context: context, builder: (context) {
                return Container(
                  width: double.infinity,
                  height: 100,
                  child: AlertDialog(
                    title:  Text("İşleminiz Yapılıyor..."),
                      content: LinearProgressIndicator(
                    ),
                  ),
                );
              },);
            }
            if(state is UserLoadedState){
              Navigator.of(context).pop();
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title:  Text("Yüklendi"),
                  content: Icon(
                      Icons.done,
                      size: 50,
                    color: Colors.green,
                  ),
                );
              },);
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop();
              });
            }
            if(state is UserErrorState){
              Navigator.of(context).pop();
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title:  Text("Hata Oluştu"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.error),
                      Icon(
                        Icons.error,
                        size: 50,
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              },);
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop();
              });
            }

          },
          child: BlocBuilder<UserBloc,UserState>(
            builder:
            (context, state) {
              if(state is UserLoadingState){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
             if(state is UserLoadedState){
               List<UserModel> userList = state.users;
               return ListView.builder(
                 itemCount: userList.length,
                 itemBuilder: (context, index) {
                   return Padding(
                     padding: const EdgeInsets.all(10),
                     child: Card(
                       color: Colors.blue,
                       elevation: 4,
                       margin: const EdgeInsets.symmetric(vertical: 10),
                       child: ListTile(
                         title: Text(userList[index].firstName ?? ""),
                         subtitle: Text(userList[index].lastName ?? ""),
                         trailing: CircleAvatar(
                           backgroundImage: NetworkImage(userList[index].avatar ?? ""),
                         ),
                       ),
                     ),
                   );
                 },

               );
             }

            return Container(
              color: Colors.lightBlue,
            );
          }),
        ),
      ),
      );
  }
}

