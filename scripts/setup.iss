[Setup]
AppName=Nimbus
AppVersion=1.0
DefaultDirName={pf}\Nimbus
OutputDir=.\Installer
OutputBaseFilename=Nimbus_Setup

[Files]
Source: "..\build-release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Nimbus"; Filename: "{app}\Nimbus.exe"
Name: "{commondesktop}\Nimbus"; Filename: "{app}\Nimbus.exe"

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "Nimbus"; ValueData: "{app}\Nimbus.exe -hidden"

[UninstallDelete]
Type: files; Name: "{localappdata}\Nimbus\weather_cache.json"
Type: files; Name: "{localappdata}\EnterpriseCorp\Nimbus\weather_cache.json"
