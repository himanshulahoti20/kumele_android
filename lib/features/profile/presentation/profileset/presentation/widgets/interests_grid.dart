import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/interested_hobbies_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/interest_item_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InterestsGrid extends StatelessWidget {
  static const maxSelections = 5;

  final List<HobbyInterest> interests;
  final List<String> selectedIds;
  final bool isLoading;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const InterestsGrid({
    super.key,
    required this.interests,
    required this.selectedIds,
    required this.isLoading,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final crossAxisCount = responsive.isTablet ? 6 : 3;
    final displayInterests =
        isLoading ? _placeholderInterests(crossAxisCount) : interests;
    final selectedCount = selectedIds.length;

    return Skeletonizer(
      enabled: isLoading,
      child: GridView.builder(
        shrinkWrap: shrinkWrap,
        physics: physics ?? const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.w,
          childAspectRatio: responsive.isTablet ? 1.08 : 1,
        ),
        itemCount: displayInterests.length,
        itemBuilder: (context, index) {
          final interest = displayInterests[index];
          final isSelected = selectedIds.contains(interest.id);
          final isDisabled =
              !isLoading && !isSelected && selectedCount >= maxSelections;

          return InterestItemWidget(
            interest: interest,
            isSelected: isSelected,
            disabled: isDisabled,
            onTap: isLoading
                ? null
                : () {
                    context.read<InterestedHobbiesBloc>().add(
                          InterestedHobbiesInterestToggled(interest.id),
                        );
                  },
          );
        },
      ),
    );
  }

  List<HobbyInterest> _placeholderInterests(int crossAxisCount) {
    return List.generate(
      crossAxisCount * 7,
      (index) => HobbyInterest(
        id: 'placeholder-$index',
        categoryId: 'placeholder-category',
        name: 'Interest placeholder',
        slug: 'placeholder',
      ),
    );
  }
}
