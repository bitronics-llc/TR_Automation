# Convert TR JSON to CSV

import json
import csv
import datetime

with open('tr.json', 'r') as fp:
    tr = json.load(fp)

with open('tr.csv', 'w', newline='') as fp:
    trcsv = csv.writer(fp)
    trcsv.writerow(tr['Header_Row'])

    for record in tr['Records']:
        ftime = float('.'.join([record['seconds'],record['ms']]))
        stime= datetime.datetime.utcfromtimestamp(ftime)
        payload = [stime.date().isoformat(), stime.time().isoformat(), 0]+record['Measurements']
        trcsv.writerow(payload)

