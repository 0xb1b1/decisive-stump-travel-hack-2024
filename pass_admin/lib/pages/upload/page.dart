import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:pass_admin/pages/upload/dropbox.dart';
import 'package:pass_admin/shared/navbar.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late DropzoneViewController controller;

  bool hovered = false;

  List<Image> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Navbar(page: CurPage.upload),
          Padding(
            padding: EdgeInsets.all(10),
            child: Dropbox(
              onPick: ({required bytes, required images}) {
                setState(() {
                  _images = images;
                });
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(width: 10, height: 10, child: _images[index]);
              },
            ),
          ),
          // Spacer(),
        ],
      ),
    );
  }
}
