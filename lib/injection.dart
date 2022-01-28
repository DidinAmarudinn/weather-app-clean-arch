import 'package:clean_arch_with_provider/data/datasources/remote_datasource.dart';
import 'package:clean_arch_with_provider/data/repositories/weather_repository_impl.dart';
import 'package:clean_arch_with_provider/domain/repositories/weather_repository.dart';
import 'package:clean_arch_with_provider/domain/usecase/get_current_weather.dart';
import 'package:clean_arch_with_provider/presentation/provider/weather_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
final locator = GetIt.instance;

void init() {
  //provider
  locator.registerFactory(() => WeatherProvider(currentWeather: locator()));

  //usecase
  locator.registerLazySingleton(() => GetCurrentWeather(locator()));

  //remotedatasource
  locator.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(client: locator()));
  //repository
  locator.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(remoteDataSource: locator()));
  
  //external
  locator.registerLazySingleton(() => http.Client());
}
