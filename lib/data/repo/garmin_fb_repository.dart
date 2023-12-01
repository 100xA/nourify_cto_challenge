import 'package:firebase_database/firebase_database.dart';
import 'package:nourify_cto_challenge/data/garmin_data.dart';

List<GarminData> stressData = [];
List<GarminData> sleepData = [];
List<GarminData> heartData = [];
List<GarminData> moveData = [];

class GarminFBRepository {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  DatabaseReference refStress = FirebaseDatabase.instance.ref("stress");
  String date = "2023-11-06";
  String accessToken = "01de6df4-996a-4110-b118-e23e6aec808d";
  DatabaseReference refSleep = FirebaseDatabase.instance.ref("sleep");
  DatabaseReference refMove = FirebaseDatabase.instance.ref("moveiq");
  DatabaseReference refHeart = FirebaseDatabase.instance.ref("hrvsummary");
}
