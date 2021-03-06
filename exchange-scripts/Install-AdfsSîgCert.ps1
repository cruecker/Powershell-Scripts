#copy the cert to the exchange Servers
$servers = "<servera>","<serverb>","<serverc>","<serverd>"
$pathtostore = "Cert:\LocalMachine\Root\"
$Thumbp = "<Thumbprint from cert to remove>"
$NewThumbp = "<Thumbprint from new cert to install>"

$PathToTheCertficate = "<local path on the remote servers including ther cer file>" #e.g "c:\Install\adfs-token-signing.cer"


foreach ($server in $servers){
    Invoke-Command -ComputerName $server -ScriptBlock {
                                                       Import-Certificate -FilePath “$using:PathToTheCertficate” -CertStoreLocation Cert:\LocalMachine\Root
                                                       Remove-Item -Path "$using:pathtostore$using:Thumbp"
                                                       }
}

foreach ($server in $servers){
    Invoke-Command -ComputerName $server -ScriptBlock {
                                                       Get-ChildItem -Path $using:pathtostore$using:NewThumbp
                                                       }
}


$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$server/PowerShell/ -Authentication Kerberos
Import-PSSession $Session -DisableNameChecking


Set-OrganizationConfig -ADFSSignCertificateThumbprint $NewThumbp

foreach ($server in $servers){
                              $Server
                              Write-Host "Restart IIS. Please stand by!"
                              Invoke-Command -ComputerName $server -ScriptBlock {
                                                                                 Stop-Service was -Force
                                                                                 Start-Service w3svc
                                                                                 }
                            }
