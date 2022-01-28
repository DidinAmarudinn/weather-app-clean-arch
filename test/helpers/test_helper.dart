import 'package:clean_arch_with_provider/data/datasources/remote_datasource.dart';
import 'package:clean_arch_with_provider/domain/repositories/weather_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
@GenerateMocks(
  [
    WeatherRepository,
    RemoteDataSource,
  ],
  customMocks: [MockSpec<http.Client>(as:#MockHttpClient)]
)

void main(){

}