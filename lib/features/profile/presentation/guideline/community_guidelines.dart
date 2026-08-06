import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/profile/presentation/guideline/guideline_config.dart';
import 'package:kuemele/features/profile/presentation/guideline/widgets/guideline_knowledge_base.dart';
import 'package:kuemele/features/profile/presentation/guideline/widgets/guideline_legal_content.dart';
import 'package:kuemele/features/profile/presentation/guideline/widgets/guideline_page_layout.dart';
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
  final _loadingTabs = <GuidelineTab>{};
  final _tabErrors = <GuidelineTab, String>{};
  final _documents = <GuidelineTab, LegalDocument?>{};

  @override
  void initState() {
    super.initState();
    _selectedTab = GuidelineTab.fromLabel(widget.selectedTab);
    _loadLegalTab(_selectedTab);
  }

  Future<void> _loadLegalTab(GuidelineTab tab) async {
    final type = _legalTypeFor(tab);
    if (type == null || _documents.containsKey(tab)) return;

    setState(() {
      _loadingTabs.add(tab);
      _tabErrors.remove(tab);
    });

    try {
      final document = await LegalRepo.getLegalDocumentByType(type);
      if (!mounted) return;
      setState(() {
        _documents[tab] = document;
        _loadingTabs.remove(tab);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _tabErrors[tab] = GuidelineConfig.guidelinesErrorMessage;
        _loadingTabs.remove(tab);
      });
    }
  }

  LegalDocumentType? _legalTypeFor(GuidelineTab tab) {
    return switch (tab) {
      GuidelineTab.communityGuidelines => LegalDocumentType.guidelines,
      GuidelineTab.howTo => LegalDocumentType.howTo,
      GuidelineTab.popular => LegalDocumentType.popular,
      GuidelineTab.knowledgeBase => null,
    };
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
            onTabSelected: (tab) {
              setState(() => _selectedTab = tab);
              _loadLegalTab(tab);
            },
          ),
          const Gap(20),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return switch (_selectedTab) {
      GuidelineTab.communityGuidelines ||
      GuidelineTab.howTo ||
      GuidelineTab.popular =>
        GuidelineLegalContent(
          isLoading: _loadingTabs.contains(_selectedTab),
          errorMessage: _tabErrors[_selectedTab],
          document: _documents[_selectedTab],
          emptyMessage: GuidelineConfig.guidelinesEmptyMessage,
        ),
      GuidelineTab.knowledgeBase => const GuidelineKnowledgeBase(),
    };
  }
}
