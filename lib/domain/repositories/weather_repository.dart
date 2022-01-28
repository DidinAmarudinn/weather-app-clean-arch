import 'package:clean_arch_with_provider/common/failure.dart';
import 'package:clean_arch_with_provider/domain/entities/weather.dart';
import 'package:dartz/dartz.dart';

abstract class WeatherRepository{
  Future<Either<Failure,Weather>> getCurrentWeather(String cityName);
}