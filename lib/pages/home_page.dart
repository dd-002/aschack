import 'dart:math';
import 'package:hive/hive.dart';
import 'package:qr_flutter/qr_flutter.dart';
import './qr_details.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  final int _currentPage = 0;

  final _qrList = Hive.box('qrList');
  List<Map<String, dynamic>> _items = [];

  void refreshedItems() {
    final data = _qrList.keys.map((key) {
      final item = _qrList.get(key);
      return {
        'key': key,
        'uID': item['uID'],
        'eventID': item['eventID'],
        'eventName': item['eventName']
      };
    }).toList();
    print([_qrList, 'refresh ran']);
    setState(() {
      _items = data.toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: 0.8);
    refreshedItems();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Center(
                    child: Text("Available QRs",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 30)),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 0.67,
                  child: PageView.builder(
                      itemCount: _items.length,
                      physics: const ClampingScrollPhysics(),
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        return carouselView(index);
                      }),
                )
              ],
            ),
          ),
        ));
  }

  Widget carouselView(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index.toDouble() - (_pageController.page ?? 0);
          value = (value * 0.0).clamp(-1, 1);
        }
        return Transform.rotate(
          angle: pi * value,
          child: carouselCard(_items[index]),
        );
      },
    );
  }

  Widget carouselCard(Map<String, dynamic> data) {
    print(data);
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Hero(
              tag: data['key'].toString(),
              child: GestureDetector(
                onTap: () async {
                  List<dynamic> ref = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsScreen(data: data)));
                  if (ref[0] == 'del') {
                    print(ref[1]);
                    await _qrList.delete(ref[1]);
                    refreshedItems();
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 4,
                              color: Colors.black26)
                        ]),
                    child: Center(
                      child: QrImageView(
                        data: data['eventID'],
                        size: 200,
                        embeddedImageStyle:
                            const QrEmbeddedImageStyle(size: Size(100, 100)),
                        backgroundColor: Color.fromARGB(255, 62, 220, 62),
                      ),
                    )),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            data['eventName'].toString(),
            style: const TextStyle(
                color: Colors.black45,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
