import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(page: CurPage.stats),
            const Padding(padding: EdgeInsets.all(10)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Image.asset('assets/fr1.png'),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Image.asset('assets/fr2.png'),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Image.asset('assets/fr3.png'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Image.asset('assets/fr4.png'),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Image.asset('assets/fr5.png'),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Image.asset('assets/fr6.png'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Image.asset('assets/fr7.png'),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Image.asset('assets/fr8.png'),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Image.asset('assets/fr9.png'),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.all(10),
            // ),
          ],
        ),
      ),
    );
  }
}
