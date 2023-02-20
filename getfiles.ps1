# get windows AIO files into resources folder
#
# argument is set in aio.yml in the form: j9.4.1_win64[_slim].exe

$exe = $args[0]
$zip = $exe.Replace("exe","zip").Replace("_slim","")

# get major, minor, revision numbers:
$t = $exe.Substring(1).split("._")
$maj = $t[0]
$min = $t[1]
$rev = $t[2]
$rnum = ($maj + "." + $min)
$rver = ($rnum + "." + $rev)

$bin = "resources\x64\bin"
$obin = ("-o" + $bin)

if ($exe -match "slim") {
  $slim = "_slim"
  $jqt = "jqt-winslim-x64.zip"
  $qtl = "qt62-win-slim-x64.zip"
}
else {
  $slim = ""
  $jqt = "jqt-win-x64.zip"
  $qtl = "qt62-win-x64.zip"
}
$ini = "install.nsi"
((Get-Content -path $ini -Raw) -replace 'XXX',$rnum) | Set-Content -path $ini
((Get-Content -path $ini -Raw) -replace 'YYY',$rver) | Set-Content -path $ini
((Get-Content -path $ini -Raw) -replace 'ZZZ',$slim) | Set-Content -path $ini

$pfn = "c:\program files (x86)\nsis\"
cp CPUFeatures.dll ($pfn + "plugins\x86-unicode")
cp CPUFeatures.nsh ($pfn + "include")

mkdir temp
mkdir resources\je

cd temp

$url = ("www.jsoftware.com/download/j" + $rnum)

c:\msys64\usr\bin\wget ($url + "/installdev/" + $zip)
c:\msys64\usr\bin\wget ($url + "/qtide/" + $jqt)
c:\msys64\usr\bin\wget ($url + "/qtlib/" + $qtl)

cd ..

# unzip
7z x ("temp\" + $zip)
move $rel\* resources\x64

7z x temp\$jqt $obin
7z x temp\$qtl $obin
7z x temp\opengl-win-x64.zip $obin

$url = ("www.jsoftware.com/download/jengine/j" + $rnum)

cd resources\je
c:\msys64\usr\bin\wget ($url + "/windows/j64/javx.dll")
c:\msys64\usr\bin\wget ($url + "/windows/j64/javx2.dll")
cd ..\..

dir resources
dir resources\x64
dir resources\x64\bin
dir resources\je

# nsis should build this file
# echo "hello" >> $exe
