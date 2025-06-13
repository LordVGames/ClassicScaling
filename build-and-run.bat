set thunderstoreName=LordVGames-ClassicScaling
set profilePluginsFolder=F:\Various Caches 2\Gale\Data\risk-of-rain-returns\profiles\testing\ReturnOfModding\plugins\

start /wait taskkill /f /im "Risk of Rain Returns.exe"

if not exist "%profilePluginsFolder%%thunderstoreName%" (
    mkdir "%profilePluginsFolder%%thunderstoreName%"
)

copy /y "%~dp0*.lua" "%profilePluginsFolder%%thunderstoreName%"
copy /y "%~dp0manifest.json" "%profilePluginsFolder%%thunderstoreName%"

"C:\Program Files\7-Zip\7z.exe" a -tzip "%thunderstoreName%.zip" "%~dp0*" -xr!.vscode -xr!.git -x!*.zip -x!*.bat -x!*.pdn -x!LICENSE

rem pause
rem start "" "C:\\Program Files (x86)\\Steam\\steam.exe" "-applaunch" "1337520" "--rom_modding_root_folder" "F:\\Various Caches 2\\Gale\\Data\\risk-of-rain-returns\\profiles\\testing"