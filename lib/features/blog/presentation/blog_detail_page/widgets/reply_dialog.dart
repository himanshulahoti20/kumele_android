import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';

class ReplyDialog extends StatefulWidget {
  const ReplyDialog({
    super.key,
    required this.comment,
    required this.onSubmit,
    this.isLoading = false,
  });

  final BlogCommentModel comment;
  final ValueChanged<String> onSubmit;
  final bool isLoading;

  @override
  State<ReplyDialog> createState() => ReplyDialogState();
}

class ReplyDialogState extends State<ReplyDialog> {
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTitledDialog(
      title:
          '${AppLocalizations.of(context)!.replyDialogTitlePrefix} ${widget.comment.author.displayName}',
      footer: AppButton.primary(
        label: AppLocalizations.of(context)!.publishComment,
        isLoading: widget.isLoading,
        onPressed: widget.isLoading
            ? null
            : () {
                final text = _replyController.text.trim();
                if (text.isNotEmpty) {
                  widget.onSubmit(text);
                }
              },
      ),
      child: KumeleTextArea(
        labelText: AppLocalizations.of(context)!.comment,
        controller: _replyController,
        hintText: AppLocalizations.of(context)!.replyDialogHint,
        maxLines: 6,
        minLines: 6,
      ),
    );
  }
}

void showReplyDialog({
  required BuildContext context,
  required BlogCommentModel comment,
  required ValueChanged<String> onSubmit,
}) {
  AppDialog.show(
    context: context,
    width: AppDialogSize.widthFor(context),
    dialog: BlocConsumer<BlogBloc, BlogState>(
      listenWhen: (previous, current) =>
          previous.isReplyingComment &&
          !current.isReplyingComment &&
          current.errorMessage == null,
      listener: (context, state) {
        context.pop();
      },
      builder: (context, state) {
        return ReplyDialog(
          key: const ValueKey('reply_dialog'),
          comment: comment,
          onSubmit: onSubmit,
          isLoading: state.isReplyingComment,
        );
      },
    ),
  );
}
