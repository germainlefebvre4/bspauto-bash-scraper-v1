# BspAuto scraper
## Tags
* [`latest`](https://github.com/germainlefebvre4/bspauto-scraper/blob/master/Dockerfile), ...

## Quick reference
* **Where to get help:**
   the Docker Community Forums, the Docker Community Slack, or Stack Overflow
* **Where to file issues:**
   https://github.com/germainlefebvre4/bspauto-scraper/issues
* **Maintained by:**
   [Germain LEFEBVRE](https://github.com/germainlefebvre4)
* **Supported architectures: (more info)**
   amd64
* **Published image artifact details:**
   -
* **Image updates:**
   -
* **Source of this description:**
   [docs repo's dockerhub/ directory (history)](https://github.com/germainlefebvre4/bspauto-scraper/blob/master/docs/dockerhub/README.md)

## What is BspAuto Scraper?
### Run the script
```bash
docker run -tid --name=bspauto-scraper germainlefebvre4/bspauto-scraper:latest
```

## Parameters
### List of parameters
| Parameter name | Description | Values | Default | Implemented? |
|---|---|---|---|---|
| BSP_ORIGIN | City or airport where you start. | string (Bsp Auto location code) | - | Yes |
| BSP_DESTINATION | City or airport where you go.  | string (Bsp Auto location code) | - | Yes |
| BSP_DATE_DEPARTURE | Date for departure. | string (DD/MM/YYYY) | - | Yes |
| BSP_DATE_RETURN | Date for return. | string (DD/MM/YYYY) | - | Yes |
| BSP_CARS | Cars to be watched. | string (car1,car2) | - | Yes |

**IATA code is documented at [https://www.iata.org/en/publications/directories/code-search/](https://www.iata.org/en/publications/directories/code-search/) **

### Run the script with parameters
```bash
docker run -tid --name=bspauto-scraper -e BSP_ORIGIN='3327' -e BSP_DESTINATION='3327' -e BSP_DATE_DEPARTURE='09/05/2020' -e BSP_DATE_RETURN='16/05/2020' -e BSP_CARS='RENAULT CLIO*' germainlefebvre4/bspauto-scraper:latest
```
