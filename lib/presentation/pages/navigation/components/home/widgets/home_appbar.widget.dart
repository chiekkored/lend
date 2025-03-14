import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class HomeAppbarWidget extends StatelessWidget {
  const HomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: LNDColors.white,
      surfaceTintColor: LNDColors.white,
      pinned: true,
      title: Container(
        decoration: BoxDecoration(
          color: LNDColors.outline,
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: LNDColors.hint,
                size: 16.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Search',
                  style: TextStyle(color: LNDColors.hint, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
