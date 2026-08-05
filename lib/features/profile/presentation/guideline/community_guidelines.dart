import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/profile/presentation/guideline/guideline_config.dart';
import 'package:kuemele/features/profile/presentation/guideline/widgets/guideline_knowledge_base.dart';
import 'package:kuemele/features/profile/presentation/guideline/widgets/guideline_legal_content.dart';
import 'package:kuemele/features/profile/presentation/guideline/widgets/guideline_page_layout.dart';
import 'package:kuemele/features/profile/presentation/guideline/widgets/guideline_placeholder.dart';
import 'package:kuemele/features/profile/presentation/guideline/widgets/guideline_tab_bar.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/models/legal_document.dart';
import 'package:kuemele/shared/services/api_service/legal/legal_repo.dart';

class CommunityGuideLines extends StatefulWidget implements BasePage {
  const CommunityGuideLines({super.key, this.selectedTab});

  final String? selectedTab;

  @override
  State<CommunityGuideLines> createState() => _CommunityGuideLinesState();

  @override
  String get screenName => 'CommunityGuideLines';
}

class _CommunityGuideLinesState extends State<CommunityGuideLines> {
  late GuidelineTab _selectedTab;
  bool _isLoadingGuidelines = false;
  String? _guidelinesError;
  LegalDocument? _guidelinesDocument;

  @override
  void initState() {
    super.initState();
    _selectedTab = GuidelineTab.fromLabel(widget.selectedTab);
    _loadGuidelines();
  }

  Future<void> _loadGuidelines() async {
    setState(() {
      _isLoadingGuidelines = true;
      _guidelinesError = null;
    });

    try {
      final document = await LegalRepo.getLegalDocumentByType(
        LegalDocumentType.guidelines,
      );
      if (!mounted) return;
      setState(() {
        _guidelinesDocument = document;
        _isLoadingGuidelines = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _guidelinesError = GuidelineConfig.guidelinesErrorMessage;
        _isLoadingGuidelines = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GuidelinePageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          GuidelineTabBar(
            selectedTab: _selectedTab,
            onTabSelected: (tab) => setState(() => _selectedTab = tab),
          ),
          const Gap(20),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return switch (_selectedTab) {
      GuidelineTab.communityGuidelines => GuidelineLegalContent(
          isLoading: _isLoadingGuidelines,
          errorMessage: _guidelinesError,
          document: _guidelinesDocument,
          emptyMessage: GuidelineConfig.guidelinesEmptyMessage,
        ),
      GuidelineTab.howTo => const GuidelinePlaceholder(
          message: GuidelineConfig.howToPlaceholder,
        ),
      GuidelineTab.popular => const GuidelinePlaceholder(
          message: GuidelineConfig.popularPlaceholder,
        ),
      GuidelineTab.knowledgeBase => const GuidelineKnowledgeBase(),
    };
  }
}
