part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
}

final class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsErrorState extends SettingsState {
  final Exception exception;
  const SettingsErrorState({required this.exception});
  @override
  List<Object> get props => [exception];
}

final class GetProfileLoadingState extends SettingsState {
  @override
  List<Object> get props => [];
}

final class GetProfileSuccessState extends SettingsState {
  final User user;
  const GetProfileSuccessState({required this.user});
  @override
  List<Object> get props => [user];
}

final class UpdateProfileLoadingState extends SettingsState {
  @override
  List<Object> get props => [];
}

final class UpdateProfileSuccessState extends SettingsState {
  final User user;
  const UpdateProfileSuccessState({required this.user});
  @override
  List<Object> get props => [];
}

final class DeleteProfileLoadingState extends SettingsState {
  @override
  List<Object> get props => [];
}

final class DeleteProfileSuccessState extends SettingsState {
  @override
  List<Object> get props => [];
}

final class ChangeLanguageSuccessState extends SettingsState {
  final String languageCode;
  const ChangeLanguageSuccessState({required this.languageCode});
  @override
  List<Object> get props => [languageCode];
}

final class SelectPageState extends SettingsState {
  final int index;

  const SelectPageState(this.index);
  @override
  List<Object?> get props => [index];
}

class ChangeThemeSuccessState extends SettingsState {
  final bool isDarkMode;
  const ChangeThemeSuccessState({required this.isDarkMode});

  @override
  List<Object> get props => [isDarkMode];
}

class SettingsLoadedState extends SettingsState {
  final String languageCode;
  final bool isDarkMode;
  const SettingsLoadedState({
    required this.languageCode,
    required this.isDarkMode,
  });

  @override
  List<Object> get props => [languageCode, isDarkMode];
}
