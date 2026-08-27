import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/camera_cubit.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/camera_states.dart';
import 'package:isg_ihlal/theme/app_colors.dart';

class TakePictureScreen extends StatelessWidget {
  const TakePictureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CameraView();
  }
}

class _CameraView extends StatelessWidget {
  const _CameraView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<CameraCubit, CameraState>(
        builder: (context, state) {
          return switch (state) {
            CameraInitial() => const SizedBox(),

            CameraLoading() => const Center(child: CircularProgressIndicator()),

            CameraReady(:final controller) => _buildPreview(
              context,
              controller,
            ),

            CameraCapturing(:final controller) => _buildPreview(
              context,
              controller,
            ),

            CameraCaptured(:final image) => _buildResult(context, image),

            CameraError(:final message) => Center(
              child: Text('Hata: $message'),
            ),
          };
        },
      ),
    );
  }

  Widget _buildPreview(
    BuildContext context,
    CameraController controller,) {
    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.previewSize!.height,
            height: controller.value.previewSize!.width,
            child: CameraPreview(controller),
          ),
        ),

        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                context.read<CameraCubit>().takePicture();
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.beyaz,
                  border: Border(
                    left: BorderSide(color: AppColors.primary, width: 4),
                    right: BorderSide(color: AppColors.primary, width: 4),
                    top: BorderSide(color: AppColors.primary, width: 4),
                    bottom: BorderSide(color: AppColors.primary, width: 4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context, XFile image) {
    return Container(
      child: Stack(
        children: [
          SizedBox.expand(
            child: Image.file(
              File(image.path),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          context.read<CameraCubit>().resetToReady();
                        },
                        icon: const Icon(
                          Icons.cancel_rounded,
                          color: AppColors.beyaz,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          NavigationSession.instance.updateCameraIndex(
                            CameraNavigationElement.form,
                          );
                        },
                        icon: const Icon(
                          Icons.check_rounded,
                          color: AppColors.beyaz,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
