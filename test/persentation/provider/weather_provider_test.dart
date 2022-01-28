import 'package:clean_arch_with_provider/common/enum_state.dart';
import 'package:clean_arch_with_provider/common/failure.dart';
import 'package:clean_arch_with_provider/domain/entities/weather.dart';
import 'package:clean_arch_with_provider/domain/usecase/get_current_weather.dart';
import 'package:clean_arch_with_provider/presentation/provider/weather_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'weather_provider_test.mocks.dart';

@GenerateMocks([GetCurrentWeather])
void main() {
  late WeatherProvider provider;
  late MockGetCurrentWeather mockGetCurrentWeather;
  late int listenerCallCount = 0;

  setUp(() {
    listenerCallCount = 0;
    mockGetCurrentWeather = MockGetCurrentWeather();
    provider = WeatherProvider(currentWeather: mockGetCurrentWeather)
      ..addListener(() {
        listenerCallCount +=1;
      });
  });
  const tWeather = Weather(
    cityName: 'Jakarta',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );
  

  const tCityName = "Jakarta";

  void _arrangeUseCase() {
    when(mockGetCurrentWeather.execute(tCityName))
        .thenAnswer((_) async => const Right(tWeather));
  }

  test(
    'initial request state should be noData ',
    () async {
      // assert
      expect(provider.requestState, RequestState.noData);
    },
  );

  test(
    'should get data from the usecase',
    () async {
      // arrange
      _arrangeUseCase();
      // act
      await provider.fetchCurrentWeather(tCityName);

      // assert
      verify(mockGetCurrentWeather.execute(tCityName));
    },
  );
  test(
    'should change requestState to loading when useCase is called',
    () async {
      // arrange
      _arrangeUseCase();
      // act
      provider.fetchCurrentWeather(tCityName);
      // assert
      expect(provider.requestState, RequestState.loading);
    },
  );
  test(
    'should change requestState to hasData when data is gotten successfully',
    () async {
      // arrange
      _arrangeUseCase();
      // act
      await provider.fetchCurrentWeather(tCityName);
      // assert
      expect(provider.requestState, RequestState.hasData);
      expect(listenerCallCount, 2);
    },
  );
  test(
    'should change requestState to error when request unsuccessfull',
    () async {
      // arrange
      when(mockGetCurrentWeather.execute(tCityName))
          .thenAnswer((realInvocation) async => const Left(ServerFailure('')));
      // act
      await provider.fetchCurrentWeather(tCityName);
      // assert
      expect(provider.requestState, RequestState.error);
    },
  );
  test(
    'should change weather to like tWeather when request is successfull',
    () async {
      // arrange
      _arrangeUseCase();
      // act
      await provider.fetchCurrentWeather(tCityName);
      // assert
      expect(provider.weather, tWeather);
    },
  );
}
