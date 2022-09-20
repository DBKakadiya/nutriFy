import 'package:flutter/material.dart';
import 'package:nutrime/resources/resource.dart';
import 'package:nutrime/screens/setting_screen.dart';
import 'package:nutrime/widgets/userTabBar/my_info.dart';

import '../widgets/userTabBar/my_items.dart';

class UserScreen extends StatefulWidget {
  static const route = '/User-Screen';

  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: colorBG,
        body: SafeArea(
          child: SizedBox(
            height: deviceHeight(context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: deviceHeight(context) * 0.09,
                    width: deviceWidth(context),
                    decoration: BoxDecoration(color: colorWhite, boxShadow: [
                      BoxShadow(
                          color: colorIndigo.withOpacity(0.25),
                          blurRadius: 7,
                          offset: const Offset(0, 1))
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buttons(icBack, () => Navigator.of(context).pop()),
                        SizedBox(
                          height: deviceHeight(context) * 0.09,
                          width: deviceWidth(context) * 0.68,
                          child: TabBar(
                            indicatorColor: colorIndigo,
                            indicatorWeight: 3,
                            indicatorPadding: EdgeInsets.symmetric(
                                horizontal: deviceWidth(context) * 0.02),
                            labelPadding: EdgeInsets.zero,
                            tabs: [
                              Tab(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: deviceHeight(context) * 0.02),
                                  child: Text('My Info',
                                      style: textStyle14Bold(colorIndigo)),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: deviceHeight(context) * 0.02),
                                  child: Text('My Items',
                                      style: textStyle14Bold(colorIndigo)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        buttons(icSetting, () => Navigator.of(context).pushNamed(SettingScreen.route)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight(context) - deviceHeight(context) * 0.135,
                    child: const TabBarView(children: [
                      MyInfo(),
                      MyItems()
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              color: colorIndigo.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(2, 2)),
        ]);
  }

  buttons(String icon, Function() onclick) {
    return GestureDetector(
      onTap: onclick,
      child: Container(
        height: deviceHeight(context) * 0.042,
        width: deviceWidth(context) * 0.085,
        decoration: decoration(),
        alignment: Alignment.center,
        child: Image.asset(icon, width: deviceWidth(context) * 0.04),
      ),
    );
  }

}
