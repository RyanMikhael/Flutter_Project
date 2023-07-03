import 'package:flutter/material.dart';
import 'package:mdb/db.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contacts.dart';

class ContactController{

  late Database database;

  Future<List<Map<String, Object?>>> getAllContacts() async {
    database = await SqliteDatabase().open();
    
    var list = await database.rawQuery('SELECT * FROM Contatos');
    
    return list;
  }

  insertContact(nome, email, id) async {
    
    database = await SqliteDatabase().open();
    await database.execute('INSERT INTO Contatos(nome,email, id_usuario) VALUES ("$nome", "$email", $id)');
  
  }

  Widget deleteContact(id, context){
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
            await database.delete('Contatos', where: 'id_contato = $id');
            Navigator.pop(context);
          },
          child: const Text('Excluir'))

      ],
    );
  }

  updateContact(nome, email,idContato)async {
    database = await SqliteDatabase().open();
    
    var contato = Contato(nome: nome, email: email);

    await database.update('Contatos', contato.toMap(), where: 'id_contato = $idContato');
    
    
  }
}