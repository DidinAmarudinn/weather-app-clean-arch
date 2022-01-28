import 'dart:io';

import 'package:clean_arch_with_provider/common/api_constants.dart';
import 'package:clean_arch_with_provider/common/enum_state.dart';
import 'package:clean_arch_with_provider/domain/entities/weather.dart';
import 'package:clean_arch_with_provider/presentation/page/weather_page.dart';
import 'package:clean_arch_with_provider/presentation/provider/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'weather_page_test.mocks.dart';

@GenerateMocks([WeatherProvider])
void main() {
  late MockWeatherProvider provider;

  setUp(() {
     HttpOverrides.global = null;
    provider = MockWeatherProvider();
  });

  Widget _mackTestableWidget(Widget body) {
    return ChangeNotifierProvider<WeatherProvider>.value(
      value: provider,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tWeather = Weather(
    cityName: 'Jakarta',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );
  testWidgets(
    "text field should trigger state to change from noData to loading",
    (WidgetTester tester) async {
      //arrange
      when(provider.requestState).thenReturn(RequestState.noData);

      //act
      await tester.pumpWidget(_mackTestableWidget(const WeatherPage()));
      await tester.enterText(find.byType(TextField), 'Jakarta');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      //assert
      expect(find.byType(TextField), equals(findsOneWidget));
    },
  );
  testWidgets(
    'should show loading indicator when state is loading',
    (WidgetTester tester) async {
      // arrange
      when(provider.requestState).thenReturn(RequestState.loading);
      // act
      await tester.pumpWidget(_mackTestableWidget(const WeatherPage()));
      // assert
      expect(find.byType(CircularProgressIndicator), equals(findsOneWidget));
    },
  );

  testWidgets(
    'should show widget contain weather data when state is hasData',
    (WidgetTester tester) async {
      // arrange
      when(provider.requestState).thenReturn(RequestState.hasData);
      when(provider.weather).thenReturn(tWeather);
      // act
      await tester.pumpWidget(_mackTestableWidget(const WeatherPage()));
      await tester.runAsync(() async {
        final HttpClient client = HttpClient();
        await client.getUrl(Uri.parse(Urls.weatherIcon('02d')));
      });
      await tester.pumpAndSettle();
      // assert
      expect(find.byKey(const Key('weather_data')), equals(findsOneWidget));
    },
  );
}
