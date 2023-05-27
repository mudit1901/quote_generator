import 'package:flutter/material.dart';
import 'package:quotes/quote.dart';
import 'package:quotes/service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Quote> _quote;

  @override
  void initState() {
    super.initState();
    _quote = QuoteService.getRandomQuote();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: const Color.fromARGB(255, 247, 213, 111),
            title: const Text(
              'Random Quote Generator',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 240, 230, 201),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Center(
                    child: Text(
                  'Quote of the Day',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                )),
              ),
              FutureBuilder(
                future: _quote,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: const EdgeInsets.all(10),
                        semanticContainer: true,
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              snapshot.data!.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 200.0),
                              child: Text(
                                '- ${snapshot.data!.author}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              child: Icon(Icons.refresh_rounded),
                              onTap: () {
                                setState(() {
                                  _quote = QuoteService.getRandomQuote();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Failed to load quote');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          )),
    );
  }
}
