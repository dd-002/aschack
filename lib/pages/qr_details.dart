import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../components/delqr_button.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const DetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _qrList = Hive.box('qrList');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.alphaBlend(Colors.black, Colors.blue),
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.black54),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              widget.data['eventID'],
              style: const TextStyle(
                  color: Color.fromARGB(221, 255, 255, 255),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Hero(
                    tag: widget.data['key'].toString(),
                    child: Center(
                      child: QrImageView(
                        data: widget.data['eventID'],
                        size: 200,
                        embeddedImageStyle:
                            const QrEmbeddedImageStyle(size: Size(100, 100)),
                        backgroundColor: Color.fromARGB(255, 62, 220, 62),
                      ),
                    )),
              )),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: DelButton(
                onTap: () async {
                  Navigator.pop(context, ['del', widget.data['key']]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
