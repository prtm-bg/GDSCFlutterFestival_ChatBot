import 'dart:io';
import "package:image_picker/image_picker.dart";
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AppPage extends StatefulWidget {
  final initquery;
  const AppPage({Key? key, @required this.initquery}) : super(key: key);
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  String? _apikey = dotenv.env['API_KEY'];
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _messages = [];
  final List<int> _isquery = [];
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _sendMessage(widget.initquery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey.shade200),
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Chat',
                style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: 'X',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 187, 187),
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.black,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    if (_isquery[index] == 1) {
                      // Query message
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue.shade800,
                                Colors.blue.shade500,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _messages[index],
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 15),
                          ),
                        ),
                      );
                    }
                    if (_isquery[index] == 2) {
                      // Query message
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue.shade800,
                                Colors.blue.shade500,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.file(File(_messages[index])),
                        ),
                      );
                    } else {
                      // Response message
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.shade800,
                                Colors.grey.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _messages[index],
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 15),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.black),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 5, left: 5),
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything',
                      hintStyle:
                          const TextStyle(color: Color.fromARGB(255, 238, 238, 238)),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 238, 238, 238)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 238, 238, 238)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Handle icon click here
                          getImageFromGallery();
                        },
                        icon: const Icon(Icons.image, color: Color.fromARGB(255, 194, 194, 194)),
                      ),
                    ),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 238, 238, 238)),
                    onSubmitted: (value) {
                      if (_selectedImage != null) {
                        _sendImage(_selectedImage!.path, value);
                      } else if (value.isNotEmpty) {
                        _sendMessage(value);
                      }
                    },
                  ),
                ),
              ),
              FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 238, 255, 0),
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_downward),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage(String message) async {
    setState(() {
      _messages.add(message);
      _isquery.add(1);
      _textEditingController.clear();
    });
    final model = GenerativeModel(
        model: 'gemini-pro', apiKey: "$_apikey");
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      _messages.add(response.text!);
      _isquery.add(0);
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _sendImage(String path, String message) async {
    setState(() {
      _messages.add(message);
      _isquery.add(1);
      _messages.add(path);
      _isquery.add(2);
      _textEditingController.clear();
    });
    final model = GenerativeModel(
        model: 'gemini-pro-vision',
        apiKey: "$_apikey");
    final (firstImage, secondImage) =
        await (File(path).readAsBytes(), File(path).readAsBytes()).wait;
    final prompt = TextPart(message);
    final imageParts = [
      DataPart('image/jpeg', firstImage),
      DataPart('image/jpeg', secondImage),
    ];
    final response = await model.generateContent([
      Content.multi([prompt, ...imageParts])
    ]);

    setState(() {
      _selectedImage = null;
      _messages.add(response.text!);
      _isquery.add(0);
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Future getImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;

    setState(() {
      _selectedImage = File(returnedImage.path);
    });
    final snackBar = SnackBar(
      content: const Text(
          'Image selected! Use TextField to send Query with Image context.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          undoSelection();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void undoSelection() {
    setState(() {
      _selectedImage = null;
    });
  }
}
