chcp 65001 >nul

del images\*.png

xcopy "..\1C markdown\images" images

pandoc "..\1C markdown\sancity-docs\ОбновляторСкачивание!.md" -f markdown+wikilinks_title_after_pipe -s -o docs\download.html --self-contained --css=docs\style.css --resource-path=images

pandoc "..\1C markdown\sancity-docs\Демонстрация.md" -f markdown+wikilinks_title_after_pipe -s -o docs\index.html --self-contained --css=docs\style.css --resource-path=images 