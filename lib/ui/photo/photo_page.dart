
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/camera_cubit.dart';
import 'package:isg_ihlal/data/cubits/form_cubit.dart';
import 'package:isg_ihlal/data/repo/camera.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/ui/photo/take_picture_screen.dart';
import 'package:isg_ihlal/ui/photo/violation_form.dart';

class CameraFlowScreen extends StatelessWidget {
  const CameraFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CameraCubit(CameraRepository())..initializeCamera(),),
        BlocProvider(create: (context) => FormCubit())
      ],
      child: AnimatedBuilder(
        animation: NavigationSession.instance,
        builder: (context, _) {
          return switch (NavigationSession.instance.cameraNavigationElement) {
            CameraNavigationElement.camera => TakePictureScreen(),
            CameraNavigationElement.form => ViolationFormScreen(),
          };
        },
      ),
    );
  }
}