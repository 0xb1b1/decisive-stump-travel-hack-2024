import 'package:flutter/material.dart';
import 'package:pass_admin/pages/stats/graph.dart';
import 'package:pass_admin/shared/navbar.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Navbar(page: CurPage.stats),
          Padding(padding: EdgeInsets.all(10)),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    child: Graph(
                  label: 'Загрузок\nза сегодня',
                  value: 100,
                )),
                SizedBox(width: 10),
                Expanded(
                    child: Graph(
                  label: 'Загрузок\nв этом месяце',
                  value: 100,
                )),
                SizedBox(width: 10),
                Expanded(
                    child: Graph(
                  label: 'Самый\nпопулярный тег',
                  value: 100,
                )),
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.all(10),
          // ),
        ],
      ),
    );
  }
}
