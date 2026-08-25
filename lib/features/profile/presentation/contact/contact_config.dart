enum SupportTicketCategory {
  payment('payment', 'Payment'),
  account('account', 'Account'),
  technical('technical', 'Technical'),
  featureRequest('feature_request', 'Feature request'),
  reportContent('report_content', 'Report content'),
  other('other', 'Other');

  const SupportTicketCategory(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

enum SupportTicketPriority {
  low('low', 'Low'),
  medium('medium', 'Medium'),
  high('high', 'High');

  const SupportTicketPriority(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

enum ContactReason {
  business('Business', SupportTicketCategory.other),
  complaint('Complaint', SupportTicketCategory.reportContent),
  improvement('Improvement', SupportTicketCategory.featureRequest);

  const ContactReason(this.label, this.category);

  final String label;
  final SupportTicketCategory category;
}
