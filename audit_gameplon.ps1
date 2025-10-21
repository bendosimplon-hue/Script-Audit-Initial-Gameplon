$freqgzh = Get-CimInstance win32_processor | Select-Object -Expand MaxClockSpeed
$pcinfo = Get-ComputerInfo
$gpu = Get-CimInstance Win32_VideoController
$disk = Get-PhysicalDisk

$infosPoste = [PSCustomObject]@{
    NomPoste = $env:COMPUTERNAME
    NomUtilisateur = $env:USERNAME
    DateDAudit = Get-date
    Typedewindows = $pcinfo.WindowsProductName
    Versiondewindows = (Get-ComputerInfo).OSDisplayVersion
    BuildSerialNumber = (GWMI -Class Win32_Bios).SerialNumber
    Numérodesériematériel = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID
    Processeur = (Get-CimInstance win32_processor).Name
    Fréquence = [Math]::Round($freqgzh / 1000, 2)
    Nbdecoeursphysiques = $pcinfo
    Nbdetrheatlogique = (Get-ComputerInfo).CsNumberOfLogicalProcessors
    Memoirevive = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
    TypedeRAM = (Get-CimInstance Win32_PhysicalMemory).PartNumber
    Cartegraphiqueprincipal = $gpu.Name
    VRAM = $gpu.AdapterRAM
    PiloteGraphique = $gpu.DriverVersion
    Nbdedisque = (@($disk)).Count
    Typededisque = $disk.MediaType
    Capacitétotale = $disk.Size
    Espacelibre = (Get-PSDrive).Free
    #AdresseMAC = 
    AdressIPlocal = (Get-NetIPAddress).IPAddress
    ConnectivitéWifi = (Get-NetAdapter).InterfaceDescription 
    #Bluetoothactivé = Get-PnpDevice
    TMPactivé = (Get-tpm).TpmEnabled
    Secureboot = Confirm-SecureBootUEFI
    Bitlockeractif = (Get-BitLockervolume).ProtectionStatus

    AntivirusActif = (Get-MpComputerStatus).AntivirusEnabled
    ParefeuActif = (Get-NetFirewallProfile).Enabled
    DernièreMAJWin = (New-Object -com "Microsoft.Update.AutoUpdate"). Results | fl
    UACactif = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA
    Browsers = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice').ProgId
    #BroswerVersion = 
    SteamVersion = (Get-Item "C:\Program Files (x86)\Steam\steam.exe").VersionInfo.ProductVersion
    OBSVersion = (Get-Item "C:\Program Files\obs-studio\bin\64bit\obs64.exe").VersionInfo.ProductVersion
    #
    #
    

}

$infosPoste | Export-Csv -Path "C:\Users\vboxuser\Desktop\Extract.csv" -NoTypeInformation -Encoding UTF8
