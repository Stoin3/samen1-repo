import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Website Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Change to SplashScreen widget
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToMainScreen(); // Navigate to the main screen after a delay
  }

  void navigateToMainScreen() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WebsiteViewer()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/splash.png'), // Replace with your splash screen image path
      ),
    );
  }
}

class WebsiteViewer extends StatefulWidget {
  @override
  _WebsiteViewerState createState() => _WebsiteViewerState();
}

class _WebsiteViewerState extends State<WebsiteViewer> {
  final String url = 'https://samen1.nl';
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) => true,
          child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _scrollController
                  .addListener(() => _scrollController.jumpTo(0));
            },
            gestureNavigationEnabled: true,
            onPageFinished: (_) {
              _scrollController.jumpTo(0);
            },
            navigationDelegate: (NavigationRequest request) {
              if (!request.url.startsWith(url)) {
                // Handle external links here
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        ),
      ),
    );
  }
}
