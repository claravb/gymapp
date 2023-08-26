import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymapp/models/workout.dart';
import 'package:gymapp/states/workout_states.dart';
import 'package:wakelock/wakelock.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit() : super(const WorkoutInitial());

  Timer? _timer;

  editWorkout(Workout workout, int index) =>
      emit(WorkoutEditing(workout, index, null));

  editExercise(int? exIndex) {
    print('...my exercise index is $exIndex');
    emit(WorkoutEditing(
        state.workout, (state as WorkoutEditing).index, exIndex));
  }

  pauseWorkout() => emit(WorkoutPaused(state.workout, state.elapsed));
  resumeWorkout() => emit(WorkoutInProgress(state.workout, state.elapsed));

  goHome() {
    emit(const WorkoutInitial());
  }

  onTick(Timer timer) {
    if (state is WorkoutInProgress) {
      WorkoutInProgress wip = state as WorkoutInProgress;
      if (wip.elapsed! < wip.workout!.getTotal()) {
        //we have to keep
        emit(WorkoutInProgress(wip.workout, wip.elapsed! + 1));
        print('...my elapsed is ${wip.elapsed}');
      } else {
        _timer!.cancel();
        Wakelock.disable();
        emit(const WorkoutInitial());
      }
    }
  }

//int? index is optional so between []
  startWorkout(Workout workout, [int? index]) {
    Wakelock.enable(); //keeps screen alive
    if (index != null) {
    } else {
      emit(WorkoutInProgress(workout, 0));
    }
    _timer = Timer.periodic(
        const Duration(seconds: 1), onTick); //no need to pass the time
  }
}
