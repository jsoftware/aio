# get windows AIO files into resources folder
#
# argument is set in aio.yml in the form: j904_win64[_slim].exe

$exe = $args[0]
$zip = $exe.Replace("exe","zip").Replace("_slim","")
$rel = $exe.Substring(0,4)
$rnum = $rel.Substring(1)
$bin = "resources\x64\bin"
$obin = ("-o" + $bin)
if ($rnum -eq "904") { $rname = ($rel + "-beta") }
else { echo ("not supported: " + $rel); exit }

$rver = ($rnum.Substring(0,1) + "." + $rnum.Substring(1,1) + "." + $rnum.Substring(2,1))

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

$url = ("www.jsoftware.com/download/" + $rel)

c:\msys64\usr\bin\wget ($url + "/installdev/" + $zip)
c:\msys64\usr\bin\wget ($url + "/qtide/" + $jqt)
c:\msys64\usr\bin\wget ($url + "/qtlib/" + $qtl)
c:\msys64\usr\bin\wget ($url + "/qtlib/opengl-win-x64.zip")
c:\msys64\usr\bin\wget ($url + "/qtlib/ssl-win-x64.zip")

cd ..

# unzip
7z x ("temp\" + $zip)
move $rel\* resources\x64

7z x temp\$jqt $obin
7z x temp\$qtl $obin
7z x temp\opengl-win-x64.zip $obin
7z x temp\ssl-win-x64.zip $obin

$url = ("www.jsoftware.com/download/jengine/" + $rname)

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
