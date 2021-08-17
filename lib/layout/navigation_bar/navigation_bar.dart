import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hk4_sallah/shared/network/local/salla_States.dart';
import 'package:hk4_sallah/shared/style/colors.dart';

import 'cubit.dart';

class NavigationBar extends StatelessWidget {
  static const String NAVIGATION_BAR_SCREEN = 'nav_bar';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationCubit, SallaStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        return Scaffold(
          body: NavigationCubit.get(context)
              .navigationScreens[NavigationCubit.get(context).currentIndex],
          bottomNavigationBar: FancyBottomNavigation(
            tabs: NavigationCubit.get(context).item,
            onTabChangedListener: (int position) {
              NavigationCubit.get(context).changeIndex(position);
            },
            circleColor: Colors.orange,
            activeIconColor: Colors.deepPurpleAccent,
            inactiveIconColor: Colors.grey,
            textColor: colorPrim,
            initialSelection: NavigationCubit.get(context).currentIndex,
          ),
        );
      },
    );
  }
}
