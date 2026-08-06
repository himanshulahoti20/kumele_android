import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class TermsAndConditionsPageLayout extends StatelessWidget {
  const TermsAndConditionsPageLayout({
    super.key,
    this.title,
    this.content,
    this.onTabletBack,
    this.onWillPop,
  });

  final String? title;
  final String? content;
  final VoidCallback? onTabletBack;
  final Future<bool> Function()? onWillPop;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: ColorSet.bgColor,
      body: WidgetByDevice(
        tablet: _buildTablet(context),
        phone: Container(
          color: ColorSet.bg3Color,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  MobileHeader(label: AppStrings.termsAndConditions),
                  Gap(22),
                  Expanded(
                    child: SingleChildScrollView(
                      child: buildContent(context, title, content),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (onWillPop == null) {
      return scaffold;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await onWillPop!();
        if (shouldPop && context.mounted) context.pop();
      },
      child: scaffold,
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorSet.bg3Color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onTabletBack ?? () => context.pop(),
                    child: Image.asset(
                      IconSet.arrowleft,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Gap(40),
                  Text(
                    AppStrings.termsAndConditions,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.5, color: Colors.grey[200]),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: buildContent(context, title, content),
              ),
            ),
            Gap(20),
          ],
        ),
      ),
    );
  }

  static Column buildContent(
    BuildContext context, [
    String? title,
    String? content,
  ]) {
    final body = content?.trim();
    if (body != null && body.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20),
          Text(
            title?.trim().isNotEmpty == true
                ? title!.trim()
                : 'Kumele Terms of use',
            style: context.textTheme.bodyLarge,
          ),
          Gap(20),
          Text(
            body,
            style: context.textTheme.bodySmall.copyWith(fontSize: 13),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.justify,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(20),
        Text('Kumele Terms of use', style: context.textTheme.bodyLarge),
        Gap(20),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean eu fermentum augue, sit amet convallis augue. Integer eu iaculis sem, sed euismod eros. Nulla facilisi. Proin luctus odio nunc, sed laoreet est bibendum vitae. Sed a eleifend ex. Integer varius rhoncus euismod. Aliquam ac ultricies turpis, vitae eleifend ligula. Aliquam faucibus erat ut tincidunt cursus. Cras et ullamcorper velit. In hac habitasse platea dictumst. Nunc vitae dui quis risus elementum auctor.',
          style: context.textTheme.bodySmall.copyWith(fontSize: 13),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.justify,
        ),
        Gap(20),
        Text(
          'Maecenas quam nunc, sagittis non condimentum at, rutrum sit amet eros. Fusce rutrum, lectus in blandit sagittis, mi tortor ullamcorper mi, vitae vestibulum libero quam a nisi. In eu mauris et neque sodales porta eu eget dui. Nunc eu quam sit amet justo elementum mollis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed laoreet metus nulla, in gravida urna rhoncus in. Proin laoreet semper tortor ac posuere. Cras non leo at ipsum fringilla ullamcorper. Etiam velit est, tempor id lobortis eu, lacinia id sem. Nam ornare mattis dui a porta. Aliquam a ullamcorper velit, et hendrerit eros. Etiam accumsan porta neque in viverra. Proin eleifend, eros in tristique hendrerit, nisi purus cursus sapien, id ultrices nunc tellus a ipsum. Donec et fringilla neque. Aenean consequat purus quis lectus maximus fermentum.',
          style: context.textTheme.bodySmall.copyWith(fontSize: 13),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.justify,
        ),
        Gap(20),
        Text(
          'Sed laoreet metus nulla, in gravida urna rhoncus in. Proin laoreet semper tortor ac posuere. Cras non leo at ipsum fringilla ullamcorper. Etiam velit est, tempor id lobortis eu, lacinia id sem. Nam ornare mattis dui a porta. Aliquam a ullamcorper velit, et hendrerit eros. Etiam accumsan porta neque in viverra. Proin eleifend, eros in tristique hendrerit, nisi purus cursus sapien, id ultrices nunc tellus a ipsum. Donec et fringilla neque. Aenean consequat purus quis lectus maximus fermentum.',
          style: context.textTheme.bodySmall.copyWith(fontSize: 13),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
