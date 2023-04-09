# get windows AIO files into resources folder
#
# argument 0=full, 1=slim

# e.g. 9.4.0-beta13
$ver = Get-Content -Path "revision.txt" -Raw

# get major, minor, revision numbers:
$t = $ver.Split(".")
$maj = $t[0]
$min = $t[1]
$rev = $t[2].Split("-")[0]

$rnum = ($maj + "." + $min)
$rver = ($rnum + "." + $rev)
$rel = ("j" + $rnum)
$zip = ($rel + "_win64.zip")

$bin = "resources\x64\bin"
$obin = ("-o" + $bin)

if ($args -eq 1) {
  $slim = "_slim"
  $jqt = "jqt-win-slim.zip"
  $qtl = "qt62-win-slim-x64.zip"
}
else {
  $slim = ""
  $jqt = "jqt-win.zip"
  $qtl = "qt62-win-x64.zip"
}

echo ("ver = " + $ver)
echo ("args = " + $args)
echo ("rnum = " + $rnum)
echo ("rver = " + $rver)
echo ("rel = " + $rel)
echo ("zip = " + $zip)

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
Invoke-WebRequest -UseBasicParsing ($url + "/install/" + $zip) -outfile $zip
Invoke-WebRequest -UseBasicParsing ($url + "/qtide/" + $jqt) -outfile $jqt
Invoke-WebRequest -UseBasicParsing ($url + "/qtlib/" + $qtl) -outfile $qtl
cd ..

# unzip
7z x ("temp\" + $zip)
move $rel\* resources\x64

function ferase ($a) { if (Test-Path "$a") { Remove-Item "$a" } }

7z x temp\$jqt $obin
ferase $obin\qt.exp
ferase $obin\qt.lib
7z x temp\$qtl $obin

cd resources\je
$url = ("www.jsoftware.com/download/jengine/" + $rel + "/windows/j64/")
Invoke-WebRequest -UseBasicParsing ($url + "javx2.dll") -outfile "javx2.dll"
cd ..\..

dir resources
dir resources\x64
dir resources\x64\bin
dir resources\je
