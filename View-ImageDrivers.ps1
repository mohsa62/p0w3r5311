function View-ImageDrivers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=1)]
            [string]$ImageFile
    )

    $IMGidxContent = Get-WindowsImage -ImagePath $ImageFile
    if ($IMGidxContent.count -gt 1) {
        $IMGidxContent |
            Format-Table @{ Label = "Index"; expression = {$_.ImageIndex}; Alignment = "left"},
                         @{ Label = "Name"; expression = {$_.ImageName}},
                         @{ Label = "Description"; expression = {$_.ImageDescription}},
                         @{ Label = "Size"; expression = {$_.ImageSize}} -autosize
        $idxNumber = Read-Host -Prompt "which index do you choose"
    }
    else {
        $idxNumber = 1
    }
    Remove-Variable IMGidxContent
    New-Item -Path c:\tempwinimage -ItemType directory
    Mount-WindowsImage -Path c:\tempwinimage -ImagePath $ImageFile -Index $idxNumber
    Get-WindowsDriver -Path c:\tempwinimage |
        sort -Property Date |
        Format-Table -Property Driver,ClassDescription,ProviderName,Version,Date -AutoSize
    $doneans = Read-Host -Prompt "Are you done?[Y or N]"
    if ($doneans -eq "y") {
        Dismount-WindowsImage -Path c:\tempwinimage -Discard
        del c:\tempwinimage
    }
    elseif ($doneans -eq "n") {
        
    }
    else {
        Write-Host "asshole"
    }
}
