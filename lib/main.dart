import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymapp/blocs/workout_cubit.dart';
import 'package:gymapp/blocs/workouts_cubit.dart';
import 'package:gymapp/screens/edit_workout_screen.dart';
import 'package:gymapp/screens/home_page.dart';
import 'package:gymapp/screens/workout_in_progress.dart';
import 'package:gymapp/states/workout_states.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBlocOverrides.runZoned(() => runApp(const WorkoutTime()),
      storage: storage);
}

class WorkoutTime extends StatelessWidget {
  const WorkoutTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Workouts',
        theme: ThemeData(
            primaryColor: Colors.blue,
            textTheme: const TextTheme(
                // bodyText2: TextStyle(color: Color.fromARGB(255, 66, 74, 96))
                bodyMedium: TextStyle(color: Colors.deepPurple))),
        home: /* BlocProvider(
        create: (BuildContext context) {
          WorkoutsCubit workoutsCubit = WorkoutsCubit();
          if (workoutsCubit.state.isEmpty) {
            print('...loading json since the state is empty');
            workoutsCubit.getWorkouts();
          } else {
            print('...the state is not empty');
          }
          return workoutsCubit;
        },
        child: BlocBuilder<WorkoutsCubit, List<Workout>>(
            builder: (context, state) {
          return const HomePage();
        }),
      ), */
            MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (BuildContext context) {
                WorkoutsCubit workoutsCubit = WorkoutsCubit();
                if (workoutsCubit.state.isEmpty) {
                  print('...loading json since the state is empty');
                  workoutsCubit.getWorkouts();
                } else {
                  print('...the state is not empty');
                }
                return workoutsCubit;
              },
            ),
            BlocProvider<WorkoutCubit>(
                create: (BuildContext context) => WorkoutCubit())
          ],
          child: BlocBuilder<WorkoutCubit, WorkoutState>(
              builder: (context, state) {
            if (state is WorkoutInitial) {
              print('initial');
              return const HomePage();
            } else if (state is WorkoutEditing) {
              return const EditWorkoutScreen();
            }
            return const WorkoutProgress();
          }),
        ));
  }
}
