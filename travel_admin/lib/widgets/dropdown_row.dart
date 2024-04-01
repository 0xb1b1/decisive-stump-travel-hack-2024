import 'package:flutter/material.dart';

class DropwornRow extends StatefulWidget {
  final List<String> yearTime = ['Зима', 'Весна', 'Лето', 'Осень'];
  final List<String> dayTime = ['Утро', 'День', 'Вечер', 'Ночь'];
 DropwornRow({super.key});

  @override
  State<DropwornRow> createState() => _DropwornRowState();
}

class _DropwornRowState extends State<DropwornRow> {
   String dropdownValue1 = 'Зима';
  String dropdownValue2 = 'Утро';
  @override
  Widget build(BuildContext context) {
    return Row(
                      children: [
                        Column(
                          children: [
                            const Text('Время года'),
                            DropdownButton<String>(
                              value: dropdownValue1,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue1 = newValue!;
                                });
                              },
                              items: widget.yearTime
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(width: 12,),
                        Column(
                          children: [
                            const Text('Время дня'),
                            DropdownButton<String>(
                              value: dropdownValue2,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue2 = newValue!;
                                });
                              },
                              items: widget.dayTime
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    );
  }
}