chcp 65001 >nul

cd /d ..\dotnet-projects\
cd Sancity-Backuper\
call .\build.bat

cd ..
cd Sancity-Updater\
call .\build.bat

