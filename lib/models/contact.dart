import 'package:hive/hive.dart';

part 'contact.g.dart';
@HiveType(typeId: 0)
class Contact extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(2)
  late String number;
}

@HiveType(typeId: 1)
class Transaction extends HiveObject{
  @HiveField(0)
  late String name;
@HiveField(1)
  late String amount;

}
