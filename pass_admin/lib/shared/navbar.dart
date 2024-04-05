import 'package:flutter/material.dart';
import 'package:pass_admin/pages/stats/page.dart';
import 'package:pass_admin/pages/upload/page.dart';

enum CurPage { upload, stats }

class Navbar extends StatelessWidget {
  const Navbar({super.key, required this.page});

  final CurPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Row(
        children: [
          const SizedBox(width: 16),
          GestureDetector(
            onTap: page == CurPage.upload
                ? null
                : () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const UploadPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ));
                  },
            child: Text(
              'Загрузка фото',
              style: TextStyle(color: page == CurPage.upload ? Colors.blue : Colors.black),
            ),
          ),
          Container(width: 16),
          Container(
            height: 22,
            width: 1,
            color: Colors.grey,
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: page == CurPage.stats
                ? null
                : () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const StatsPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ));
                  },
            child: Text(
              'Статистика фотобанка',
              style: TextStyle(color: page == CurPage.stats ? Colors.blue : Colors.black),
            ),
          ),
          const Spacer(),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWyYPE-EuYCKkmAIcnHHQP5clEGWDBetgbIOJ3fruNiA&s'),
                radius: 25,
              ),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Иванов И. И.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Маркетолог')
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
