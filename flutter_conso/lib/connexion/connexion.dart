import 'package:flutter/material.dart';
import 'package:flutter_conso/first_page.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';


openMongoDB() async {
  final db = await Db.create('mongodb+srv://luludemartini:SofczhCLU9UthMzp@cluster0.36xxfbd.mongodb.net/my_conso?retryWrites=true&w=majority<');
  return db;
}

createObjectId(){
  return ObjectId();
}

checkUser(dynamic db, String email, String password) async {
  final userCollection = db.collection('users');

  try {
    await db.open();
    var hashedPassword = await userCollection.findOne(where.eq("email", email));
    if (hashedPassword != null) {
      return await FlutterBcrypt.verify(password: password, hash: hashedPassword['password']);
    }
    await db.close();
  } catch (e) {
    print('\n \n Erreur lors de la connexion : $e');
  }
}