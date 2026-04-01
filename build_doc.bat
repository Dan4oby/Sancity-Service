chcp 65001 >nul

del images\*.png

xcopy "..\1C markdown\images" images

pandoc "..\1C markdown\ОбновляторИнформация!.md" -f markdown+wikilinks_title_after_pipe -s -o docs\ОбновляторИнформация.html --self-contained --css=docs\style.css --resource-path=images

pandoc "..\1C markdown\ОбновляторДемонстрация.md" -f markdown+wikilinks_title_after_pipe -s -o docs\ОбновляторДемонстрация.html --self-contained --resource-path=images 