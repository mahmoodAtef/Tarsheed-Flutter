import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/modules/settings/data/models/user.dart';
import 'package:tarsheed/src/modules/settings/data/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());
  int currentPageIndex = 1;
  int lastIndex = 1;
  SettingsRepository settingsRepository = sl();

  void changeIndex(int index) {
    lastIndex = currentPageIndex;
    currentPageIndex = index;
    emit(SelectPageState(index));
  }

  void backToLastPage() {
    currentPageIndex = lastIndex;
    emit(SelectPageState(lastIndex));
  }

  Future<void> getProfile() async {
    emit(GetProfileLoadingState());
    final result = await settingsRepository.getProfile();
    result.fold((l) {
      emit(SettingsErrorState(exception: l));
    }, (r) {
      emit(GetProfileSuccessState(user: r));
    });
  }

  Future<void> updateProfile(User user) async {
    emit(UpdateProfileLoadingState());
    final result = await settingsRepository.updateProfile(user);
    result.fold((l) {
      emit(SettingsErrorState(exception: l));
    }, (r) {
      emit(UpdateProfileSuccessState(user: user));
    });
  }

  Future<void> deleteProfile() async {
    emit(DeleteProfileLoadingState());
    final result = await settingsRepository.deleteProfile();
    result.fold((l) {
      emit(SettingsErrorState(exception: l));
    }, (r) {
      emit(DeleteProfileSuccessState());
    });
  }

  Future<void> changeLanguage(String languageCode) async {
    await LocalizationManager.changeLanguage(languageCode);
    emit(ChangeLanguageSuccessState(
        languageCode: LocalizationManager.getCurrentLocale().languageCode));
  }

  static SettingsCubit? _cubit;

  static SettingsCubit get getInstance => _cubit ??= sl();
  //  Save language
  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    LocalizationManager.changeLanguage(json['languageCode'] ?? "en");
    return ChangeLanguageSuccessState(
      languageCode: json['languageCode'] ?? "en",
    );
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    if (state is ChangeLanguageSuccessState) {
      return {
        'languageCode': state.languageCode,
      };
    }
    return null;
  }
}
