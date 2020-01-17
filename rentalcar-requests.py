import os
import urllib.parse
import requests
import re

from dotenv import load_dotenv
load_dotenv()

locationDeparture = os.getenv('BSP_ORIGIN')
locationReturn = os.getenv('BSP_DESTINATION')
dateDeparture = os.getenv('BSP_DATE_DEPARTURE')
dateReturn = os.getenv('BSP_DATE_RETURN')
#locationDeparture = 3327 # Location code
#locationReturn = 3327 # Location code
#dateDeparture = '09/05/2020'
#dateReturn = '16/05/2020'
timeDeparture = '14:00'
timeReturn = '14:00'
selectedCars = [
    "RENAULT CLIO*",
]

# Compile url with parameters
url = 'http://www.bsp-auto.com/fr/list.asp?ag_depart={}&ag_retour={}&vu=0&date_a={}&heure_a={}&date_d={}&heure_d={}'.format(locationDeparture, locationReturn, urllib.parse.quote(dateDeparture, safe=''), urllib.parse.quote(timeDeparture, safe=''), urllib.parse.quote(dateReturn, safe=''), urllib.parse.quote(timeReturn, safe=''))

# Browser bspauto search page
r = requests.get(url)

# Write source code in file
with open("bsp-auto.curl", "w") as f:
  f.write(r.text)
f.close()

f = open("bsp-auto.curl", "r")
for car in selectedCars:
    for line in f:
        if re.search(r"class=tit_modele>{}".format(car), line, re.IGNORECASE):
            bloc = next(f)
            price = re.search("class=tarif>([0-9]*)" ,bloc).group(1)
            print(car, price)
            break

