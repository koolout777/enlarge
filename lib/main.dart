import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Enlarger',
      home: TextEnlarger(),
    );
  }
}

class TextEnlarger extends StatefulWidget {
  @override
  _TextEnlargerState createState() => _TextEnlargerState();
}

class _TextEnlargerState extends State<TextEnlarger> {
  final _formKey = GlobalKey<FormState>();
  String inputText = '';
  bool isTextEnlarged = false;

  // Default colors
  Color backgroundColor = Colors.white;
  Color fontColor = Colors.black;

  // Color picker dialog for background color
  void _pickBackgroundColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 16,
          child: SizedBox(
            width: 300,
            height: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Pick Background Color',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: backgroundColor,
                      onColorChanged: (color) {
                        setState(() {
                          backgroundColor = color;
                        });
                      },
                      showLabel: false,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Color picker dialog for font color
  void _pickFontColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 16,
          child: SizedBox(
            width: 300,
            height: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Pick Font Color',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: fontColor,
                      onColorChanged: (color) {
                        setState(() {
                          fontColor = color;
                        });
                      },
                      showLabel: false,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _goBack() {
    // Reset to portrait orientation when going back
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      isTextEnlarged = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isTextEnlarged
            ? LayoutBuilder(
                builder: (context, constraints) {
                  // Available width minus 40px for padding
                  double availableWidth = constraints.maxWidth - 40;

                  // Available height minus 40px for padding
                  double availableHeight = constraints.maxHeight - 40;

                  // Calculate font size dynamically based on available width and height
                  double fontSize = availableWidth / inputText.length;

                  // Apply a maximum font size based on available space
                  double maxFontSize =
                      availableHeight / 2; // Limit font size based on height
                  fontSize = fontSize < maxFontSize ? fontSize : maxFontSize;

                  // Minimum font size
                  fontSize = fontSize < 40
                      ? 40
                      : fontSize; // Set a lower limit for font size

                  return Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: constraints.maxHeight,
                        alignment: Alignment.center,
                        color: backgroundColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Enlarged Text
                            Text(
                              inputText,
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: fontColor,
                                  letterSpacing: 13.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 20,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back,
                              size: 22, color: Colors.black),
                          onPressed: _goBack,
                        ),
                      ),
                    ],
                  );
                },
              )
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    // Chat-style Input Field
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            inputText = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Type something...',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Input should not be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    // Enlarge Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Change to landscape orientation
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight,
                          ]);
                          setState(() {
                            isTextEnlarged = true;
                          });
                        }
                      },
                      child: Text('Enlarge'),
                    ),
                  ],
                ),
              ),
      ),
      // Conditionally show/hide the FloatingActionButton (Settings Button)
      floatingActionButton: isTextEnlarged
          ? null // Hide the button when text is enlarged
          : FloatingActionButton(
              onPressed: () {
                // Open settings menu as a modal dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 16,
                      child: SizedBox(
                        width: 400,
                        height: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'Settings',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _pickBackgroundColor,
                              child: Text('Pick Background Color'),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _pickFontColor,
                              child: Text('Pick Font Color'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.settings),
              backgroundColor: Colors.white,
            ),
    );
  }
}
