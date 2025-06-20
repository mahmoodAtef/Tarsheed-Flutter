import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/modules/settings/data/models/user.dart';
import 'package:tarsheed/src/modules/settings/data/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());
  int currentPageIndex = 0;
  int lastIndex = 0;
  bool isDarkMode = false;
  SettingsRepository settingsRepository = sl();

  static SettingsCubit get() {
    if (sl<SettingsCubit>().isClosed) {
      sl.unregister<SettingsCubit>();
      sl.registerLazySingleton<SettingsCubit>(() => SettingsCubit());
    } else if (!sl.isRegistered<SettingsCubit>()) {
      sl.registerLazySingleton<SettingsCubit>(() => SettingsCubit());
    }
    return sl<SettingsCubit>();
  }

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

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    emit(ChangeThemeSuccessState(isDarkMode: isDarkMode));
  }

  static SettingsCubit? _cubit;

  //  Save language and theme
  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    LocalizationManager.changeLanguage(json['languageCode'] ?? "en");
    isDarkMode = json['isDarkMode'] ?? false;

    // Return the last saved state with both language and theme
    return SettingsLoadedState(
      languageCode: json['languageCode'] ?? "en",
      isDarkMode: isDarkMode,
    );
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    if (state is ChangeLanguageSuccessState) {
      return {
        'languageCode': state.languageCode,
        'isDarkMode': isDarkMode,
      };
    } else if (state is ChangeThemeSuccessState) {
      return {
        'languageCode': LocalizationManager.getCurrentLocale().languageCode,
        'isDarkMode': state.isDarkMode,
      };
    } else if (state is SettingsLoadedState) {
      return {
        'languageCode': state.languageCode,
        'isDarkMode': state.isDarkMode,
      };
    }
    return null;
  }
}
