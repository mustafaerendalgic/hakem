import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/authentication_cubit.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/authentication_states.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';

class LoginPage extends StatefulWidget {
  bool isPasswordSecret = true;
  TextEditingController passController = TextEditingController();
  OutlineInputBorder AuthTextFieldBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.primary, width: 2),
  );

  LoginPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Material(
              color: AppColors.beyaz,
              child: Container(
                child: BlocBuilder<AuthenticationCubit, AuthenticationStates>(
                  bloc: context.read<AuthenticationCubit>(),
                  builder: (context, state) {
                    void passSecrecy(bool secrecy) {
                      setState(() {
                        widget.isPasswordSecret = secrecy;
                      });
                    }

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
                              enabledBorder: widget.AuthTextFieldBorder,
                              focusedBorder: widget.AuthTextFieldBorder,
                              border: widget.AuthTextFieldBorder,
                              hintText: "E-mail",
                              hintStyle: TextStyles.navigationLabelRegular
                                  .copyWith(color: AppColors.primary),
                              icon: Icon(
                                Icons.email,
                                size: 24,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: widget.passController,
                            obscureText: widget.isPasswordSecret,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hint: Text("Şifre"),
                              hintStyle: TextStyles.navigationLabelRegular
                                  .copyWith(color: AppColors.primary),
                              icon: Icon(Icons.key, color: AppColors.primary),
                              border: widget.AuthTextFieldBorder,
                              enabledBorder: widget.AuthTextFieldBorder,
                              focusedBorder: widget.AuthTextFieldBorder,
                              disabledBorder: widget.AuthTextFieldBorder,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  widget.isPasswordSecret
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {
                                  passSecrecy(!widget.isPasswordSecret);
                                },
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Şifremi Unuttum",
                                  style: TextStyles.navigationLabelRegular
                                      .copyWith(color: AppColors.primary),
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
                                    context
                                        .read<AuthenticationCubit>()
                                        .authenticate(
                                          "test@example.com",
                                          "123456",
                                        );
                                  },
                                  child: Text(
                                    "Giriş Yap",
                                    style: TextStyles.smallBodySemibold
                                        .copyWith(color: AppColors.beyaz),
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
            ),
          ),
        );
      },
    );
  }
}
