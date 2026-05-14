[Setup]
AppName=WeatherApp
AppVersion=1.0
DefaultDirName={pf}\WeatherApp
OutputDir=.\Installer
OutputBaseFilename=WeatherApp_Setup

[Files]
Source: "..\build-release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\WeatherApp"; Filename: "{app}\WeatherApp.exe"
Name: "{commondesktop}\WeatherApp"; Filename: "{app}\WeatherApp.exe"

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "WeatherApp"; ValueData: "{app}\WeatherApp.exe -hidden"

[UninstallDelete]
Type: files; Name: "{localappdata}\WeatherApp\weather_cache.json"
Type: files; Name: "{localappdata}\EnterpriseCorp\WeatherApp\weather_cache.json"
