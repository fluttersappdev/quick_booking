import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:quick_booking/networkcall/api_client.dart';

@GenerateMocks([http.Client])
@GenerateNiceMocks([MockSpec<ApiClient>()])
import 'mock_api_client.mocks.dart';
