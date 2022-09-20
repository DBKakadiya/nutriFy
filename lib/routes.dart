import 'package:flutter/material.dart';
import 'package:nutrime/models/weight_data.dart';
import 'package:nutrime/screens/bottomBar/Steps_Last7Days_Screen.dart';
import 'package:nutrime/screens/bottomBar/add_exercise_screen.dart';
import 'package:nutrime/screens/bottomBar/add_food_screen.dart';
import 'package:nutrime/screens/bottomBar/add_note_screen.dart';
import 'package:nutrime/screens/bottomBar/add_water_screen.dart';
import 'package:nutrime/screens/bottomBar/custom_meal_name_screen.dart';
import 'package:nutrime/screens/bottomBar/diary_setting.dart';
import 'package:nutrime/screens/bottomBar/edit_reminder_screen.dart';
import 'package:nutrime/screens/bottomBar/exercise_screen.dart';
import 'package:nutrime/screens/bottomBar/my_reminders_screen.dart';
import 'package:nutrime/screens/bottomBar/nutrition_screen.dart';
import 'package:nutrime/screens/bottomBar/step_counter_screen.dart';
import 'package:nutrime/screens/bottomBar/update_exercise_screen.dart';
import 'package:nutrime/screens/create_screen/create_food.dart';
import 'package:nutrime/screens/create_screen/create_meal.dart';
import 'package:nutrime/screens/create_screen/create_recipe.dart';
import 'package:nutrime/screens/create_screen/quick_add.dart';
import 'package:nutrime/screens/edit_profile_screen.dart';
import 'package:nutrime/screens/exit_screen.dart';
import 'package:nutrime/screens/home_screen.dart';
import 'package:nutrime/screens/setting_screen.dart';
import 'package:nutrime/screens/splash_screen.dart';
import 'package:nutrime/screens/starting_screen.dart';
import 'package:nutrime/screens/user_screen.dart';
import 'package:nutrime/screens/users/add_friends_screen.dart';
import 'package:nutrime/screens/users/add_weight_screen.dart';
import 'package:nutrime/screens/users/addtional_nutrition_goal_screen.dart';
import 'package:nutrime/screens/users/customized_photo_screen.dart';
import 'package:nutrime/screens/users/display_weight_data_screen.dart';
import 'package:nutrime/screens/users/goal_screen.dart';
import 'package:nutrime/screens/users/import_photo_screen.dart';
import 'package:nutrime/screens/users/my_exercise_screen.dart';
import 'package:nutrime/screens/users/progress_screen.dart';
import 'package:nutrime/screens/users/recipes_meals_foods_screen.dart';
import 'package:nutrime/screens/users/set_calorie_carbs_protein_fat_screen.dart';
import 'package:nutrime/screens/bottomBar/step_statistics_screen.dart';
import 'package:nutrime/screens/users/updateCPF_percentage_screen.dart';
import 'package:nutrime/screens/welcome_screen.dart';

Route onGenerateRoute(RouteSettings routeSettings) {
  final arguments = routeSettings.arguments;
  switch (routeSettings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => SplashScreen());

    case '/Starting-Screen':
      return MaterialPageRoute(
        builder: (_) => const StartingScreen(),
      );

    case '/Welcome':
      return MaterialPageRoute(
        builder: (_) => WelcomeScreen(),
      );

    case '/Home-Screen':
      final data = arguments as HomeScreenData;
      return MaterialPageRoute(
        builder: (_) => HomeScreen(data: data),
      );

    case '/Step-Count-Screen':
      return MaterialPageRoute(
        builder: (_) => const StepCounterScreen(),
      );

    case '/Steps-Statistics':
      final count = arguments as int;
      return MaterialPageRoute(
        builder: (_) => StepsStatisticsScreen(stepCount: count),
      );

    case '/Steps-7Days':
      return MaterialPageRoute(
        builder: (_) => const StepsLast7DaysScreen(),
      );

    case '/User-Screen':
      return MaterialPageRoute(
        builder: (_) => const UserScreen(),
      );

    case '/Meals-Recipes-Foods':
      final index = arguments as int;
      return MaterialPageRoute(
        builder: (_) => MealsRecipesFoods(index: index),
      );

    case '/My-Exercises':
      final index = arguments as int;
      return MaterialPageRoute(
        builder: (_) => MyExercises(index: index),
      );

    case '/Exercise-Screen':
      final data = arguments as ExerciseData;
      return MaterialPageRoute(
        builder: (_) => ExerciseScreen(data: data),
      );

    case '/Quick-Add':
      final data = arguments as QuickAddScreenData;
      return MaterialPageRoute(
        builder: (_) => QuickAddScreen(data: data),
      );

    case '/Create-Meal':
      final data = arguments as CreateMealData;
      return MaterialPageRoute(
        builder: (_) => CreateMeal(data: data),
      );

    case '/Create-Food':
      final data = arguments as CreateFoodData;
      return MaterialPageRoute(
        builder: (_) => CreateFood(data: data),
      );

    case '/Create-Recipe':
      final data = arguments as CreateRecipeData;
      return MaterialPageRoute(
        builder: (_) => CreateRecipe(data: data),
      );

    case '/Add-Exercise':
      final data = arguments as AddExerciseData;
      return MaterialPageRoute(
        builder: (_) => AddExerciseScreen(data: data),
      );

    case '/Update-Exercise':
      final data = arguments as UpdateExerciseData;
      return MaterialPageRoute(
        builder: (_) => UpdateExerciseScreen(modelData: data),
      );

    case '/Add-Water':
      final data = arguments as AddWaterData;
      return MaterialPageRoute(
        builder: (_) => AddWaterScreen(data: data),
      );

    case '/Add-Note':
      final data = arguments as AddNoteData;
      return MaterialPageRoute(
        builder: (_) => AddNoteScreen(data: data),
      );

    case '/Diary-Setting':
      return MaterialPageRoute(
        builder: (_) => const DiarySettingScreen(),
      );

    case '/Custom-Meal-Name':
      return MaterialPageRoute(
        builder: (_) => const CustomMealNameScreen(),
      );

    case '/Edit-Reminder':
      final data = arguments as EditReminderData;
      return MaterialPageRoute(
        builder: (_) => EditReminderScreen(data: data),
      );

    case '/My-Reminder':
      return MaterialPageRoute(
        builder: (_) => const MyReminderScreen(),
      );

    case '/Setting-Screen':
      return MaterialPageRoute(
        builder: (_) => const SettingScreen(),
      );

    case '/Edit-Profile':
      return MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      );

    case '/Add-Weight':
      final type = arguments as String;
      return MaterialPageRoute(
        builder: (_) => AddWeightScreen(type: type),
      );

    case '/Progress-Screen':
      return MaterialPageRoute(
        builder: (_) => const ProgressScreen(),
      );

    case '/Import-Photo':
      final weightData = arguments as WeightData;
      return MaterialPageRoute(
        builder: (_) => ImportPhotoScreen(weightData: weightData),
      );

    case '/Display-Weight':
      final image = arguments as String;
      return MaterialPageRoute(
        builder: (_) => DisplayWeightDataScreen(image: image),
      );

    case '/Customize-photo':
      final data = arguments as CustomizePhotoData;
      return MaterialPageRoute(
        builder: (_) => CustomizePhotoScreen(data: data),
      );

    case '/Goals':
      return MaterialPageRoute(
        builder: (_) => const GoalsScreen(),
      );

    case '/Set-CalorieCPF':
      return MaterialPageRoute(
        builder: (_) => const SetCalorieCPFScreen(),
      );

    case '/Update-CPF':
      return MaterialPageRoute(
        builder: (_) => const UpdateCPFScreen(),
      );

    case '/Additional-Nutrient':
      return MaterialPageRoute(
        builder: (_) => const AdditionalNutritionScreen(),
      );

    case '/Add-Friends':
      return MaterialPageRoute(
        builder: (_) => const AddFriendsScreen(),
      );

    case '/Add-Food':
      final data = arguments as AddFoodScreenData;
      return MaterialPageRoute(
        builder: (_) => AddFoodScreen(data: data),
      );

    case '/Nutrition-Screen':
      final index = arguments as int;
      return MaterialPageRoute(
        builder: (_) => NutritionScreen(index: index),
      );

    case '/Exit-Screen':
      return MaterialPageRoute(
        builder: (_) => const ExitScreen(),
      );

    default:
      return MaterialPageRoute(builder: (_) => Container());
  }
}
