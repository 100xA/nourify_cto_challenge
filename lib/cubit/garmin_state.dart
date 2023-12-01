import 'package:equatable/equatable.dart';
import 'package:nourify_cto_challenge/data/garmin_data.dart';

abstract class GarminState extends Equatable {
  const GarminState();
}

class GarminInitial extends GarminState {
  @override
  List<Object?> get props => [];
}

class GarminLoading extends GarminState {
  @override
  List<Object?> get props => [];
}

class GarminSuccess extends GarminState {
  final List<GarminData> info;
  final List<GarminData> info2;
  final List<GarminData> info3;
  final List<GarminData> info4;

  const GarminSuccess(this.info, this.info2, this.info3, this.info4);

  @override
  List<Object?> get props => [info, info2, info3, info4];
}
