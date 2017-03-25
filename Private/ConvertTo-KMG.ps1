filter ConvertTo-KMG {
    $bytecount = $_
	
    switch ([math]::truncate([math]::log($bytecount,1024))) 
    {
        0 {"$bytecount Bytes"}
        1 {"{0:n2} KB" -f ($bytecount / 1KB)}
        2 {"{0:n2} MB" -f ($bytecount / 1MB)}
        3 {"{0:n2} GB" -f ($bytecount / 1GB)}
        4 {"{0:n2} TB" -f ($bytecount / 1PB)}
        Default {"{0:n2} PB" -f ($bytecount / 1PB)}
    }
}