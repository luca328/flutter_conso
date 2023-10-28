import 'package:mongo_dart/mongo_dart.dart';


openMongoDB() async {
  final db = Db('mongodb+srv://luludemartini:SofczhCLU9UthMzp@cluster0.36xxfbd.mongodb.net/?retryWrites=true&w=majority<');
  return db;
}