import 'package:clean_arch_with_provider/common/failure.dart';
import 'package:clean_arch_with_provider/domain/entities/weather.dart';
import 'package:clean_arch_with_provider/domain/repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentWeather {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  Future<Either<Failure, Weather>> execute(String cityName) {
    return repository.getCurrentWeather(cityName);
  }
}