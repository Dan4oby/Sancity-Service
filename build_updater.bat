chcp 65001 >nul

cd /d ..\dotnet-projects\
cd Sancity-Updater\
call .\build.bat

git add .

git commit -m "Обновление программ"

git pull origin main --no-rebase

git push origin main
