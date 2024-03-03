import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "chatscreen.dart";
import 'example.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  await dotenv.load();
  runApp(
    const MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  'assets/xlogo.png',
                  height: 85),
              const SizedBox(height: 25),
              const Text(
                'ChatX',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
              const SizedBox(height: 15),
              const Text(
                'made with ❤️ by PrtmBg',
                style: TextStyle(color: Color.fromARGB(255, 238, 238, 238)),
              ),
              const SizedBox(height: 90),
              const Icon(
                Icons.lightbulb_outline_rounded,
                size: 28,
                color: Color.fromARGB(255, 238, 238, 238),
              ),
              const Text(
                'Examples',
                style: TextStyle(color: Color.fromARGB(255, 238, 238, 238), fontSize: 20),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Column(
                  children: [
                    Example(
                      text: 'Explain quantum computing in simple terms',
                    ),
                    Example(
                      text:
                          "Got any creative ideas for 10 year old's boy birthday?",
                    ),
                    Example(
                      text: 'How to make a Cheese Sandwich?',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AppPage(initquery: "Hello!")));
                },
                
                icon: const Icon(Icons.send),
                label: const Text("Chat", style: TextStyle(fontSize: 20)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 238, 238, 238),
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 0, 197, 223),
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
