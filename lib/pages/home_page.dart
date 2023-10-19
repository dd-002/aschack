import 'dart:math';
import 'package:hive/hive.dart';
import 'package:qr_flutter/qr_flutter.dart';
import './qr_details.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                      await _qrList.delete(ref[1]);
                      refreshedItems();
                    }
                  },
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://media.istockphoto.com/id/1460853312/photo/abstract-connected-dots-and-lines-concept-of-ai-technology-motion-of-digital-data-flow.jpg?s=2048x2048&w=is&k=20&c=7yqKsEDy7_n6bG1jOFFFmYGYDa0MiSjJjYH_JvbxuWs=',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.fill),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                color: Colors.black26)
                          ]),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )),
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
