import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Browser',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController _webViewController;
  final TextEditingController _teController = TextEditingController();
  bool showLoading = false;
  void updateLoading(bool ls) {
    setState(() {
      showLoading = ls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Flexible(
                          flex: 2,
                          child: Text(
                            "https://",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                      Flexible(
                        flex: 4,
                        child: TextField(
                          autocorrect: false,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.white,
                                    width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.white,
                                    width: 2),
                              )),
                          controller: _teController,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                            child: GestureDetector(
                                onLongPress: () {
                                  updateLoading(true);
                                  _webViewController
                                      .loadUrl('https://www.duckduckgo.com')
                                      .then((onValue) {})
                                      .catchError((e) {
                                    updateLoading(false);
                                  });
                                },
                                child: IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      String finalURL = _teController.text;
                                      if (!finalURL.startsWith("https://")) {
                                        finalURL = "https://" + finalURL;
                                      }
                                      updateLoading(true);
                                      _webViewController
                                          .loadUrl(finalURL)
                                          .then((onValue) {})
                                          .catchError((e) {
                                        updateLoading(false);
                                      });
                                    }))),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
                flex: 9,
                child: Stack(
                  children: <Widget>[
                    WebView(
                      initialUrl: 'https://www.google.com',
                      onPageFinished: (data) {
                        updateLoading(false);
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (webViewController) {
                        _webViewController = webViewController;
                      },
                    ),
                    (showLoading)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Center()
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
