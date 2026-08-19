import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/authentication_cubit.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/authentication_states.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final double _outlineWidth = 2;
    return Material(
      child: Container(
        child: BlocBuilder<AuthenticationCubit, AuthenticationStates>(
          bloc: context.read<AuthenticationCubit>(),
          builder: (context, state) {
            if (state is AuthenticatingState) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 64, right: 64),
                    child: Image.asset('assets/logo.png'),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: _outlineWidth,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: _outlineWidth,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: _outlineWidth,
                          color: AppColors.primary,
                        ),
                      ),
                      hintText: "E-mail",
                      hintStyle: TextStyles.navigationLabelRegular.copyWith(
                        color: AppColors.primary,
                      ),
                      icon: Icon(
                        Icons.email,
                        size: 24,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: _outlineWidth,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: _outlineWidth,
                        ),
                      ),
                      border: OutlineInputBorder(),
                      hintText: "Şifre",
                      hintStyle: TextStyles.navigationLabelRegular.copyWith(
                        color: AppColors.primary,
                      ),
                      icon: Icon(Icons.key, size: 24, color: AppColors.primary),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Şifremi Unuttum",
                          style: TextStyles.navigationLabelRegular.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primary,
                        ),
                        child: TextButton(
                          onPressed: () {
                            context.read<AuthenticationCubit>().authenticate(
                              "test@example.com",
                              "123456",
                            );
                          },
                          child: Text(
                            "Giriş Yap",
                            style: TextStyles.smallBodySemibold.copyWith(
                              color: AppColors.beyaz,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: TextButton(
                      onPressed: () {
                        NavigationSession.instance.updateAuthIndex(
                          AuthNavigationElement.signup,
                        );
                      },
                      child: Text(
                        "Kayıt Ol",
                        style: TextStyles.bodyBold.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
