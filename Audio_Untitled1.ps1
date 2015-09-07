Get-ChildItem "*.41000" | foreach {
    $n = $_.Name.IndexOf(".41000")
    $str = $_Name.SubString(0, $n) + ".ape"
    Rename-Item $_.Name $str
}
