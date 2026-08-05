import 'package:flutter/material.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/size.dart';

class CreateEventInterestCategoryItem extends StatelessWidget {
  const CreateEventInterestCategoryItem({
    super.key,
    required this.interest,
  });

  final InterestsModel interest;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: interest.isSelected
            ? const Color(0xFFFFC533)
            : ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(size(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          interest.buildIcon(
            color: interest.isSelected ? Colors.black : ColorSet.tileFontColor,
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              interest.title,
              textAlign: TextAlign.center,
              style: (interest.isSelected
                      ? context.textTheme.labelSmallBold
                      : context.textTheme.labelSmall)
                  .copyWith(
                fontSize: 10,
                color:
                    interest.isSelected ? Colors.black : ColorSet.tileFontColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
