<#
.Summary            Script will take a raw JSON file, and convert it into a CSV
.Process            1) Imports raw JSON file
                    2) Adds each item under .Records to a variable, and do any processing where required
                    3) Input the variables into a Add-Member item to add to an array/object
                    4) Output the object one done the above for each row. to the export path
#>

#Path variables:
$import = ".\tr.json"                                                     #Path to JSON file
$export = ".\tr.ps.csv"                                                   #Export path to CSV

#Initialise variables:
$Global:Date = $null
$Global:Time = $null
$out_obj = @()
$dataobj = @()

#Function:
function Convert-UNIX {                                                             #Function to convert UNIX timestamp into DateTime object
    Param($unix, $ms)                                                               #Takes timestamp and MS as inputs
    $start_epoch = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0   #Starts DateTime object from beginning of UNIX epoch
    $add_minutes = $start_epoch.AddSeconds($unix)                                   #Adds the minutes from the timestamp
    $full_time = $add_minutes.AddMilliseconds($ms)                                  #Adds the MS to the object
    $global:date = ($full_time | get-date -format s).Split('T')[0]                  #Grabs the Date from the string, and puts this in a variable
    $global:time = ($full_time | get-date -format o).Split('T')[-1]                 #Grabs the Time from the string and puts this in a variable
}

if (test-path $import){
    try{
    $json = get-content $import | ConvertFrom-Json                                  #Get JSON raw content and convert to JSON format
    $headers_adj = $json.Header_Row[3..$json.Header_Row.count]                      #Get all headers, except for first 3

    foreach ($s in $json.Records){                                                      #For each record file:
        Convert-UNIX -unix $s.seconds -ms $s.ms                                             #Convert unix time stamp into HR formats for date, time
        $dataobj = New-Object psobject      
        $dataobj | Add-Member -MemberType NoteProperty -Name "Date" -Value $Global:Date     #Create object, and input Date, Time, and TZ Offset
        $dataobj | Add-Member -MemberType NoteProperty -Name "Time" -Value $Global:Time
        $dataobj | Add-Member -MemberType NoteProperty -Name "TZ Offset" -Value "0"
        
        $count = -1                                                                         #Set counter for iterating through Measurements
        foreach ($r in $s.Measurements){                                                    #For each Measurement item
            $count ++                                                                           #Increment counter by 1 (in line with headers)
            $c_header = $headers_adj[$count]                                                    #Get the header respective of content
            $dataobj | Add-Member -MemberType NoteProperty -Name $c_header -Value $r            #Add this to the object for output
        }
        $out_obj += $dataobj
    }

    $out_obj | Export-Csv $export -Delimiter ',' -NoClobber -NoTypeInformation -Append -Force   #Output all as a CSV
    }
    catch {
        #Catch any errors that may occur and output them to console
        write-host "There was a problem..." -f DarkYellow
        write-host $error[0].CategoryInfo.Reason -f DarkYellow
        write-host $error[0].InvocationInfo.PositionMessage -f DarkYellow
    }
}
else{
    write-host "Path to import JSON file is invalid" -f DarkYellow
}