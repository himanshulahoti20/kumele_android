import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/home/presentation/home_tab_type.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/profileset/profile_pic.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: ColorSet.bg3Color,
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        children: [
          Gap(40),
          Image.asset('assets/images/logo.png', height: 40),
          Gap(8),
          Text(
            'Kumele',
            style: context.textTheme.heading1
                .copyWith(fontSize: 18.73, color: ColorSet.lightBlueColor),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              bloc: InjectionHelper.profileCubit,
              builder: (context, state) {
                return ProfilePic(
                  size: 60,
                  onPressed: () => InjectionHelper.homePageCubit
                      .onTapTab(context, HomeTabType.profile),
                  image: InjectionHelper.profileCubit.userData?.profilePicture,
                );
              },
            ),
          ),
        ],
      ),
      actions: [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
