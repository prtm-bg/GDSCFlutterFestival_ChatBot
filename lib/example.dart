import 'package:flutter/material.dart';
import 'chatscreen.dart';

class Example extends StatelessWidget {
  const Example({super.key, required this.text});

  final String text;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8,),
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => AppPage(initquery: text)));
        },
        
        style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 0),
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 98, 0, 255),
                      width: 1,
                    ),
                  ),
        
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
