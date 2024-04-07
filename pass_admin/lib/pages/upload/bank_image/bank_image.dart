import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pass_admin/pages/upload/bank_image/error_image.dart';
import 'package:pass_admin/pages/upload/bank_image/uploaded_image.dart';
import 'package:pass_admin/pages/upload/bank_image/uploading_image.dart';
import 'package:pass_admin/pages/upload/image_data.dart';
import 'package:pass_admin/pages/upload/page.dart';
import 'package:pass_admin/shared/network.dart';
import 'package:provider/provider.dart';

enum ButtonState { uploaing, uploaded, published, error }

class BankImage extends StatefulWidget {
  const BankImage({super.key, required this.name, required this.img, required this.bytes});

  final String name;
  final Image img;
  final Uint8List bytes;

  @override
  State<BankImage> createState() => _BankImageState();
}

class _BankImageState extends State<BankImage> {
  ButtonState state = ButtonState.uploaing;

  String error = 'No error';
  String remoteName = '';

  late ImageInformation data;

  @override
  void initState() {
    super.initState();

    final buttonNotifier = Provider.of<ButtonNotifier>(context, listen: false);
    buttonNotifier.addListener(_onButtonPressed);

    Network.uploadImage(widget.bytes, widget.name).then((value) {
      if (value['error'] != null) {
        error = value['error'];
        setState(() {
          state = ButtonState.error;
        });
      } else {
        final filename = value['filename'];
        remoteName = filename;

        Network.checkUpload(filename).then((value) {
          if (value['error'] != null) {
            error = value['error'];
            setState(() {
              state = ButtonState.error;
            });
          } else {
            print(value);

            data = ImageInformation.fromMap(value['image_info']);

            print(data.tags);

            setState(() {
              state = ButtonState.uploaded;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    Provider.of<ButtonNotifier>(context, listen: false).removeListener(_onButtonPressed);

    super.dispose();
  }

  void _onButtonPressed() {
    // print('Button was pressed!');
  }

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ButtonState.uploaing:
        return UploadingImage(name: widget.name, img: widget.img);
      case ButtonState.uploaded:
        return UploadedImage(
          name: widget.name,
          img: widget.img,
          data: data,
          remoteFilename: remoteName,
        );
      case ButtonState.error:
        return ErrorImage(
          name: widget.name,
          img: widget.img,
          error: error,
        );
      default:
        return Container();
    }
  }
}
