# get windows AIO files into resources folder
#
# argument is set in aio.yml in the form: j9.4_win64[_slim].exe 1

$exe = $args[0]
$t = $args[1].ToString().Split(".")
$rev = $t[0]
$beta = $t[1]

if (($rev -eq 0) -and ($beta.length -eq 0)) {
  echo "beta number required for revision 0"
  exit 0
}

if (($rev -gt 0) -and ($beta.length -gt 0)) {
  echo ("beta number should not be given revision " + $rev)
  exit 0
}

# get major, minor numbers:
$t = $exe.Substring(1).Split(".")
$maj = $t[0]
$min = $t[1].Split("_")[0]
$rnum = ($maj + "." + $min)
$rel = ("j" + $rnum)
$zip = ($rel + "_win64.zip")

$rver = ($rnum + "." + $rev)

if ($rev -gt 0) {  $fullver = $rver }
else { $fullver = ($rver + "-beta" + $beta) }

echo ("args = " + $args)
echo ("rnum = " + $rnum)
echo ("rel = " + $rel)
echo ("zip = " + $zip)
echo ("fullver = " + $fullver)

echo $fullver > revision.txt

# exit 0

$bin = "resources\x64\bin"
$obin = ("-o" + $bin)

if ($exe -eq "slim") {
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

c:\msys64\usr\bin\wget ($url + "/install/" + $zip)
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
