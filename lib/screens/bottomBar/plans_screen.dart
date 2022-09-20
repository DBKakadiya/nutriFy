import 'package:flutter/material.dart';
import 'package:nutrime/models/plans_data.dart';

import '../../resources/resource.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({Key? key}) : super(key: key);

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool isFree = true;
  bool isMeal = false;
  bool isNutrition = false;
  bool isWalking = false;
  bool isWorkout = false;

  List<PlansData> freeData = [
    PlansData(image: imgFree1, title: 'Simple start challenge'),
    PlansData(image: imgFree2, title: 'Mindful + Motivated'),
    PlansData(image: imgFree3, title: 'Nutri me'),
    PlansData(image: imgFree4, title: 'Eat green')
  ];

  List<PlansData> mealsData = [
    PlansData(image: imgMeal1, title: 'High protein'),
    PlansData(image: imgMeal2, title: 'Low carb'),
  ];

  List<PlansData> nutritionData = [
    PlansData(image: imgNutrition1, title: 'Healthy kickstart'),
    PlansData(image: imgNutrition2, title: 'Support your immune system'),
    PlansData(image: imgNutrition3, title: 'Mindful + Motivated'),
    PlansData(image: imgNutrition4, title: 'Eat green'),
    PlansData(image: imgNutrition5, title: 'Simple start challenge'),
    PlansData(image: imgNutrition6, title: 'Reaching your calorie goal'),
    PlansData(image: imgNutrition7, title: 'Intro macro tracking'),
    PlansData(image: imgNutrition8, title: 'Building healthy habits'),
  ];

  List<PlansData> walkingData = [
    PlansData(image: imgWalking1, title: '11,000 Steps a Day'),
    PlansData(image: imgWalking2, title: '9,000 Steps a Day'),
    PlansData(image: imgWalking3, title: '6,000 Steps a Day'),
  ];

  List<PlansData> workoutData = [
    PlansData(image: imgWorkout1, title: 'Progressive dumbbell'),
    PlansData(image: imgWorkout2, title: 'Total body power'),
    PlansData(image: imgWorkout3, title: 'Strong glutes & things'),
    PlansData(image: imgWorkout4, title: 'Core plus'),
    PlansData(image: imgWorkout5, title: 'Progressive bodyweight'),
    PlansData(image: imgWorkout6, title: 'Toned upper body'),
    PlansData(image: imgWorkout7, title: 'Low impact strength'),
  ];

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: colorBG,
            leading: Container(),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              expandedTitleScale: 1,
              titlePadding: const EdgeInsets.symmetric(vertical: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  filterButton('Free', deviceWidth(context) * 0.13, isFree, () {
                    setState(() {
                      isFree = true;
                      isMeal = false;
                      isNutrition = false;
                      isWalking = false;
                      isWorkout = false;
                    });
                  }),
                  filterButton('Meal Plan', deviceWidth(context) * 0.2, isMeal,
                      () {
                    setState(() {
                      isMeal = true;
                      isFree = false;
                      isNutrition = false;
                      isWalking = false;
                      isWorkout = false;
                    });
                  }),
                  filterButton(
                      'Nutrition', deviceWidth(context) * 0.175, isNutrition,
                      () {
                    setState(() {
                      isNutrition = true;
                      isFree = false;
                      isMeal = false;
                      isWalking = false;
                      isWorkout = false;
                    });
                  }),
                  filterButton(
                      'Walking', deviceWidth(context) * 0.165, isWalking, () {
                    setState(() {
                      isWalking = true;
                      isFree = false;
                      isMeal = false;
                      isNutrition = false;
                      isWorkout = false;
                    });
                  }),
                  filterButton(
                      'Workout', deviceWidth(context) * 0.17, isWorkout, () {
                    setState(() {
                      isWorkout = true;
                      isFree = false;
                      isMeal = false;
                      isNutrition = false;
                      isWalking = false;
                    });
                  })
                ],
              ),
              background: Padding(
                padding: EdgeInsets.only(left: deviceWidth(context) * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text('Find a Plan', style: textStyle18Bold(colorIndigo)),
                    const SizedBox(height: 10),
                    Text(
                        'Meal Plans, Workout Plans and more, start a plan, follow along and reach your goals',
                        style: textStyle13(colorIndigo).copyWith(height: 1.3)),
                    const SizedBox(height: 25),
                    Text('Filter by :', style: textStyle16Bold(colorIndigo)),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.04),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: 50,
                decoration: decoration(colorIndigo, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Available Plans', style: textStyle18Bold(colorIndigo)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              if (isFree) filterData(freeData),
              if (isMeal) filterData(mealsData),
              if (isNutrition) filterData(nutritionData),
              if (isWalking) filterData(walkingData),
              if (isWorkout) filterData(workoutData),
              if (!isMeal)const SizedBox(height: 120),
              if (isMeal)const SizedBox(height: 190),
            ],
          ),
        ),
      ),
    );
  }

  filterButton(String title, double width, bool isSelect, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 37,
        width: width,
        decoration: isSelect
            ? BoxDecoration(
                color: colorIndigo,
                borderRadius: BorderRadius.circular(30),
              )
            : decoration(colorIndigo, 30),
        alignment: Alignment.center,
        child: Text(title,
            style: textStyle12(isSelect ? colorWhite : colorIndigo)),
      ),
    );
  }

  filterData(List<PlansData> list) {
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: deviceHeight(context) * 0.01),
        child: Container(
            height: 219.0 * list.length,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorGrey, width: 1)),
            child: Column(
              children: List.generate(
                  list.length,
                  (index) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(list[index].title,
                                    style: textStyle14Bold(colorIndigo)),
                                Text('7 days',
                                    style: textStyle12Medium(colorGrey)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: AssetImage(list[index].image),
                                      fit: BoxFit.fill)),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      )),
            )
            // ListView.builder(
            //     itemCount: list.length,
            //     itemBuilder: (context, index) => Padding(
            //           padding: EdgeInsets.symmetric(
            //               horizontal: deviceWidth(context) * 0.03),
            //           child: Column(
            //             children: [
            //               SizedBox(height: deviceHeight(context) * 0.015),
            //               Row(
            //                 mainAxisAlignment:
            //                     MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(list[index].title,
            //                       style: textStyle14Bold(colorIndigo)),
            //                   Text('7 days',
            //                       style: textStyle12Medium(colorGrey)),
            //                 ],
            //               ),
            //               SizedBox(height: deviceHeight(context) * 0.007),
            //               Container(
            //                 height: deviceHeight(context) * 0.18,
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(15),
            //                     image: DecorationImage(
            //                         image: AssetImage(list[index].image),
            //                         fit: BoxFit.fill)),
            //               ),
            //               SizedBox(height: deviceHeight(context) * 0.015),
            //             ],
            //           ),
            //         ))
            ));
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: radius == 30 ? colorBG : colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 30 ? Border.all(color: color, width: 1) : null,
        boxShadow: [
          if (radius != 30)
            BoxShadow(
                color: color.withOpacity(0.15),
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
        decoration: decoration(colorIndigo, 5),
        alignment: Alignment.center,
        child: Image.asset(icon,
            width: icon == icMoreVert
                ? deviceWidth(context) * 0.055
                : deviceWidth(context) * 0.04),
      ),
    );
  }
}
