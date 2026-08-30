import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/camera_cubit.dart';
import 'package:isg_ihlal/data/cubits/form_cubit.dart';
import 'package:isg_ihlal/data/entity/violation_types.dart';
import 'package:isg_ihlal/data/repo/catalog/violation_catalog.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/camera_states.dart';
import 'package:isg_ihlal/data/states/form_states.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';

class ViolationFormScreen extends StatefulWidget {
  ViolationFormScreen({super.key});
  String? _categoryId = ViolationCatalog.violationCategory[0].id;
  String? _locationId = ViolationCatalog.facilityZones[0].id;

  @override
  State<StatefulWidget> createState() {
    return ViolationFormState();
  }
}

class ViolationFormState extends State<ViolationFormScreen> {
  String? loc1;
  String? loc2;
  String? viTitle;
  ViolationType? viType;
  @override
  Widget build(BuildContext context) {
    final cameraState = context.watch<CameraCubit>().state;
    final state = context.watch<FormCubit>().state;
    final image = cameraState is CameraCaptured ? cameraState.image : null;
    final Widget screen = switch (state) {
      FormError() => Text(state.error),
      FormUploading() => Center(child: CircularProgressIndicator()),
      FormUploaded() => Center(
        child: Column(
          spacing: 16,
          children: [
            Icon(Icons.check_rounded, size: 48, color: AppColors.yesil),
            Text("İhlal Başarıyla Yüklendi"),
            IconButton(
              onPressed: () {
                NavigationSession.instance.updateCameraIndex(
                  CameraNavigationElement.camera,
                );
              },
              icon: Icon(Icons.home_rounded),
            ),
          ],
        ),
      ),
      FormInitial() => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Row(
                  spacing: 16,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigationSession.instance.updateCameraIndex(
                          CameraNavigationElement.camera,
                        );
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    Text("İhlal Formu", style: TextStyles.appTitleSemibold),
                  ],
                ),
                if (image != null) PhotoPreview(image),
                TextFormField(
                  onChanged: (value) {
                    viTitle = value;
                  },
                  maxLines: 4,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'İhlal açıklaması*',
                    alignLabelWithHint: true,
                    hintText: 'Açıklama giriniz...',
                    floatingLabelStyle: TextStyle(
                      color: AppColors.primary,
                      fontFamily: "Gabarito",
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                Text("İhlal Tipi*", style: TextStyles.body),
                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: DropdownMenu(
                        onSelected: (value) {
                          setState(() {
                            widget._categoryId = value;
                          });
                        },
                        dropdownMenuEntries: [
                          ...ViolationCatalog.violationCategory.map((category) {
                            return DropdownMenuEntry(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  AppColors.beyaz,
                                ),
                              ),
                              value: category.id,
                              label: category.title,
                            );
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: DropdownMenu(
                        onSelected: (value) {
                          viType = ViolationCatalog.violationType.firstWhere(
                            (type) => type.id == value,
                          );
                        },
                        dropdownMenuEntries: [
                          ...ViolationCatalog.violationType
                              .where((type) {
                                return (type.categoryId == widget._categoryId);
                              })
                              .map((type) {
                                return DropdownMenuEntry(
                                  value: type.id,
                                  label: type.title,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      AppColors.beyaz,
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                Text("Konum*", style: TextStyles.body),
                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: DropdownMenu(
                        onSelected: (value) {
                          loc1 = ViolationCatalog.facilityZones.firstWhere(
                            (zone) => zone.id == value,
                          ).title;
                          setState(() {
                            widget._locationId = value;
                          });
                        },
                        dropdownMenuEntries: [
                          ...ViolationCatalog.facilityZones.map((category) {
                            return DropdownMenuEntry(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  AppColors.beyaz,
                                ),
                              ),
                              value: category.id,
                              label: category.title,
                            );
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: DropdownMenu(
                        onSelected: (value) {
                          loc2 = ViolationCatalog.facilityLocations
                              .firstWhere((loc) => loc.id == value)
                              .title;
                        },
                        dropdownMenuEntries: [
                          ...ViolationCatalog.facilityLocations
                              .where((type) {
                                return (type.zone_id == widget._locationId);
                              })
                              .map((type) {
                                return DropdownMenuEntry(
                                  value: type.id,
                                  label: type.title,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      AppColors.beyaz,
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () {
                        if (image != null &&
                            viTitle != null &&
                            loc1 != null &&
                            loc2 != null &&
                            viType != null) {
                          context.read<FormCubit>().uploadViolation(
                            image,
                            viTitle!,
                            loc1.toString() + ", " + loc2.toString(),
                            viType!,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Lütfen zorunlu alanları doldurun"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Gönder",
                          style: TextStyles.bodyBold.copyWith(
                            color: AppColors.beyaz,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    };
    return Scaffold(
      backgroundColor: AppColors.beyaz,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: screen,
      ),
    );
  }
}

Widget PhotoPreview(XFile image) {
  return Container(
    padding: EdgeInsets.only(top: 8, bottom: 8, right: 0, left: 16),
    decoration: BoxDecoration(
      color: AppColors.beyaz,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      border: Border(left: BorderSide(color: AppColors.azTehlikeli, width: 3)),
    ),
    child: IntrinsicHeight(
      child: Row(
        spacing: 32,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.image, size: 22),
                    Expanded(
                      child: Text(
                        image.name,
                        style: TextStyles.smallBodySemibold,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    NavigationSession.instance.updateCameraIndex(
                      CameraNavigationElement.camera,
                    );
                  },
                  child: Text(
                    "Yeniden adlandırmak için dokunun",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.caption.copyWith(color: AppColors.gray),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 80,
              child: GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(image.path),
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black.withOpacity(0.4)),
                      const Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
