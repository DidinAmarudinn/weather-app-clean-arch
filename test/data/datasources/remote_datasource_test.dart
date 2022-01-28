import 'dart:convert';

import 'package:clean_arch_with_provider/common/api_constants.dart';
import 'package:clean_arch_with_provider/data/datasources/remote_datasource.dart';
import 'package:clean_arch_with_provider/common/exception.dart';
import 'package:clean_arch_with_provider/data/models/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late RemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = RemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get current weather', () {
    String tCityName = 'Jakarta';
    final tWeatherModel = WeatherModel.fromJson(
      jsonDecode(
        readJson('helpers/dummy_data/dummy_weather_response.json'),
      ),
    );
    test(
      'should return weather model when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient
                .get(Uri.parse(Urls.currentWeatherByName(tCityName))))
            .thenAnswer((realInvocation) async {
          return http.Response(
              readJson("helpers/dummy_data/dummy_weather_response.json"),
              200);
        });
        // act
        final result = await dataSource.getCurrentWeather(tCityName);
        // assert
        expect(result, equals(tWeatherModel));
      },
    );

    test(
      'should throm a server exception when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient
                .get(Uri.parse(Urls.currentWeatherByName(tCityName))))
            .thenAnswer(
                (realInvocation) async => http.Response('Not Found', 404));
        // act
        final call =  dataSource.getCurrentWeather(tCityName);
        // assert
        expect(()=>call, throwsA(isA<ServerException>()));
      },
    );
  });
}
