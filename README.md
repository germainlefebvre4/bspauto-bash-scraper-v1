# Rental Car scraper

## Getting started
```bash
pipenv run python rentalcar-requests.py
```

## Prepare
```bash
pip install pipenv
pipenv update
```

## Variables
| Parameter name | Description | Values | Default | Implemented? |
|---|---|---|---|---|
| BSP_ORIGIN | City or airport where you start. | string (Bsp Auto location code) | - | Yes |
| BSP_DESTINATION | City or airport where you go.  | string (Bsp Auto location code) | - | Yes |
| BSP_DATE_DEPARTURE | Date for departure. | string (DD/MM/YYYY) | - | Yes |
| BSP_DATE_RETURN | Date for return. | string (DD/MM/YYYY) | - | Yes |
| BSP_CARS | Cars to be watched. | string (car1,car2) | - | Yes |

## Dockerhub
Link to Dockerhub : [https://hub.docker.com/r/germainlefebvre4/bspauto-scraper](https://hub.docker.com/r/germainlefebvre4/bspauto-scraper)
