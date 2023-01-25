# get windows AIO files into resources folder

$exe = $args[0]
$zip = $exe.Replace("exe","zip")
$rel = $exe.Substring(0,4)
$bin = "resources\x64\bin"
$obin = ("-o" + $bin)

mkdir temp
mkdir resources\je
mkdir resources\x64

cd temp

$url = "www.jsoftware.com/download/"

c:\msys64\usr\bin\wget ($url + $rel + "/install/" + $zip)
c:\msys64\usr\bin\wget ($url + $rel + "/qtide/jqt-win-x64.zip")
c:\msys64\usr\bin\wget ($url + $rel + "/qtlib/qt62-win-x64.zip")
c:\msys64\usr\bin\wget ($url + $rel + "/qtlib/opengl-win-x64.zip")

cd ..

# unzip
7z x ("temp\" + $zip)
move $rel\* resources\x64

7z x temp\jqt-win-x64.zip $obin
7z x temp\qt62-win-x64.zip $obin
7z x temp\opengl-win-x64.zip $obin

$url = "www.jsoftware.com/download/jengine/"

cd resources\je
c:\msys64\usr\bin\wget ($url + $rel + "-beta/windows/j64/javx.dll")
c:\msys64\usr\bin\wget ($url + $rel + "-beta/windows/j64/javx2.dll")
cd ..\..

dir resources
dir resources\x64
dir resources\je

# nsis should build this file
echo "hello" >> $exe
