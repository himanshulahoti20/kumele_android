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
