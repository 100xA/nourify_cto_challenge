import 'package:get_it/get_it.dart';
import 'package:nourify_cto_challenge/cubit/garmin_cubit.dart';
import 'package:nourify_cto_challenge/cubit/garmin_state.dart';

final GetIt app = GetIt.instance;

/// registers all available Cubits as Singletons
void setupServices() {
  app.registerLazySingleton<GarminCubit>(() => GarminCubit(GarminLoading()));
}
