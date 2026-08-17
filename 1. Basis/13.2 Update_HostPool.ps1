$galleryImageVersion = (
    Get-AzGalleryImageVersion `
        -ResourceGroupName "RG-AVD" `
        -GalleryName "AVD_GALLERY" `
        -GalleryImageDefinitionName "W11_CI" |
    Sort-Object PublishedDate |
    Select-Object -Last 1
).Name

Write-Host $galleryImageVersion

New-AzResourceGroupDeployment `
    -ResourceGroupName "RG-AVD" `
    -TemplateFile ".\10. avd - intune.bicep" `
    -galleryImageVersion $galleryImageVersion