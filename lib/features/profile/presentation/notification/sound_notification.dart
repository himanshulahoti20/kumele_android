import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/components/switch.dart';

class SoundNotification extends StatefulWidget implements BasePage {
  const SoundNotification({super.key});

  @override
  State<SoundNotification> createState() => _SoundNotificationState();

  @override
  String get screenName => 'SoundNotification';
}

class _SoundNotificationState extends State<SoundNotification> {
  UserNotification? get userNotification =>
      InjectionHelper.profileCubit.userNotification;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: InjectionHelper.profileCubit,
      builder: (context, state) {
        return WidgetByDevice(
          tablet: buildTablet(),
          phone: Scaffold(
            backgroundColor: ColorSet.bg3Color,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    MobileHeader(label: 'Notifications'),
                    Gap(22),
                    Expanded(
                      child: SingleChildScrollView(child: buildContent()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTablet() {
    return AppTitledDialog(
      title: 'Notifications',
      child: buildContent(),
    );
  }

  Widget buildContent() {
    final soundNotification = userNotification?.soundNotifications ?? false;
    final emailNotifications = userNotification?.emailNotifications ?? false;
    return Column(
      children: [
        ListTile(
          onTap: () => InjectionHelper.profileCubit
              .updateUserNotification(soundNotifications: !soundNotification),
          title: Text(
            'Turn on Sound notification',
            style: context.textTheme.titleLarge.copyWith(fontSize: 21),
          ),
          trailing: RASwitch(
            value: soundNotification,
            onTap: () => InjectionHelper.profileCubit
                .updateUserNotification(soundNotifications: !soundNotification),
            size: Size(25, 18),
          ),
        ),
        Divider(color: ColorSet.bgColor, indent: sizeW(9), endIndent: sizeW(9)),
        ListTile(
          onTap: () => InjectionHelper.profileCubit
              .updateUserNotification(emailNotifications: !emailNotifications),
          title: Text(
            'E-Mail notifications',
            style: context.textTheme.titleLarge.copyWith(fontSize: 21),
          ),
          trailing: RASwitch(
            value: emailNotifications,
            onTap: () => InjectionHelper.profileCubit.updateUserNotification(
                emailNotifications: !emailNotifications),
            size: Size(25, 18),
          ),
        ),
        Divider(color: ColorSet.bgColor, indent: sizeW(9), endIndent: sizeW(9)),
      ],
    );
  }

  //
}
