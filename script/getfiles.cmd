@rem get windows AIO files into folder j904

mkdir temp
cd temp

c:\msys64\usr\bin\wget www.jsoftware.com/download/j904/install/j904_win64.zip
c:\msys64\usr\bin\wget www.jsoftware.com/download/j904/qtide/jqt-win-x64.zip
c:\msys64\usr\bin\wget www.jsoftware.com/download/j904/qtlib/qt62-win-x64.zip
c:\msys64\usr\bin\wget www.jsoftware.com/download/j904/qtlib/opengl-win-x64.zip

cd ..

@rem this creates the j904 folder
7z x temp\j904_win64.zip

7z x temp\jqt-win-x64.zip -oj904\bin
7z x temp\qt62-win-x64.zip -oj904\bin
7z x temp\opengl-win-x64.zip -oj904\bin

dir j904
dir j904\bin

@rem nsis should build this file
echo "hello" >> j904_win64.zip
