$imgvernew = Get-Date -Format "yyyy.MM.dd"

Write-Host "Nieuwe image: $imgvernew"

New-AzResourceGroupDeployment `
    -ResourceGroupName "RG-AVD" `
    -TemplateFile "09. custom image template.bicep" `
    -imgvernew $imgvernew