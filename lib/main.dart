import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Quote> _quote;
  String quote = '';
  String author = '';
  bool favourite = false;
//API CALLING
  @override
  void initState() {
    super.initState();
    _quote = QuoteService.getRandomQuote();
  }

//Toogle Function for Favourite Button
  void toggleFavorite() {
    setState(() {
      favourite = !favourite;
    });
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
              //Future Builder
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
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //Refresh Button
                                InkWell(
                                  child: const Icon(Icons.refresh_rounded),
                                  onTap: () {
                                    setState(() {
                                      _quote = QuoteService.getRandomQuote();
                                    });
                                  },
                                ),
                                //Copy Button
                                InkWell(
                                  child: const Icon(Icons.copy),
                                  onTap: () {
                                    setState(() {
                                      Clipboard.setData(ClipboardData(
                                              text: snapshot.data!.text))
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Quote Copied Successfully!!!'),
                                          backgroundColor:
                                              Color.fromARGB(255, 8, 71, 10),
                                        ));
                                      });
                                    });
                                  },
                                ),
                                //Favourite Button
                                GestureDetector(
                                  onDoubleTap: toggleFavorite,
                                  child: Icon(
                                    favourite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: favourite ? Colors.red : null,
                                  ),
                                )
                              ],
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
