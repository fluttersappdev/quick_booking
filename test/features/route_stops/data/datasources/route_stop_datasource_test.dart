import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:quick_booking/provider/route_stop_provider.dart';
import '../../../../mocks/mock_api_client.mocks.dart';

void main() {
  late MockClient mockHttpClient;
  late MockApiClient mockApiClient;

  setUp(() {
    mockHttpClient = MockClient();
    mockApiClient = MockApiClient();
    when(mockApiClient.client).thenReturn(mockHttpClient);
  });

  group('BookingNotifier', () {
    test('successful booking', () async {
      // Arrange
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"success": true}', 200));

      // Act
      final container = ProviderContainer(overrides: [
        apiClientProvider.overrideWithValue(mockApiClient),
      ]);
      await container.read(bookingProvider.notifier).bookRide('1');

      // Assert
      expect(container.read(bookingProvider), isA<BookingSuccess>());
    });

    test('failed booking', () async {
      // Arrange
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"error": "Failed"}', 400));

      // Act
      final container = ProviderContainer(overrides: [
        apiClientProvider.overrideWithValue(mockApiClient),
      ]);
      await container.read(bookingProvider.notifier).bookRide('1');

      // Assert
      expect(container.read(bookingProvider), isA<BookingError>());
    });

    test('50% failure rate simulation', () async {
      // Arrange
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async {
        if (DateTime.now().millisecond % 2 == 0) {
          return http.Response('{"error": "Random failure"}', 400);
        }
        return http.Response('{"success": true}', 200);
      });

      // Act & Assert
      final container = ProviderContainer(overrides: [
        apiClientProvider.overrideWithValue(mockApiClient),
      ]);
      await container.read(bookingProvider.notifier).bookRide('1');

      final state = container.read(bookingProvider);
      expect(state is BookingSuccess || state is BookingError, isTrue);
    });
  });
}