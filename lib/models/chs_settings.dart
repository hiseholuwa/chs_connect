class ChsSettingsModel {
  final String versionName;

  ChsSettingsModel({
    this.versionName
  });

  ChsSettingsModel.fromJson(Map<String, dynamic> json)
      : assert(json != null),
        versionName = json['versionName'];

}