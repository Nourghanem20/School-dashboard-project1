
import '../../../data/models/add_exam_table_message_model.dart';

abstract class ExamTableState {}

class InitialExamTableState extends ExamTableState {}

class ExamTableAddSuccessState extends ExamTableState {
  AddExamTableMessage ex;
  ExamTableAddSuccessState(this.ex);
}

class ExamTableAddLoadingState extends ExamTableState {}

class ExamTableAddErrorState extends ExamTableState {
  final String error;

  ExamTableAddErrorState({required this.error});
}
class AddExamChangeGradeState extends ExamTableState {}
class AddExamChangeSemesterState extends ExamTableState {}


