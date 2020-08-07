# Robocopy script with e-mail notification on Backup Complete.
# Author: Vishal Tanpure
# Date Created: 06-08-2020
# Date Updated: 06-08-2020
# Version 1

cls

########## Change these values as per your requirment ##########
# Robocopy values
    $Source      = "D:\Source" 
    $Destination = "D:\Destination"  
    $Log         = "D:\Destination\Backup.log"
                  
# clean up old logs (if exsists)
    if (test-path $Log) { remove-item $Log }
    
# Copy Folder with Robocopy
    Robocopy $Source $Destination /E /Z /ZB /NP /R:5 /W:5 /V /copy:DATS /MT:128 /tee /LOG:$Log

# Mirror Folders with Robocopy
    #Robocopy $Source $Destination /MIR /NP /R:5 /W:5 /V /copy:DATS /MT:128 /tee /LOG:$Log

# Change these values for Email
    $to      = "abc@abc.com" #Email ID to where you want to receive Backup Notification
    $from    = "abc@abc.com" #Email ID from where you want to send email 
    $cred    = "password" #enter password for you "from" email id
    $server  = "smtp.office365.com" #enter SMTP server 
    $port    = "587" #enter SMTP port you want to use
    
    $subject =  "Robocopy Summary" 
    $body    = "<style>pre {font-family: Lucida Console;}</style><pre>$(Get-Content $Log -last 8 | ForEach-Object {"$_ <br/>"})</pre>"
    $body   += "<font face=' Lucida Console' color=Blue>Backup from <b>$source</b> to <b>$Destination</b> is Completed. for more details please see attached Log file.</font>"


########## Dont Change below Values ##########

# Create the message
    $mail    = New-Object System.Net.Mail.Mailmessage $from, $to, $subject, $body
    $mail.IsBodyHTML=$true
    $attachment = New-Object Net.Mail.Attachment($Log)
    $mail.Attachments.Add($attachment)
    $Smtp   = New-Object System.Net.Mail.SMTPClient $server,$port
    $Smtp.EnableSsl   =$true
    $Smtp.Credentials = New-Object System.Net.NetworkCredential($from,$cred) ; 

# send the Mail
    $smtp.send($mail)

