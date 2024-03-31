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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownValue = 'One';

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
              child: const Text('Загрузка успешна'),
              color: Colors.green,
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/img/Rectangle.png', height: 200, width: 300,fit: BoxFit.cover,),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text('JPEG, 150MB'), 
                    const Text('9999х9999, Горизонтальное')
                  ],
                ),
                const SizedBox(width: 12,),
                Column(
                  children: [
                    const Text('Наименование файла'), 
                    SizedBox(height: 10,),
                    Container(
                      child: const Text('Kremlin.jpeg'),
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Column(
                          children: [
                            const Text('Время года'), 
                            DropdownButton<String>(
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>['Зима', 'Весна', 'Лето', 'Осень']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                        ],),
                        Column(
                          children: [
                            const Text('Время дня'), 
                            DropdownButton<String>(
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>['Утро', 'День', 'Вечер', 'Ночь']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                        ],),
                        ],)
                      ],)
                  ],),
                const SizedBox(width: 12,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Черновик'),
                    ),
                    SizedBox(height: 14,),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Опубликовать'),
                    ),
                   SizedBox(height: 14,),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Удалить'),
                    ),
                  ],
                ),
              ],
            ),
        ),
      );
  }
}
