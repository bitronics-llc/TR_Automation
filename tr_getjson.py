# Get TR JSON from PPX2 / Mx60

import json
from urllib.request import urlopen, Request
from urllib.parse import urljoin, urlencode

BASE_URL = 'http://192.168.0.171'

def getallrecords():
    """ Simplified example that gets all records """
    with urlopen(urljoin(BASE_URL,'get_csv.cgi')) as response:
        tr = json.loads(response.read())
    with open('tr.json', 'w') as fp:
        json.dump(tr, fp, indent=4)

def getlasthour():
    """ Example using parameters to get range of records """

    # Get time stamp of the last record in device
    with urlopen(urljoin(BASE_URL,'data5.cgi')) as response:
        meta = json.loads(response.read())['metaData']
        last = int(meta['lastRec']['time'])*1000 + int(meta['lastRec']['msec'])
    
    # Encode start and end parameters as Unix time * 1000
    data = urlencode({'start': last-60*60*1000, 'end':last}).encode('ascii')
    req = Request(url=urljoin(BASE_URL,'get_csv.cgi'), data=data, method='POST')
    with urlopen(req) as response:
        tr = json.loads(response.read())

    # Dump json to file
    with open('tr.json', 'w') as fp:
        json.dump(tr, fp, indent=4)

if __name__ == '__main__':
    getlasthour()