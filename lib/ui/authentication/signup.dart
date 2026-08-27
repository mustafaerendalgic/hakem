import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/authentication_cubit.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/authentication_states.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';

class SignUpPage extends StatefulWidget {
  bool isPasswordSecret = true;
  TextEditingController controller = TextEditingController();
  OutlineInputBorder AuthTextFieldBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.primary, width: 2),
  );
  SignUpPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final double _outlineWidth = 2;
    void passSecrecy(bool secrecy) {
      setState(() {
        widget.isPasswordSecret = secrecy;
      });
    }

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
                    String eMail = "";
                    String password = "";
                    if (state is SigningUpState) {
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
                            onChanged: (e) {
                              eMail = e;
                            },
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
                            controller: widget.controller,
                            obscureText: widget.isPasswordSecret,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.key_rounded,
                                color: AppColors.primary,
                              ),
                              hint: Text("Şifre"),
                              hintStyle: TextStyles.navigationLabelRegular
                                  .copyWith(color: AppColors.primary),
                              enabledBorder: widget.AuthTextFieldBorder,
                              focusedBorder: widget.AuthTextFieldBorder,
                              border: widget.AuthTextFieldBorder,
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.primary,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    context.read<AuthenticationCubit>().signUp(
                                      eMail,
                                      password,
                                    );
                                  },
                                  child: Text(
                                    "Kayıt Ol",
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
                                  AuthNavigationElement.login,
                                );
                              },
                              child: Text(
                                "Giriş Yap",
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
