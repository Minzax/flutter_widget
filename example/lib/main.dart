import 'package:flutter/material.dart';
import 'package:flutter_widget/widgets/mop_text_field.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// 输入框值
  String inputValue = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(50),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black
                )
              ),
              child: MopTextField(
                value: inputValue,
                onChanged: (value) {
                  setState(() {
                    inputValue = value;
                  });
                },
              ),
            ),

            Container(
              margin: EdgeInsets.all(50),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black
                )
              ),
              child: MopTextField(
                value: inputValue,
                onChanged: (value) {
                  setState(() {
                    inputValue = value;
                  });
                },
              ),
            )
          ],
        ),
      ),
      supportedLocales: [
        const Locale('en', 'US')
      ]
    );
  }
}
