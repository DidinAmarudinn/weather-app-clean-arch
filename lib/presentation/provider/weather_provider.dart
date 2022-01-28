import 'package:clean_arch_with_provider/common/enum_state.dart';
import 'package:clean_arch_with_provider/domain/entities/weather.dart';
import 'package:clean_arch_with_provider/domain/usecase/get_current_weather.dart';
import 'package:flutter/material.dart';

class WeatherProvider extends ChangeNotifier {
  final GetCurrentWeather currentWeather;

  Weather? _weather;

  WeatherProvider({required this.currentWeather});
  Weather? get weather => _weather;

  RequestState _requestState = RequestState.noData;
  RequestState get requestState => _requestState;

  String _message = '';
  String get message => _message;

  Future<void> fetchCurrentWeather(String cityName) async {
    _requestState = RequestState.loading;
    notifyListeners();
    final result = await currentWeather.execute(cityName);
    result.fold((failure) {
      _requestState = RequestState.error;
      _message = failure.message;
      notifyListeners();
    }, (weather) {
      _weather = weather;
      _requestState = RequestState.hasData;
      notifyListeners();
    });
  }
}
