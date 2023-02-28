# BspAuto scraper

## Tags

* [`latest`](https://github.com/germainlefebvre4/bspauto-bash-scraper/blob/master/Dockerfile), ...

## Quick reference

* **Where to get help:**
   the Docker Community Forums, the Docker Community Slack, or Stack Overflow
* **Where to file issues:**
   https://github.com/germainlefebvre4/bspauto-bash-scraper/issues
* **Maintained by:**
   [Germain LEFEBVRE](https://github.com/germainlefebvre4)
* **Supported architectures: (more info)**
   amd64
* **Published image artifact details:**
   -
* **Image updates:**
   -
* **Source of this description:**
   [docs repo's dockerhub/ directory (history)](https://github.com/germainlefebvre4/bspauto-bash-scraper/blob/master/docs/dockerhub/README.md)

## What is BspAuto Scraper?

### Run the script

```bash
docker run -tid --name=bspauto-bash-scraper --rm germainlefebvre4/bspauto-bash-scraper:latest
```

## Parameters

### Script parameters

| Name           | Description                                                              | Variable | Parameter | Short param | Long param         | Default value    | Example                         |
|----------------|--------------------------------------------------------------------------|----------|-----------|-------------|--------------------|------------------|---------------------------------|
| AWS Profile    | AWS profile name set into file `~/.aws/credentials`.                     | Yes      | Yes       | `-profile`  | `--aws-profile`    | `my_aws_profile` | `--aws-profile my_aws_profile`  |
| AWS Bucket     | AWS Bucket name where store the results.                                 | Yes      | Yes       | `-bucket`   | `--aws-bucket`     | `my-aws-bucket`  | `--aws-bucket my-aws-bucket`    |
| Quiet          | Reduce verbosity of the script.                                          | Yes      | Yes       | `-q`        | `--quiet`          | *None*           | `--quiet`                       |
| Airport ID     | ID of the Airport for departure AND return.                              |          | Yes       | `-a`        | `--airport`        | *None*           | `--airport '3720'`               |
| Departure date | Date of the departure in format `DD/MM/YYYY`.                            |          | Yes       | `-dd`       | `--departure-date` | *None*           | `--departure-date '13/05/2023'` |
| Departure time | Time of the departure in format `HH:MM`.                                 |          | Yes       | `-dt`       | `--departure-time` | *None*           | `--departure-tome '13:00'`      |
| Return date    | Date of the return in format `DD/MM/YYYY`.                               |          | Yes       | `-rd`       | `--return-date`    | *None*            | `--return-date '25/05/2023'`    |
| Return time    | Time of the return in format `HH:MM`.                                    |          | Yes       | `-rt`       | `--return-time`    | *None*            | `--return-time '10:00'`         |
| Current price  | Price to show as static value for comparison (usually the booked price). | Yes | Yes | `-cp`       | `--current-price`           | *None*           | `--current price 500` |
| Cars           | List of cars to watch for.                                               |                        | Yes | `-ca`       | `--cars`           | *None*           | `--cars 'RENAULT CLIO,PEUGEOT 208'` |
| Ntfy token | Token to trigger phone push notification from [Ntfy](https://ntfy.sh/) platform (free).                                               |                        | Yes | `-ntfy`       | `--ntfy-token`           | *None*           | `--ntfy-token 'my_ntfy_token'` |

### Run the script with parameters

```bash
docker run --rm -v "$HOME/.aws:/root/.aws" --airport '3720' --departure-date '13/05/2023' --departure-time '13:00' --return-date '25/05/2023' --return-time '10:00' --cars "RENAULT CLIO,PEUGEOT 208,FIAT 500 X,VW GOLF" --current-price 500 --ntfy-token 'my_ntfy_token'
```
