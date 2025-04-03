## DEMO SCRIPT FOR COSUGI 2025

# SPUD values and other variables
$server="Server"
$user="user"
$passwd="password"
$db="Database"
$target="item949"
$marcout_logfile='C:\MARCOUT.log'
$script_location_root = "C:\LOCATION_OF_SQL_FILES\"


# CREATE NEW DIR EACH MONTH
$t=Get-Date -UFormat %d%b%y
$NewDir = "C:\$t"
New-Item -ItemType "directory" -Path $NewDir

# DELETE PREVIOUS MARCOUT LOG FILE
Remove-Item $marcout_logfile -Force

# SET WORKING DIRECTORY
Set-Location $NewDir

# FILTERS THE DIR CONTAINING SQL FILES AND RUNS EACH ONE
Get-ChildItem -Path $script_location_root -Filter *.sql | ForEach-Object -Process  { 

    # GET FILENAME WITHOUT EXTENSION TO CREATE .XLS FILE
    $noext=[System.IO.Path]::GetFileNameWithoutExtension($_)

    $logfile="$noext.xls"
    $newlogfile = $logfile + 'x'
        
    # SCRIPT LOCATION WITH FILENAME   
    $script_location = $script_location_root + $_.Name
        
    # CONSOLE OUTPUT
    "Running ..."
        
    # EXECUTE SQL WITH OUTPUT XLS file for those with _RPT in filename.  

    Write-Host $_.Name

    if ($_.Name -match "_RPT" ) {
        sqlcmd -S $server -U $user -P $passwd -d $db -i $script_location -s "`t" -o $logfile -u
    
            ConvertTo-ExcelXlsx -path $logfile -Force 
            If (Test-Path -Path $newlogfile -PathType Leaf ){
                Remove-Item $logfile 
            }
            else {
                $newlogfile = $logfile
            }
    
         
    elseif ( $_.Name -match "Populate" ) {

            sqlcmd -S $server -U $user -P $passwd -d $db -i $script_location 

            # Run marcout utility for Populate files only. 
            "`nRunning marcout ... " + "$noext.mrc"

                C:\horizon\marcout.exe /s$server /u$user /p$passwd /d$db /x$target /y /t workingtable /q996 /@M /m "$noext.mrc" | Out-File -FilePath $marcout_logfile -Encoding utf8 -Append
         
    }    
    
    else {
        sqlcmd -S sdsqlsonoma.dynixasp.com -U $user -P $passwd -d $db -i $script_location 
    }


}
   
# COPY NEWDIR TO A SHARED NETWORK DIR
