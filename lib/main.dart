import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrime/handler/steps_handler.dart';
import 'package:nutrime/routes.dart';

import 'blocs/calories/calories_bloc.dart';
import 'blocs/date/date_bloc.dart';
import 'blocs/image/image_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'handler/custom_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StepsDataHandler().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => ImageBloc()),
        BlocProvider(create: (context) => DateBloc()),
        BlocProvider(create: (context) => CaloriesBloc()),
      ],
      child: ScreenUtilInit(
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            title: 'NutriMe',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              errorColor: Colors.red,
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
            ),
            onGenerateRoute: onGenerateRoute,
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
          );
        },
      ),
    );
  }
}
