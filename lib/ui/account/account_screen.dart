import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/authentication_cubit.dart';
import 'package:isg_ihlal/data/states/authentication_states.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<AuthenticationCubit, AuthenticationStates>(
        bloc: context.read<AuthenticationCubit>(),
        builder: (context, state) {
          return Container(
            child: Center(
              child: IconButton(
                onPressed: () {
                  context.read<AuthenticationCubit>().deAuthenticate();
                },
                icon: Icon(Icons.logout),
              ),
            ),
          );
        },
      ),
    );
  }
}
