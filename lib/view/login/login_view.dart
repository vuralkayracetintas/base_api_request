import 'package:base_apis/cubit/auth_cubit.dart';
import 'package:base_apis/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Navigate to home when getMe data is loaded
        if (state.getMeData != null && state.isLoading == false) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login View',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                if (state.isLoading == true)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      cubit.login(username: 'emilys', password: 'emilyspass');
                    },
                    child: const Text('Login'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
