$baseurl = "http://192.168.0.171"

function getallrecords {
    # Simplified example that gets all records
    Invoke-RestMethod -Uri $baseurl"/get_csv.cgi" -OutFile tr.json
}

function getlasthour {
    # Example using parameters to get range of records """
    $meta = (Invoke-RestMethod -Uri $baseurl"/data5.cgi").metaData
    $last = 1000*$meta.lastRec.time+$meta.lastRec.msec #coerces to int
    Invoke-RestMethod -Uri $baseurl"/get_csv.cgi" -Body @{start=$last-60*60*1000;end=$last} -Method post -OutFile tr.json
}

getlasthour
