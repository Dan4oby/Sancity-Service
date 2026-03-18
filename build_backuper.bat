chcp 65001 >nul

cd /d ..\dotnet-projects\
cd Sancity-Backuper\
call .\build.bat

cd ..\..\

cd .\Sancity-Service

git add .

git commit -m "Обновление программ"

git pull origin main --no-rebase

git push origin main
