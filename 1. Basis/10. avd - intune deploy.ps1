$imgvernew = Get-Date -Format "yyyy.MM.dd"

Write-Host "Nieuwe image: $imgvernew"

New-AzResourceGroupDeployment `
    -ResourceGroupName "RG-AVD" `
    -TemplateFile "10. avd - intune.bicep" `
    -galleryImageVersion $imgvernew