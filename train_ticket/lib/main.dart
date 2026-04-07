import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'providers/ticket_booking_provider.dart';

void main() {
  runApp(const TrainTicketApp());
}

class TrainTicketApp extends StatelessWidget {
  const TrainTicketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Ticket booking state provider
        ChangeNotifierProvider(
          create: (_) => TicketBookingProvider()..initialize(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RailJet - Mumbai Local Trains',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
          useMaterial3: true,
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
