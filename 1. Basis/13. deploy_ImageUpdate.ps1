$imgverold = (
    Get-AzGalleryImageVersion `
        -ResourceGroupName "RG-AVD" `
        -GalleryName "AVD_GALLERY" `
        -GalleryImageDefinitionName "WIN11_24H2" |
    Sort-Object PublishedDate |
    Select-Object -Last 1
).Name

$imgvernew = Get-Date -Format "yyyy.MM.dd"

Write-Host "Bron image : $imgverold"
Write-Host "Nieuwe image: $imgvernew"

New-AzResourceGroupDeployment `
    -ResourceGroupName "RG-AVD" `
    -TemplateFile "13. update image.bicep" `
    -imgverold $imgverold `
    -imgvernew $imgvernew