import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/camera_cubit.dart';
import 'package:isg_ihlal/data/repo/catalog/violation_catalog.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/camera_states.dart';
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
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CameraCubit>().state;
    final image = state is CameraCaptured ? state.image : null;
    return Scaffold(
      backgroundColor: AppColors.beyaz,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: CustomScrollView(
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
                            ...ViolationCatalog.violationCategory.map((
                              category,
                            ) {
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
                          dropdownMenuEntries: [
                            ...ViolationCatalog.violationType
                                .where((type) {
                                  return (type.categoryId ==
                                      widget._categoryId);
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
                            setState(() {
                              widget._locationId = value;
                            });
                          },
                          dropdownMenuEntries: [
                            ...ViolationCatalog.facilityZones.map((
                              category,
                            ) {
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
                          dropdownMenuEntries: [
                            ...ViolationCatalog.facilityLocations
                                .where((type) {
                                  return (type.zone_id ==
                                      widget._locationId);
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
                ],
              ),
            ),
          ],
        ),
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
