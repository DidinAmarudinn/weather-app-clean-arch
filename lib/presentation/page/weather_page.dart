import 'package:clean_arch_with_provider/common/api_constants.dart';
import 'package:clean_arch_with_provider/common/enum_state.dart';
import 'package:clean_arch_with_provider/presentation/provider/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Weather',
          style: TextStyle(color: Colors.orange),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              textAlign: TextAlign.center,
              decoration:const InputDecoration(
                hintText: 'Enter city name',
              ),
              onSubmitted: (query) {
                context.read<WeatherProvider>().fetchCurrentWeather(query);
              },
            ),
          const  SizedBox(height: 32.0),
            Consumer<WeatherProvider>(
              builder: (context, state, _) {
                if (state.requestState == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.requestState == RequestState.hasData) {
                  return Column(
                    key: const Key('weather_data'),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.weather?.cityName ?? "",
                            style: const TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                          Image(
                            image: NetworkImage(
                              Urls.weatherIcon(
                                state.weather?.iconCode ?? "",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '${state.weather?.main} | ${state.weather?.description}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Table(
                        defaultColumnWidth: const FixedColumnWidth(150.0),
                        border: TableBorder.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Temperature',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (state.weather?.temperature ?? 0.0).toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ), // Will be change later
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding:  EdgeInsets.all(8.0),
                              child: Text(
                                'Pressure',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (state.weather?.pressure ?? 0).toString(),
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold),
                              ),
                            ), // Will be change later
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding:  EdgeInsets.all(8.0),
                              child: Text(
                                'Humidity',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (state.weather?.humidity ?? 0).toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ), // Will be change later
                          ]),
                        ],
                      ),
                    ],
                  );
                } else if (state.requestState == RequestState.error) {
                  return const Center(
                    child: Text('Something went wrong!'),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
