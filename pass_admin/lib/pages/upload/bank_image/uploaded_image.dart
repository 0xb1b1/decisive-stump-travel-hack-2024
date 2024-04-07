import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_admin/pages/upload/image_data.dart';
import 'package:pass_admin/pages/upload/page.dart';
import 'package:pass_admin/shared/network.dart';
import 'package:provider/provider.dart';

class UploadedImage extends StatefulWidget {
  const UploadedImage(
      {super.key, required this.name, required this.img, required this.data, required this.remoteFilename});

  final String name;
  final Image img;
  final ImageInformation data;
  final String remoteFilename;

  @override
  State<UploadedImage> createState() => _UploadedImageState();
}

class _UploadedImageState extends State<UploadedImage> {
  late final TextEditingController _filenameController;
  final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _tagsController;

  late String yearTime;
  late String dayTime;
  late String weather;
  late String atmosphere;
  late String people;
  late String color;

  bool isLoading = false;
  bool isPublished = false;

  @override
  void initState() {
    _filenameController = TextEditingController(text: widget.name);
    _tagsController = TextEditingController(text: widget.data.tags.join(','));

    yearTime = ImageInformation.yearTimes.contains(capitalizeFirstLetter(widget.data.yearTime))
        ? capitalizeFirstLetter(widget.data.yearTime)
        : ImageInformation.yearTimes[0];
    dayTime = ImageInformation.dayTimes.contains(capitalizeFirstLetter(widget.data.dayTime))
        ? capitalizeFirstLetter(widget.data.dayTime)
        : ImageInformation.dayTimes[0];
    weather = ImageInformation.weathers.contains(capitalizeFirstLetter(widget.data.weather))
        ? capitalizeFirstLetter(widget.data.weather)
        : ImageInformation.weathers[0];
    atmosphere = ImageInformation.atmospheres.contains(capitalizeFirstLetter(widget.data.atmosphere))
        ? capitalizeFirstLetter(widget.data.atmosphere)
        : ImageInformation.atmospheres[0];
    people = ImageInformation.peoples.contains(capitalizeFirstLetter(widget.data.people))
        ? capitalizeFirstLetter(widget.data.people)
        : ImageInformation.peoples[0];
    color = ImageInformation.colors.contains(capitalizeFirstLetter(widget.data.color))
        ? capitalizeFirstLetter(widget.data.color)
        : ImageInformation.colors[0];

    super.initState();

    final buttonNotifier = Provider.of<ButtonNotifier>(context, listen: false);
    buttonNotifier.addListener(_publish);
  }

  @override
  void dispose() {
    _filenameController.dispose();
    _nameController.dispose();
    _tagsController.dispose();

    Provider.of<ButtonNotifier>(context, listen: false).removeListener(_publish);

    super.dispose();
  }

  void _publish() {
    if (isLoading || isPublished) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    Network.publish(
            widget.remoteFilename,
            _nameController.text,
            ImageInformation(
                tags: _tagsController.text.split(','),
                yearTime: yearTime,
                dayTime: dayTime,
                weather: weather,
                atmosphere: atmosphere,
                people: people,
                color: color,
                orientation: widget.data.orientation,
                grayscale: widget.data.grayscale,
                landmark: widget.data.landmark))
        .then((value) {
      if (value == true) {
        Network.checkPublish(widget.remoteFilename).then((value_2) {
          print(value_2);

          if (value_2) {
            setState(() {
              isPublished = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });

            print('unload');
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });

    print('publishing...');
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Загружено',
              style: TextStyle(color: Colors.white),
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
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Наименование фотографии'),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 30,
                                child: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    hintText: 'Введите название (обязательно)',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Теги'),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 30,
                                child: TextField(
                                  controller: _tagsController,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Время года'),
                              const SizedBox(height: 6),
                              CustomDropdown(
                                dropdownValue: yearTime,
                                onChange: (v) {
                                  if (v != null) {
                                    setState(() {
                                      yearTime = v;
                                    });
                                  }
                                },
                                values: ImageInformation.yearTimes,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Время суток'),
                              const SizedBox(height: 6),
                              CustomDropdown(
                                dropdownValue: dayTime,
                                onChange: (v) {
                                  if (v != null) {
                                    setState(() {
                                      dayTime = v;
                                    });
                                  }
                                },
                                values: ImageInformation.dayTimes,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Погода'),
                              const SizedBox(height: 6),
                              CustomDropdown(
                                dropdownValue: weather,
                                onChange: (v) {
                                  if (v != null) {
                                    setState(() {
                                      weather = v;
                                    });
                                  }
                                },
                                values: ImageInformation.weathers,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Атмосфера'),
                              const SizedBox(height: 6),
                              CustomDropdown(
                                dropdownValue: atmosphere,
                                onChange: (v) {
                                  if (v != null) {
                                    setState(() {
                                      atmosphere = v;
                                    });
                                  }
                                },
                                values: ImageInformation.atmospheres,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Люди на фото'),
                              const SizedBox(height: 6),
                              CustomDropdown(
                                dropdownValue: people,
                                onChange: (v) {
                                  if (v != null) {
                                    setState(() {
                                      people = v;
                                    });
                                  }
                                },
                                values: ImageInformation.peoples,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Цвет'),
                              const SizedBox(height: 6),
                              CustomDropdown(
                                dropdownValue: color,
                                onChange: (v) {
                                  if (v != null) {
                                    setState(() {
                                      color = v;
                                    });
                                  }
                                },
                                values: ImageInformation.colors,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 200,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _publish();
                      },
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey), // Match TextField border
                          borderRadius: BorderRadius.circular(4.0), // Rounded corners
                        ),
                        child: Center(
                          child: (isPublished)
                              ? Text('Опубликовано')
                              : isLoading
                                  ? CircularProgressIndicator()
                                  : Text('Опубликовать'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({super.key, required this.dropdownValue, required this.values, required this.onChange});

  final String dropdownValue;
  final List<String> values;
  final Function(String?) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5), // Match TextField padding
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Match TextField border
        borderRadius: BorderRadius.circular(4.0), // Rounded corners
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.expand_more, color: Colors.grey), // Icon color
          onChanged: (String? newValue) {
            onChange(newValue);
          },
          items: values.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14, // Match TextField text style
                  color: Colors.black, // Match TextField text color
                ),
              ),
            );
          }).toList(),

          dropdownColor: Colors.white,
          isDense: true,
        ),
      ),
    );
  }
}
