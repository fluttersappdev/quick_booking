import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../provider/route_stop_provider.dart';
import '../widgets/route_stop_card.dart';
import 'booking_confirmation_screen.dart';
import 'booking_error_screen.dart';
class RouteStopsScreen extends ConsumerWidget {
  const RouteStopsScreen({super.key});

  static const String routeName = '/routeStops';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeStopsAsync = ref.watch(routeStopsProvider);
    final bookingState = ref.watch(bookingProvider);

    // Handle booking state changes
    if (bookingState is BookingSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigate to confirmation screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmationScreen(
              stopId: bookingState.stopId,
              onComplete: () {
                ref.read(bookingProvider.notifier).reset();
                Navigator.pop(context);
              },
            ),
          ),
        );
      });
    } else if (bookingState is BookingError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Show error screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingErrorScreen(
              errorMessage: bookingState.message,
              onRetry: () {
                ref.read(bookingProvider.notifier).reset();
                Navigator.pop(context);
              },
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Stops'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(routeStopsProvider),
          ),
        ],
      ),
      body: routeStopsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load route stops',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(routeStopsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (either) => either.fold(
              (failure) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  failure.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(routeStopsProvider),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
              (routeStops) => RefreshIndicator(
            onRefresh: () => ref.refresh(routeStopsProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: routeStops.length,
              itemBuilder: (context, index) {
                final stop = routeStops[index];
                return RouteStopCard(
                  stop: stop,
                  onBook: () {
                    ref.read(bookingProvider.notifier).bookRide(stop.id);
                  },
                  isLoading: bookingState is BookingLoading &&
                      (bookingState as BookingLoading).stopId == stop.id,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}