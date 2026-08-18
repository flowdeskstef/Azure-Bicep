$imgvernew = Get-Date -Format "yyyy.MM.dd"

Invoke-AzResourceAction `
    -ResourceGroupName "RG-AVD" `
    -ResourceType "Microsoft.VirtualMachineImages/imageTemplates" `
    -ResourceName $imgvernew `
    -Action Run `
    -ApiVersion "2024-02-01" `
    -Force