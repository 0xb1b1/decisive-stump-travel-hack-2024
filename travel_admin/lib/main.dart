import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<String> yearTime = ['Зима', 'Весна', 'Лето', 'Осень'];
  final List<String> dayTime = ['Утро', 'День', 'Вечер', 'Ночь'];

  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownValue1 = 'Зима';
  String dropdownValue2 = 'Утро';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.green,
              child: const Text('Загрузка успешна'),
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/img/Rectangle.png',
                      height: 200,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text('JPEG, 150MB'),
                    const Text('9999х9999, Горизонтальное')
                  ],
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  children: [
                    const Text('Наименование файла'),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.grey,
                      child: const Text('Kremlin.jpeg'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
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
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Черновик'),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Опубликовать'),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Удалить'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
