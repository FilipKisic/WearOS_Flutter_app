import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wear/wear.dart';
import 'package:wearable_rotary/wearable_rotary.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      child: const MyHomePage(),
      builder: (context, mode, child) {
        final isActive = mode == WearMode.active;
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            visualDensity: VisualDensity.compact,
            useMaterial3: true,
            colorScheme: isActive
                ? const ColorScheme.dark(
                    primary: Colors.white60,
                    background: Color(0xFF200726),
                    onBackground: Colors.white10,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.dark(
                    primary: Colors.white24,
                    onBackground: Colors.white10,
                    onSurface: Colors.white10,
                  ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isActive ? const Color(0xFF622773) : Colors.white10,
              ),
            ),
          ),
          home: child,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final StreamSubscription<RotaryEvent> rotarySubscription;
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  void _decrementCounter() => setState(() => --_counter);

  @override
  void initState() {
    super.initState();
    rotarySubscription = rotaryEvents.listen(handleRotaryEvent);
  }

  void handleRotaryEvent(RotaryEvent event) {
    if (event.direction == RotaryDirection.clockwise) {
      _incrementCounter();
    } else {
      _decrementCounter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Icon(Icons.add),
            ),
            Text(
              _counter.toString(),
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: _decrementCounter,
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    rotarySubscription.cancel();
    super.dispose();
  }
}
