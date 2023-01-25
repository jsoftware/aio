# get windows AIO files into folder e.g. j904

$exe = $args[0]
$zip = $exe.Replace("exe","zip")
$rel = $exe.Substring(0,4)
$bin = ($rel + "\bin")
$obin = ("-o" + $bin)

mkdir temp
cd temp

c:\msys64\usr\bin\wget ("www.jsoftware.com/download/" + $rel + "/install/" + $zip)
c:\msys64\usr\bin\wget ("www.jsoftware.com/download/" + $rel + "/qtide/jqt-win-x64.zip")
c:\msys64\usr\bin\wget ("www.jsoftware.com/download/" + $rel + "/qtlib/qt62-win-x64.zip")
c:\msys64\usr\bin\wget ("www.jsoftware.com/download/" + $rel + "/qtlib/opengl-win-x64.zip")

cd ..

# this creates the J folder
7z x ("temp\" + $zip)
7z x temp\jqt-win-x64.zip $obin
7z x temp\qt62-win-x64.zip $obin
7z x temp\opengl-win-x64.zip $obin

dir $rel
dir $bin

# nsis should build this file
echo "hello" >> $exe
