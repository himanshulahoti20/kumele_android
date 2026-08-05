import 'package:flutter/material.dart';
import 'package:kuemele/features/discover/cubit/create_event_cubit.dart';

class CreateEventFormControllers {
  CreateEventFormControllers._({
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final TextEditingController title;
  final TextEditingController subtitle;
  final TextEditingController description;

  factory CreateEventFormControllers.bind(CreateEventCubit cubit) {
    final state = cubit.state;

    final title = TextEditingController(text: state.title);
    final subtitle = TextEditingController(text: state.subtitle);
    final description = TextEditingController(text: state.description);

    title.addListener(() => cubit.updateTitle(title.text));
    subtitle.addListener(() => cubit.updateSubtitle(subtitle.text));
    description.addListener(() => cubit.updateDescription(description.text));

    return CreateEventFormControllers._(
      title: title,
      subtitle: subtitle,
      description: description,
    );
  }

  void dispose() {
    title.dispose();
    subtitle.dispose();
    description.dispose();
  }
}
