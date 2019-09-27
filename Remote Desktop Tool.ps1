Function CheckComputer {
$global:CompExists = $null

#CHANGED
$Connectivity = $(try {Test-Connection -ComputerName $CNText.Text -Count 1 -Quiet} catch {$null})
if ($Connectivity -eq $true) 
{
    $Details.SelectionColor = 'Green'
    $global:CompExists = $true
    # CHANGED
    return 'Online'

    } else {
    $Details.SelectionColor = 'Red'
    $global:CompExists = $false   
    # CHANGED       
    return 'Offline'
    }
}

Function CheckUser{
Import-Module ActiveDirectory
$global:UserExists = $null
$User = $(try { Get-ADUser $SNText.Text -Properties *} catch {$null})
$CheckUser = $User
If ($CheckUser -ne $null)
{
    $Details.SelectionColor = 'Green'
    $global:UserExists = $true

    # CHANGED
    return $User.DisplayName
    #$Details.Text = $UserExists
}  
Else
{
    $global:UserExists = $false

    # CHANGED
    $Details.SelectionColor = 'Red'
    $global:UserExists = $true
    return 'User Not Found'
    }
}

Function CheckRemoteDesktop
{
#$Details.Clear()
$Domain = "UNIWA\" + $SNText.Text
#$Domain
if ($CompExists -and $UserExists)
{
   ##$(try {Invoke-Command -Computername $CNText.Text -ScriptBlock {Get-LocalGroupMember -Group "Remote Desktop Users"| Where-Object Name -contains $Using:Domain}}catch {$null})
   $Details.AppendText("Already has access: ")
   $Details.Text = "Please wait..."
   }
Else
{
    trap [MethodInvocationException]
    {
    $Details.AppendText("Please perform necessary checks")
    }
}
#Else
#{
#    $Details.AppendText("Please perform necessary checks")
#    }
}
#| Where-Object Name -contains $Using:Domain
function testthis{
    $Details.Clear()
    $Details.AppendText((CheckComputer) +"`n")
    $Details.AppendText((CheckUser) +"`n")
    $Details.AppendText((CheckRemoteDesktop))
}



Function EnableRemoteDesktop
{
#$Domain = "UNIWA\" + $SNText.Text
#$Domain
$Details.Clear()
$Details.Text = "Please Wait..."
#if ($CompExists -and $UserExists -eq $true)
#{
$( try {Invoke-Command -Computername $CNText.Text -ScriptBlock {Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" –Value 0; Enable-NetFirewallRule -DisplayGroup "Remote Desktop";Add-LocalGroupMember -Group "Remote Desktop Users" -Member $Using:SNText.Text -ErrorAction SilentlyContinue;}}catch {$null})
$Output = $( try {Invoke-Command -Computername $CNText.Text -ScriptBlock  { Get-LocalGroupMember -Name 'Remote Desktop Users' | Where-Object Name -contains $Using:Domain}}catch {$null}) 
$Details.Text =  $Output, "Added Successfully"
}
#Else { $Details.Text = "Somethings not right"
#    }
#}

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '626,230'
$Form.text                       = "Form"
$Form.TopMost                    = $false

$SN                              = New-Object system.Windows.Forms.Label
$SN.text                         = "Student/Staff Number"
$SN.AutoSize                     = $true
$SN.width                        = 25
$SN.height                       = 10
$SN.location                     = New-Object System.Drawing.Point(29,90)
$SN.Font                         = 'Microsoft Sans Serif,10'

$CN                              = New-Object system.Windows.Forms.Label
$CN.text                         = "Computer Name"
$CN.AutoSize                     = $true
$CN.width                        = 25
$CN.height                       = 10
$CN.location                     = New-Object System.Drawing.Point(28,49)
$CN.Font                         = 'Microsoft Sans Serif,10'

$LG                              = New-Object system.Windows.Forms.Label
$LG.text                         = "Local Group"
$LG.AutoSize                     = $true
$LG.width                        = 25
$LG.height                       = 10
$LG.location                     = New-Object System.Drawing.Point(30,135)
$LG.Font                         = 'Microsoft Sans Serif,10'

$CNText                          = New-Object system.Windows.Forms.TextBox
$CNText.multiline                = $false
$CNText.width                    = 100
$CNText.height                   = 20
$CNText.location                 = New-Object System.Drawing.Point(237,45)
$CNText.Font                     = 'Microsoft Sans Serif,10'

$SNText                          = New-Object system.Windows.Forms.TextBox
$SNText.multiline                = $false
$SNText.width                    = 100
$SNText.height                   = 20
$SNText.location                 = New-Object System.Drawing.Point(237,84)
$SNText.Font                     = 'Microsoft Sans Serif,10'

$LGName                          = New-Object system.Windows.Forms.ListBox
$LGName.text                     = "listBox"
$LGName.width                    = 102
$LGName.height                   = 30
$LGName.location                 = New-Object System.Drawing.Point(237,122)

$Details                         = New-Object System.Windows.Forms.RichTextBox
$Details.height                  = 100
$Details.width                   = 200
$Details.BackColor               = "#ffffff"
$Details.text                    = ""
$Details.Enabled                 = $false
$Details.location                = New-Object System.Drawing.Point(379,48)

$Close                           = New-Object system.Windows.Forms.Button
$Close.BackColor                 = "#ffffff"
$Close.text                      = "Close"
$Close.width                     = 71
$Close.height                    = 30
$Close.location                  = New-Object System.Drawing.Point(492,171)
$Close.Font                      = 'Microsoft Sans Serif,10'
$Form.controls.Add($Close)
$Close.Add_Click({ $Form.Tag = $null; $Form.Close() })

$Help                            = New-Object system.Windows.Forms.Button
$Help.BackColor                  = "#ffffff"
$Help.text                       = "Help"
$Help.width                      = 60
$Help.height                     = 30
$Help.location                   = New-Object System.Drawing.Point(408,170)
$Help.Font                       = 'Microsoft Sans Serif,10'
$Form.controls.Add($Help)

$TestConnection                  = New-Object system.Windows.Forms.Button
$TestConnection.BackColor        = "#ffffff"
$TestConnection.text             = "Checks"
$TestConnection.width            = 167
$TestConnection.height           = 30
$TestConnection.location         = New-Object System.Drawing.Point(28,171)
$TestConnection.Font             = 'Microsoft Sans Serif,10'

# CHANGED

#$TestConnection.Add_Click({$Details.Text = (CheckUser)+"`n"+(CheckComputer)})
#$Details.text = (CheckUser)+"`n"+(CheckComputer)
$TestConnection.Add_Click({testthis})

$Addtogroup                      = New-Object system.Windows.Forms.Button
$Addtogroup.BackColor            = "#ffffff"
$Addtogroup.text                 = "Enable Remote Desktop"
$Addtogroup.width                = 153
$Addtogroup.height               = 30
$Addtogroup.location             = New-Object System.Drawing.Point(223,170)
$Addtogroup.Font                 = 'Microsoft Sans Serif,10'
$Addtogroup.Add_Click({EnableRemoteDesktop})

$Form.controls.AddRange(@($SN,$CN,$LG,$CNText,$SNText,$LGName,$Details,$Close,$Help,$TestConnection,$Addtogroup))

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog() 