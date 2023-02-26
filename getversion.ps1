# get info from version.txt for github actions

$dat = Get-Content("version.txt")
$rev =

Foreach ($f in Get-Content("version.txt")) {
  $f = $f.Trim()
  if ( ($f.length -gt 0) -and ($f.SubString(0,2) -ne "//") ) {
    $rev = $f
    break
  }
}

if ($rev.length -eq 0) {
  echo "invalid version.txt"
  return
}

$t = $rev.Split(".")
$maj = $t[0]
$min = $t[1]
$num = ($maj + "." + $min)

$tgt = ("j" + $num + "_win64.exe")
$tgts = ("j" + $num + "_win64_slim.exe")

Set-Content -NoNewline -Path 'revision.txt' -Value $rev
Set-Content -NoNewline -Path 'target.txt' -Value $tgt
Set-Content -NoNewline -Path 'targets.txt' -Value $tgts
