import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/authentication_cubit.dart';
import 'package:isg_ihlal/data/cubits/violation_cubit.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/authentication_states.dart';
import 'package:isg_ihlal/firebase_options.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';
import 'package:isg_ihlal/ui/account/account_screen.dart';
import 'package:isg_ihlal/ui/analysis/analysis_screen.dart';
import 'package:isg_ihlal/ui/archives/archive_page.dart';
import 'package:isg_ihlal/ui/authentication/authentication.dart';
import 'package:isg_ihlal/ui/common/top_bar.dart';
import 'package:isg_ihlal/ui/home/home_page.dart';
import 'package:isg_ihlal/ui/notifications/notifications_screen.dart';
import 'package:isg_ihlal/ui/photo/photo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ISGApp();
  }
}

class ISGApp extends StatefulWidget {
  ISGApp({super.key});
  @override
  State<StatefulWidget> createState() {
    return ISGState();
  }
}

class ISGState extends State<ISGApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationCubit>(
          create: (context) => AuthenticationCubit(),
        ),
        BlocProvider(create: (context) => ViolationCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationCubit, AuthenticationStates>(
          builder: (context, state) {
            final NavigationSession session = NavigationSession.instance;
            if (state is AuthenticatedState) {
              return ListenableBuilder(
                listenable: NavigationSession.instance,
                builder: (context, child) {
                  Widget activePage;
                  switch (session.navigationIndex) {
                    case NavigationElement.home:
                      activePage = HomePage();
                      context.read<ViolationCubit>().listenToTheList();
                    case NavigationElement.photo:
                      activePage = PhotoPage();
                    case NavigationElement.analysis:
                      activePage = AnalysisScreen();
                    case NavigationElement.account:
                      activePage = AccountScreen();
                    case NavigationElement.archives:
                      context.read<ViolationCubit>().listenToTheArchives();
                      activePage = ArchivePage();
                    case NavigationElement.notifications:
                      activePage = NotificationsScreen();
                    default:
                      activePage = HomePage();
                  }
                  return Scaffold(
                    appBar: TopAppBar(),
                    body: activePage,
                    bottomNavigationBar: Container(
                      color: AppColors.primary,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BottomNavItem(
                            "Home",
                            Icons.home,
                            NavigationElement.home,
                            session.navigationIndex == NavigationElement.home,
                            (index) {
                              session.updateIndex(index);
                            },
                          ),
                          BottomNavItem(
                            "Fotoğraf",
                            Icons.camera_enhance_rounded,
                            NavigationElement.photo,
                            session.navigationIndex == NavigationElement.photo,
                            (index) {
                              session.updateIndex(index);
                            },
                          ),
                          BottomNavItem(
                            "Analiz",
                            Icons.analytics_rounded,
                            NavigationElement.analysis,
                            session.navigationIndex ==
                                NavigationElement.analysis,
                            (index) {
                              session.updateIndex(index);
                            },
                          ),
                          BottomNavItem(
                            "Hesap",
                            Icons.person_2_rounded,
                            NavigationElement.account,
                            session.navigationIndex ==
                                NavigationElement.account,
                            (index) {
                              session.updateIndex(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return AuthenticationPage();
            }
          },
        ),
      ),
    );
  }
}

Widget BottomNavItem(
  String label,
  IconData icon,
  NavigationElement index,
  bool isSelected,
  void Function(NavigationElement) callback,
) {
  final Color color = isSelected ? AppColors.primary : AppColors.beyaz;
  return Material(
    child: InkWell(
      onTap: () => callback(index),
      child: Container(
        width: 90,
        color: AppColors.primary,
        padding: EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.beyaz : AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            spacing: 4,
            children: [
              Icon(icon, size: 30, color: color),
              Text(
                label,
                style: TextStyles.navigationLabelRegular.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
