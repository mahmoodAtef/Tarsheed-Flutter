class SecuritySettings {
  final bool isBiometricEnabled;
  final bool isPinEnabled;
  final String? pinCode;
  SecuritySettings(
      {required this.isBiometricEnabled,
      required this.isPinEnabled,
      this.pinCode});

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      pinCode: json['pinCode'],
      isBiometricEnabled: json['isBiometricEnabled'],
      isPinEnabled: json['isPinEnabled'],
    );
  }
  Map<String, dynamic> toJson() => {
        'isBiometricEnabled': isBiometricEnabled,
        'isPinEnabled': isPinEnabled,
        'pinCode': pinCode
      };
}
