import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:pass_admin/pages/upload/bank_image/bank_image.dart';
import 'package:pass_admin/pages/upload/bank_image/uploaded_image.dart';
import 'package:pass_admin/pages/upload/dropbox.dart';
import 'package:pass_admin/shared/navbar.dart';

import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late DropzoneViewController controller;

  bool hovered = false;

  List<UploadedImage> bImg = [];

  List<Image> _images = [];
  List<String> _names = [];
  List<Uint8List> _bytes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Navbar(page: CurPage.upload),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Dropbox(
              onPick: ({required bytes, required names, required images}) {
                setState(() {
                  _images.addAll(images);
                  _names.addAll(names);
                  _bytes.addAll(bytes);
                });
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<ButtonNotifier>(context, listen: false).buttonPressed();
            },
            child: Container(
              height: 30,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Match TextField border
                borderRadius: BorderRadius.circular(4.0), // Rounded corners
              ),
              child: const Center(
                child: Text('Опубликовать всё неопубликованное'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: List.generate(
                    _images.length,
                    (index) => BankImage(
                      name: _names[index],
                      img: _images[index],
                      bytes: _bytes[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonNotifier extends ChangeNotifier {
  void buttonPressed() {
    notifyListeners();
  }
}
