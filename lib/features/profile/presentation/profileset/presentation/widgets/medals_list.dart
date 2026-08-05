import 'package:flutter/material.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/medal_item_widget.dart';

class MedalsList extends StatelessWidget {
  final List<MedalsModel> medals;

  const MedalsList({
    super.key,
    required this.medals,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: medals.length,
      itemBuilder: (context, index) {
        return MedalItemWidget(medal: medals[index]);
      },
    );
  }
}
