// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/features/auth/presentation/cubit/auth_cubit.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == StateStatus.failure) {
          log(state.error.consoleMessage);
        } else if (state.status == StateStatus.success) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconRow(),
                SizedBox(height: 30.h),
                _buildHeaderText(context),
                SizedBox(height: 40.h),
                _buildSubText(context),
                SizedBox(height: 60.h),
                _buildGoogleSignInButton(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget for the row of icons
  Widget _buildIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(IconPath.laptop, height: 60.h),
        SizedBox(width: 10.w),
        Image.asset(IconPath.worker, height: 60.h),
      ],
    );
  }

  // Widget for the header text
  Widget _buildHeaderText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(
            context,
          ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
          children: [
            const TextSpan(text: 'Effortless Delivery, '),
            TextSpan(
              text: 'Trusted Service, ',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            const TextSpan(text: 'Efficient You'),
          ],
        ),
      ),
    );
  }

  // Widget for the subheading text
  Widget _buildSubText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(
              context,
            ).iconTheme.color!.withAlpha((0.4 * 255).toInt()),
          ),
          children: [
            const TextSpan(
              text:
                  'Streamline your business operations with real-time delivery tracking, seamless data management, and ',
            ),
            TextSpan(
              text: 'Enhanced Accountability !',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the Google sign-in button
  Widget _buildGoogleSignInButton(BuildContext context, AuthState state) {
    return GestureDetector(
      onTap: state.status == StateStatus.loading ? () {} : _signIn,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(IconPath.google, height: 30.h),
            SizedBox(width: 20.w),
            Text(
              'Continue with Google',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            if (state.status == StateStatus.loading) ...[
              SizedBox(width: 30.w),
              SizedBox(
                height: 20.h,
                width: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    context.read<AuthCubit>().signInWithGoogle();
  }
}
