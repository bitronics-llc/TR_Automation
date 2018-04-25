# Scratch repo for TR automation examples

## Mx60 / PPX2

### Retrieval

Use an HTTP GET from `http://<-IP->/data5.cgi` to obtain information about the number
of records and the timestamps of the first and last records, as shown below:

```json
{
    "Header": {
    },
    "metaData": {
        "nRec": "47555",
        "firstRec": {
            "time": "1521789356",
            "msec": "642"
        },
        "lastRec": {
            "time": "1524643018",
            "msec": "971"
        }
    }
}
```

Use an HTTP POST from `http://<-IP->/get_csv.cgi` to obtain all the data records
in JSON format.  If parameters for start and end times are provided, then a range
is returned.  The timestamps are normal POSIX seconds * 1000 to allow msec.  For
example,
`http://<-IP->/get_csv.cgi?start=1524643008000&end1524643018000`

### Conversion - JSON to CSV

The CSV headers may be obtained from the array in "Header_Row".  The row data is
available in the array in "Records".  Date and time information for the CSV is
available as Unix Epoch time in "seconds" with an additional milliseconds fields.
The actual format of the date and time strings should not matter.  The Python
example uses ISO 8601 for convenience, but the web-served JS conforms to PRC-002
for consistency with legacy applications.  The "TZ Offset" field should be set to
zero if UTC is retained.  The remainder of the columns are populated in order from
the "Measurements" array.

See [example](https://github.com/bitronics-llc/TR_Automation/blob/master/tr.json) JSON

See [example](https://github.com/bitronics-llc/TR_Automation/blob/master/tr.csv) CSV

## Mx70

Future.