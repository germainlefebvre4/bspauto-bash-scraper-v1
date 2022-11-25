# BSP Auto Bash Scraper

## Getting started
```bash
./bsp-auto.sh --airport '3720' --departure-date '13/05/2023' --departure-time '13:00' --return-date '25/05/2023' --return-time '10:00'
```

Output:
```
From 13/05/2023 13:00 to 25/05/2023 10:00
URL: https://www.bsp-auto.com/fr/list.asp?ag_depart=3720&date_a=13%2F05%2F2023&heure_a=13%3A00&ag_retour=3720&date_d=25%2F05%2F2023&heure_d=10%3A00&chkage=1&age=25
Result file: results/20230513-13h00_20230525-10h00/3720/results.csv

date,RENAULT MEGANE,RENAULT SCENIC,PEUGEOT 3008,JEEP COMPASS,VW PASSAT,RENAULT CAPTUR,RENAULT KANGOO,DACIA DUSTER,Current Price
2022-11-25 23:19:03,606,,1867,,,625,718,754,
2022-11-25 23:18:56,606,,1867,,,625,718,754,
upload: results/20230513-13h00_20230525-10h00/3720/results.csv to s3://my-aws-bucket/results/20230513-13h00_20230525-10h00/3720/results.csv
```



## Configuration

### Script parameters

| Name           | Description                                                              | Variable               | Parameter              | Short param | Long param         | Default value    | Example                         |
|----------------|--------------------------------------------------------------------------|------------------------|------------------------|-------------|--------------------|------------------|---------------------------------|
| AWS Profile    | AWS profile name set into file `~/.aws/credentials`.                     | <ul><li>[x] </li></ul> | <ul><li>[x] </li></ul> | `-profile`  | `--aws-profile`    | `my_aws_profile` | `--aws-profile my_aws_profile`  |
| AWS Bucket     | AWS Bucket name where store the results.                                 | <ul><li>[x] </li></ul> | <ul><li>[x] </li></ul> | `-bucket`   | `--aws-bucket`     | `my-aws-bucket`  | `--aws-bucket my-aws-bucket`    |
| Quiet          | Reduce verbosity of the script.                                          | <ul><li>[x] </li></ul> | <ul><li>[x] </li></ul> | `-q`        | `--quiet`          | *None*           | `--quiet`                       |
| Airport ID     | ID of the Airport for departure AND return.                              |                        | <ul><li>[x] </li></ul> | `-a`        | `--airport`        | *None*           | `--airport '3720`               |
| Departure date | Date of the departure in format `DD/MM/YYYY`.                            |                        | <ul><li>[x] </li></ul> | `-dd`       | `--departure-date` | *None*           | `--departure-date '13/05/2023'` |
| Departure time | Time of the departure in format `HH:MM`.                                 |                        | <ul><li>[x] </li></ul> | `-dt`       | `--departure-time` | *None*           | `--departure-tome '13:00'`      |
| Return date    | Date of the return in format `DD/MM/YYYY`.                               |                        | <ul><li>[x] </li></ul> | `-rd`       | `--return-date`    | *None            | `--return-date '25/05/2023'`    |
| Return time    | Time of the return in format `HH:MM`.                                    |                        | <ul><li>[x] </li></ul> | `-rt`       | `--return-time`    | *None            | `--return-time '10:00'`         |
| Current price  | Price to show as static value for comparison (usually the booked price). | <ul><li>[x] </li></ul> | <ul><li>[x] </li></ul> |             |                    |                  |                                 |
| Cars           | List of cars to watch for.                                               | <ul><li>[x] </li></ul> |                        |             |                    |                  |                                 |


## Dockerhub

Link to Dockerhub : [https://hub.docker.com/r/germainlefebvre4/bspauto-bash-scraper](https://hub.docker.com/r/germainlefebvre4/bspauto-bash-scraper)
