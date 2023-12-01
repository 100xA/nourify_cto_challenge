import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nourify_cto_challenge/cubit/garmin_state.dart';
import 'package:nourify_cto_challenge/data/garmin_data.dart';
import 'package:nourify_cto_challenge/data/repo/garmin_fb_repository.dart';

class GarminCubit extends Cubit<GarminState> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  DatabaseReference refStress = FirebaseDatabase.instance.ref("stress");
  String date = "2023-11-06";
  String accessToken = "01de6df4-996a-4110-b118-e23e6aec808d";
  DatabaseReference refSleep = FirebaseDatabase.instance.ref("sleep");
  DatabaseReference refMove = FirebaseDatabase.instance.ref("moveiq");
  DatabaseReference refHeart = FirebaseDatabase.instance.ref("hrvsummary");

  GarminCubit(super.initialState);
  Future<void> initializeApp() async {
    /// Starts the Process
    emit(GarminLoading());
    Map subMap = {};
    int realminVal = 0;

    await refSleep
        .orderByChild("sleeps/0/calendarDate")
        .equalTo(date)
        .limitToLast(100)
        .once()
        .then(
      (value) {
        Map map = value.snapshot.value as Map;
        map.forEach(
          (key, value) {
            /// used another accessToken, because original has no values for the date
            if (map[key]["sleeps"][0]["userAccessToken"] ==
                "2eb8a45d-5306-4436-bfea-db6783945bd4") {
              /// subMap to access all values in stressLevelMap map
              subMap = map[key]["sleeps"][0]["sleepLevelsMap"];

              subMap.forEach((key, value) {
                /// for each value a minValue gets assessed by comparing each value of th valueMap (realminVal)
                int minValue = value[0]["startTimeInSeconds"];
                for (int i = 0; i < value.length; i++) {
                  if (value[i]["startTimeInSeconds"] < minValue) {
                    minValue = value[i]["startTimeInSeconds"];
                  }
                }
                realminVal = minValue;
              });

              /// since realminVal is the start point of the data entry, durationInSeconds is used to assess the length of the sleep
              for (int i = realminVal;
                  i < realminVal + map[key]["sleeps"][0]["durationInSeconds"];
                  i++) {
                sleepData.add(
                  GarminData(DateTime.fromMillisecondsSinceEpoch(i * 1000), 0,
                      Type.sleep),
                );
              }
            }
          },
        );
      },
    );
    Map subMapStress = {};

    await refStress
        .orderByChild("stressDetails/0/calendarDate")
        .equalTo(date)
        .limitToLast(100)
        .once()
        .then((value) {
      Map map = value.snapshot.value as Map;
      map.forEach((key, value) {
        /// used another accessToken, because original has no values for the date
        if (map[key]["stressDetails"][0]["userAccessToken"] ==
            "2eb8a45d-5306-4436-bfea-db6783945bd4") {
          /// subMap to access all values in timeOffsetStressValues map
          subMapStress =
              map[key]["stressDetails"][0]["timeOffsetStressLevelValues"];

          /// timeOffset to set first dataEntry
          int timeOffset = map[key]["stressDetails"][0]["startTimeInSeconds"];

          Map newMap = {};

          /// checks whether the key has a value, and removes it if absent
          subMapStress.forEach((key, value) {
            newMap.putIfAbsent(int.parse(key), () => value);
          });

          /// sorts the Map by comparing its keys, starting from lowest

          var sortedByKeyMap = Map.fromEntries(newMap.entries.toList()
            ..sort((e1, e2) => e1.key.compareTo(e2.key)));

          sortedByKeyMap.forEach((key, value) {
            /// gets realtime by adding the time of the global first entry (timeoffset) and adds the relative key
            int realTime = (timeOffset + key).toInt();

            /// if the value is below zero (stressLevelValue) value gets the value 0 (for convenience)
            if (value < 0) {
              value = 0;
            }

            /// for each realTime key, a value gets added to the list
            stressData.add(
              GarminData(DateTime.fromMillisecondsSinceEpoch(realTime * 1000),
                  value, Type.stress),
            );
          });
        }
      });
    });

    Map subMapHeart = {};
    await refHeart
        .orderByChild("hrv/0/calendarDate")
        .equalTo(date)
        .limitToLast(100)
        .once()
        .then((value) {
      Map map = value.snapshot.value as Map;
      map.forEach((key, value) async {
        /// checks if accessToken has data
        if (map[key]["hrv"][0]["userAccessToken"] == accessToken) {
          /// subMapHeart gets all values in hrvValues
          subMapHeart = map[key]["hrv"][0]["hrvValues"];

          /// timeOffset to set first dataEntry
          int timeOffset = map[key]["hrv"][0]["startTimeInSeconds"];

          Map newMap = {};

          /// checks whether the key has a value, and removes it if absent
          subMapHeart.forEach((key, value) {
            newMap.putIfAbsent(int.parse(key), () => value);
          });

          /// sorts the Map by comparing its keys, starting from lowest
          var sortedByKeyMap = Map.fromEntries(newMap.entries.toList()
            ..sort((e1, e2) => e1.key.compareTo(e2.key)));

          sortedByKeyMap.forEach((key, value) {
            double convertTimeFrame = double.parse(key.toString());

            /// gets realtime by adding the time of the global first entry (timeoffset) and adds the relative convertedTimeFrame
            int realTime = (timeOffset + convertTimeFrame).toInt();

            /// for each realTime key, a value gets added to the list
            heartData.add(GarminData(
                DateTime.fromMillisecondsSinceEpoch(realTime * 1000),
                value.toInt(),
                Type.heart));
          });
        }
      });
    });

    await refMove
        .orderByChild("moveIQActivities/0/calendarDate")
        .equalTo(date)
        .limitToFirst(100)
        .once()
        .then((value) {
      Map map = value.snapshot.value as Map;
      map.forEach((key, value) {
        /// used another accessToken, because original has no values for the date
        if (map[key]["moveIQActivities"][0]["userAccessToken"] ==
            "43d12711-f0e1-4915-84ce-23c3e6335b19") {
          /// sort with acitvityTyp
          if (map[key]["moveIQActivities"][0]["activityType"] == "walking") {
            /// get timeOffset for first data entry in session
            int timeOffset =
                map[key]["moveIQActivities"][0]["startTimeInSeconds"];

            /// get duration in Seconds to iterate through
            int durationInSeconds =
                map[key]["moveIQActivities"][0]["durationInSeconds"];
            for (int i = timeOffset; i < timeOffset + durationInSeconds; i++) {
              moveData.add(GarminData(
                  DateTime.fromMillisecondsSinceEpoch(i * 1000), 0, Type.move));
            }
          }
        }
      });
    });
    await refMove
        .orderByChild("moveIQActivities/1/calendarDate")
        .equalTo(date)
        .limitToFirst(100)
        .once()
        .then((value) {
      Map map = value.snapshot.value as Map;
      map.forEach((key, value) {
        /// used another accessToken, because original has no values for the date
        if (map[key]["moveIQActivities"][1]["userAccessToken"] ==
            "43d12711-f0e1-4915-84ce-23c3e6335b19") {
          /// sort with acitvityType
          if (map[key]["moveIQActivities"][1]["activityType"] == "walking") {
            /// get timeOffset for first data entry in session
            int timeOffset =
                map[key]["moveIQActivities"][1]["startTimeInSeconds"];

            /// get duration in Seconds to iterate through
            int durationInSeconds =
                map[key]["moveIQActivities"][1]["durationInSeconds"];
            for (int i = timeOffset; i < timeOffset + durationInSeconds; i++) {
              moveData.add(GarminData(
                  DateTime.fromMillisecondsSinceEpoch(i * 1000), 0, Type.move));
            }
          }
        }
      });
    });

    await refMove
        .orderByChild("moveIQActivities/2/calendarDate")
        .equalTo(date)
        .limitToFirst(100)
        .once()
        .then((value) {
      Map map = value.snapshot.value as Map;
      map.forEach((key, value) {
        /// used another accessToken, because original has no values for the date
        if (map[key]["moveIQActivities"][2]["userAccessToken"] ==
            "43d12711-f0e1-4915-84ce-23c3e6335b19") {
          /// sort with acitvityType
          if (map[key]["moveIQActivities"][2]["activityType"] == "walking") {
            /// get timeOffset for first data entry in session
            int timeOffset =
                map[key]["moveIQActivities"][2]["startTimeInSeconds"];

            /// get duration in Seconds to iterate through
            int durationInSeconds =
                map[key]["moveIQActivities"][2]["durationInSeconds"];
            for (int i = timeOffset; i < timeOffset + durationInSeconds; i++) {
              moveData.add(GarminData(
                  DateTime.fromMillisecondsSinceEpoch(i * 1000), 0, Type.move));
            }
          }
        }
      });
    });

    /// emit a Success State for the ChartApp with all GarminData

    emit(GarminSuccess(stressData, sleepData, heartData, moveData));
  }
}
