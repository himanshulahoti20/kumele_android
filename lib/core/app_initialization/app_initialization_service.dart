import 'dart:async';

import 'package:kuemele/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_bloc.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/notification_service.dart';

class AppInitializationService {
  AppInitializationService({
    required ProfileCubit profileCubit,
    required ProfilePageBloc profilePageBloc,
    required BlogBloc blogBloc,
  })  : _profileCubit = profileCubit,
        _profilePageBloc = profilePageBloc,
        _blogBloc = blogBloc;

  final ProfileCubit _profileCubit;
  final ProfilePageBloc _profilePageBloc;
  final BlogBloc _blogBloc;

  Future<void> initializeApp() async {
    await NotificationService.initialize();

    await _profileCubit.loadLanguages();
    _profilePageBloc.add(const ProfilePageInit());
    _blogBloc.add(const BlogInit());

    if (ApiService.hasToken()) {
      await initializeAuthenticatedSession();
    } else {
      unawaited(_profileCubit.loadEventCategories());
    }
  }

  Future<void> initializeAuthenticatedSession() async {
    await _profileCubit.loadAuthenticatedSession();
    _profilePageBloc.add(const ProfilePageRefresh());
    await NotificationService.sendFirebaseTokenToBackend();
  }

  Future<void> refreshUserSession() async {
    await _profileCubit.refreshUserSession();
    _profilePageBloc.add(const ProfilePageRefresh());
  }
}
