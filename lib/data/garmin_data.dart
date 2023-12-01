enum Type { heart, move, sleep, stress }

class GarminData {
  GarminData(this.time, this.sales, this.type);

  final DateTime time;
  final int sales;

  final Type type;
}
