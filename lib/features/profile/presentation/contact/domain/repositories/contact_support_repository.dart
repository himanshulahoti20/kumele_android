import 'package:kuemele/features/profile/presentation/contact/domain/entities/create_support_ticket_request.dart';

abstract class ContactSupportRepository {
  Future<String?> createTicket(CreateSupportTicketRequest request);

  Future<String> uploadAttachment(String filePath);
}
