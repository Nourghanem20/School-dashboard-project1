import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled11/business%20logic/cubits/Show%20Time%20Table/cubit.dart';
import 'package:untitled11/business%20logic/cubits/edit_profile_backup_cubit/cubit.dart';
import 'package:untitled11/business%20logic/cubits/event_cubit/cubit.dart';
import 'package:untitled11/business%20logic/cubits/exam_schedule_cubit/cubit.dart';
import 'package:untitled11/business%20logic/cubits/exam_table_cubit/cubit.dart';
import 'package:untitled11/business%20logic/cubits/feedback_cubit/cubit.dart';
import 'package:untitled11/business%20logic/cubits/home_cubit_owner/cubit.dart';
import 'package:untitled11/business%20logic/cubits/home_cubit_staff/cubit.dart';
import 'package:untitled11/business%20logic/cubits/login_cubit/cubit.dart';
import 'package:untitled11/business%20logic/cubits/sort_student_cubit/cubit.dart';
import 'package:untitled11/business%20logic/cubits/staff_profile/cubit.dart';
import 'package:untitled11/business%20logic/cubits/student_cubit/cubit.dart';
import 'package:untitled11/business%20logic/cubits/student_profile/student_profile_cubit.dart';
import 'package:untitled11/business%20logic/cubits/teacher_cubit/cubit.dart';
import 'package:untitled11/business%20logic/cubits/timetable_cubit/cubit.dart';
import 'package:untitled11/business%20logic/cubits/web_cubit/cubit_admin.dart';
import 'package:untitled11/business%20logic/cubits/web_cubit/cubit_staff.dart';
import 'package:untitled11/network/cache_helper.dart';
import 'package:untitled11/presentation/components%20and%20constants/bloc_observer.dart';
import 'package:untitled11/presentation/components%20and%20constants/constants.dart';
import 'package:untitled11/presentation/screens/layouts/layout1.dart';
import 'package:untitled11/presentation/screens/layouts/staff_layout.dart';
import 'package:untitled11/presentation/screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  Widget? widget;
  token = CacheHelper.getData(key: 'token');
  type = CacheHelper.getData(key: 'type');
  print(token);
  print(type);
  //CacheHelper.removeData(key: 'token');
  // CacheHelper.removeData(key: 'type');

  if (token != null) {
    if (type == 'owner') {
      widget = DashBoard();
    } else if (type == 'admin') {
      widget = DashBoardStaff();
    }
  } else {
    widget = LogIn();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  MyApp({this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppLoginCubit(),
        ),
        BlocProvider(
          create: (context) => WebHomeCubit()..getHomeWebData(year: DateTime.now().year + 1, token: token.toString()),
        ),
        BlocProvider(create: (context) => WebHomeStaffCubit()..getHomeWebData(year: DateTime.now().year + 1, token: token.toString())),
        BlocProvider(
          create: (context) => EventWebCubit()..showEvents(),
        ),
        BlocProvider(
          create: (context) =>
              ShowTimetableCubit(),
        ),
        BlocProvider(
          create: (context) => StudentCubit(),
        ),
        BlocProvider(
          create: (context) => AppTeacherWebCubit()..showTeachers(activeValue:'true' ),
        ),
        BlocProvider(
          create: (context) => TimetableCubit()
            ..showSections()
            ..showSubjectTeacher()
            ..showEnglishSubjectTeacher()
            ..showFrenchSubjectTeacher()
            ..showMathSubjectTeacher()
            ..showPhysicsSubjectTeacher()
            ..showChemistrySubjectTeacher()
            ..showArtSubjectTeacher()
            ..showMusicSubjectTeacher()
            ..showSportsSubjectTeacher()
            ..showSocialSubjectTeacher()
            ..showCultureSubjectTeacher()
            ..showReligionSubjectTeacher()
            ..showPhilosophySubjectTeacher()
            ..showScienceSubjectTeacher()
            ..showTechnologySubjectTeacher(),
        ),
        BlocProvider(create: (context) => ExamCubit(),),
        BlocProvider(
          create: (context) => WebStaffCubit()..showStaff(),
        ),
        BlocProvider(
          create: (context) => WebSchoolCubit(),
        ),
        BlocProvider(
          create: (context) => StaffProfileCubit(),
        ),
        BlocProvider(
          create: (context) => StudentProfileCubit(),
        ),
        BlocProvider(
          create: (context) => StudentSortCubit(),
        ),
        BlocProvider(
          create: (context) => FeedbackCubit(),
        ),
        BlocProvider(
          create: (context) => EditBackUpCubit(),
        ),
        BlocProvider(
          create: (context) => AddExamTableCubit(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: buildMaterialColor(AppColors.darkBlue)),
        debugShowCheckedModeBanner: false,
        home: startWidget,
      ),
    );
  }
}
