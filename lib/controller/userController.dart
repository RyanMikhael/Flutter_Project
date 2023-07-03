import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mdb/db.dart';
import 'package:mdb/models/usuario.dart';

class UserController{

  late Database database;

  Future<List<Map<String, Object?>>> getAllUsers() async {
    database = await SqliteDatabase().open();
    
    var list = await database.rawQuery('SELECT * FROM Usuario');
    
    return list;
  }

  insertUser(nome, email,password,lat,long) async {
    // var user = new Usuario(nomeUsuario: nome, email: email, password: password, latitude: lat, longitude: long);
    database = await SqliteDatabase().open();
    await database.execute('INSERT INTO Usuario(nome,email,password,latitude,longitude) VALUES ("$nome", "$email", "$password", $lat, $long)');
  
  }

  Widget deleteUser(email, context){
    return AlertDialog(
      title: const Text('Excluir contato'),
      content: const Text('Você realmente deseja excluir esse contato?'),
      actions: [
        TextButton(
          onPressed: (){
          Navigator.pop(context, 'Cancelar');
          }, 
          child: const Text('Cancelar')),
        TextButton(
          onPressed: () async{
            database = await SqliteDatabase().open();
            await database.delete('Usuario', where: 'email = "$email"');
            Navigator.pop(context);
          },
          child: const Text('Excluir'))

      ],
    );
  }

  updateUser(email, nome, password, lat, long)async {
    database = await SqliteDatabase().open();
    
    var usuario = Usuario(nomeUsuario: nome, email: email, password: password, latitude: lat, longitude: long);

    await database.update('Usuario', usuario.toMap(), where: 'email = "$email"');
    
  }

  updatePassword(email, password) async {
    Database database = await SqliteDatabase().open();
    await database.execute('UPDATE Usuario SET password = "$password" WHERE email = "$email"');
  }

  verifyUser(email, password) async {
    bool pass = false;
    // , isValidEmail = false, isValidPassword = false;
    var user,userEmail;

    database = await SqliteDatabase().open();
    var emails = await database.rawQuery('SELECT email FROM Usuario');
    
    if(emails.isNotEmpty){
      for(var i = 0; i < emails.length; i++){
        if(email == emails[i]['email']){
          // isValidEmail = true;
          userEmail = emails[i]['email'];
        }
      }
    }
    
    if(userEmail!= null){

      user = await database.rawQuery('SELECT * FROM Usuario WHERE email = "$userEmail"');
      if(user.length > 0){

        if(user[0]['password'] == password){
          // isValidPassword = true;
          pass = true;
        }
      }
    }
    
    
    return pass;
  }

  FutureOr<bool> verifyAccount(nome, email) async {
    bool accountExist = true;
    database = await SqliteDatabase().open();

    final accountName = await database.query('Usuario', columns: ['nome'], where: 'nome = "$nome"');
    final accountEmail = await database.query('Usuario', columns: ['email'], where: 'email = "$email"');

    if(accountName.isEmpty && accountEmail.isEmpty){
      accountExist = false;
    }

    return accountExist;

  }

  Future<Object?> getUserName(email) async {
    database = await SqliteDatabase().open();
    final user = await database.query('Usuario', columns: ['nome'], where: 'email = "$email"');
    final userName = user[0]['nome'];
    return userName;
  }
}

