import 'package:flutter/material.dart';

class ErrorImage extends StatefulWidget {
  const ErrorImage({super.key, required this.name, required this.img, required this.error});

  final String name;
  final Image img;
  final String error;

  @override
  State<ErrorImage> createState() => _ErrorImageState();
}

class _ErrorImageState extends State<ErrorImage> {
  late final TextEditingController _filenameController;

  @override
  void initState() {
    super.initState();

    _filenameController = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    _filenameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.error,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 130,
          child: Row(
            children: [
              SizedBox(width: 200, height: 130, child: widget.img),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Наименование файла'),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 30,
                                child: TextField(
                                  controller: _filenameController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                                      disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200]),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(flex: 5, child: SizedBox.shrink()),
                        const SizedBox(width: 10),
                        const Expanded(flex: 5, child: SizedBox.shrink()),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
