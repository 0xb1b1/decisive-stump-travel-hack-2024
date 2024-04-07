import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class Dropbox extends StatefulWidget {
  const Dropbox({super.key, required this.onPick});

  final Function({required List<Image> images, required List<String> names, required List<Uint8List> bytes}) onPick;

  @override
  State<Dropbox> createState() => _DropboxState();
}

class _DropboxState extends State<Dropbox> {
  late DropzoneViewController controller;
  bool hovered = false;

  pickImages() async {
    List<PlatformFile>? fromPicker = (await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: const ['jpeg', 'png', 'webp', 'jpg'],
    ))
        ?.files;

    if (fromPicker != null) {
      widget.onPick(
        bytes: fromPicker.map((e) => e.bytes!).toList(),
        names: fromPicker.map((e) => e.name).toList(),
        images: fromPicker
            .map(
              (e) => Image.memory(
                e.bytes!,
                fit: BoxFit.cover,
              ),
            )
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: hovered ? Colors.blue[50] : Colors.white,
      ),
      child: Stack(
        children: [
          DropzoneView(
            operation: DragOperation.copy,
            // cursor: CursorType.grab,
            onCreated: (DropzoneViewController ctrl) => controller = ctrl,
            mime: const ['image/jpeg', 'image/png', 'image/webp', 'image/jpg'],
            onHover: () {
              setState(() {
                hovered = true;
              });
            },
            onDropMultiple: (ev) async {
              setState(() {
                hovered = false;
              });

              final files = ev ?? [];

              final urls = await Future.wait(
                files.map((e) => controller.createFileUrl(e)),
              );

              final names = await Future.wait(
                files.map((e) => controller.getFilename(e)),
              );

              final bytes = await Future.wait(
                files.map((e) => controller.getFileData(e)),
              );

              widget.onPick(
                bytes: bytes,
                names: names,
                images: urls
                    .map(
                      (e) => Image.network(
                        e,
                        fit: BoxFit.cover,
                      ),
                    )
                    .toList(),
              );
            },
            onLeave: () {
              setState(() {
                hovered = false;
              });
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.archive,
                  color: Colors.blue,
                ),
                const Text('Загрузите или перетащите файл в это поле'),
                GestureDetector(
                  onTap: () {
                    pickImages();
                  },
                  child: Container(
                    height: 32,
                    width: 184,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Text(
                        'Загрузить',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Файл не должен быть больше 100 Мб.',
                  style: TextStyle(color: Colors.grey),
                ),
                const Text(
                  'Допустимые форматы: JPEG, JPG, PNG, WEBP',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
