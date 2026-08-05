import 'package:kuemele/features/profile/presentation/contact/domain/entities/create_support_ticket_request.dart';
import 'package:kuemele/features/profile/presentation/contact/domain/repositories/contact_support_repository.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';

class ContactSupportRepositoryImpl implements ContactSupportRepository {
  @override
  Future<String?> createTicket(CreateSupportTicketRequest request) {
    return ProfileRepo.createSupportTicket(body: request.toJson());
  }

  @override
  Future<String> uploadAttachment(String filePath) {
    return ProfileRepo.uploadProfileImage(filePath);
  }
}
