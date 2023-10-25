import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';


Future<void> openMongoDB() async {
  final db = Db('mongodb+srv://luludemartini:SofczhCLU9UthMzp@cluster0.36xxfbd.mongodb.net/?retryWrites=true&w=majority<');
  await db.open();
}