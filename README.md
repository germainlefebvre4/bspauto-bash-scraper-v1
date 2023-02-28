# BSP Auto Bash Scraper

## Getting started

```bash
./bsp-auto.sh --aws-profile my_aws_profile --aws-bucket my-aws-bucket --quiet --airport '3715' --departure-date '21/05/2023' --departure-time '08:00' --return-date '30/05/2023' --return-time '20:00' --cars 'PEUGEOT 208'
./bsp-auto.sh --aws-profile my_aws_profile --aws-bucket my-aws-bucket --quiet --airport '3715' --departure-date '21/05/2023' --departure-time '08:00' --return-date '30/05/2023' --return-time '20:00' --cars 'RENAULT CLIO,PEUGEOT 208,FIAT 500 X,VW GOLF,RENAULT MEGANE,JEEP RENEGADE,PEUGEOT 308,VW PASSAT,PEUGEOT 3008' --current-price 500 --ntfy-token 'my_ntfy_token'
```

Output:

```raw
From 21/05/2023 08:00 to 30/05/2023 20:00
URL: https://www.bsp-auto.com/fr/list.asp?ag_depart=2715&date_a=21%2F05%2F2023&heure_a=08%3A00&ag_retour=2715&date_d=30%2F05%2F2023&heure_d=20%3A00&chkage=1&age=25
Result file: results/20230521-08h00_20230530-20h00/2715/results.csv

date,RENAULT CLIO,PEUGEOT 208,FIAT 500 X,VW GOLF,RENAULT MEGANE,JEEP RENEGADE,PEUGEOT 308,VW PASSAT,PEUGEOT 3008,Current Price
2023-02-21 12:27:57,433,437,454,475,518,547,553,566,576,
2023-02-21 12:17:07,433,437,454,475,518,547,553,566,576,
2023-02-21 12:16:33,433,437,454,475,518,547,553,566,576,

upload: results/20230521-08h00_20230530-20h00/2715/results.csv to s3://my-aws-bucket/results/20230521-08h00_20230530-20h00/2715/results.csv

New lowest price: 334 for PEUGEOT 437
```

## Configuration

### Script parameters

| Name           | Description                                                              | Variable               | Parameter              | Short param | Long param         | Default value    | Example                             |
|----------------|--------------------------------------------------------------------------|------------------------|------------------------|-------------|--------------------|------------------|-------------------------------------|
| AWS Profile    | AWS profile name set into file `~/.aws/credentials`.                     | <ul><li>[x] </li></ul> | <ul><li>[x] </li></ul> | `-profile`  | `--aws-profile`    | `my_aws_profile` | `--aws-profile my_aws_profile`      |
| AWS Bucket     | AWS Bucket name where store the results.                                 | <ul><li>[x] </li></ul> | <ul><li>[x] </li></ul> | `-bucket`   | `--aws-bucket`     | `my-aws-bucket`  | `--aws-bucket my-aws-bucket`        |
| Quiet          | Reduce verbosity of the script.                                          | <ul><li>[x] </li></ul> | <ul><li>[x] </li></ul> | `-q`        | `--quiet`          | *None*           | `--quiet`                           |
| Airport ID     | ID of the Airport for departure AND return.                              |                        | <ul><li>[x] </li></ul> | `-a`        | `--airport`        | *None*           | `--airport '3720'`                   |
| Departure date | Date of the departure in format `DD/MM/YYYY`.                            |                        | <ul><li>[x] </li></ul> | `-dd`       | `--departure-date` | *None*           | `--departure-date '13/05/2023'`     |
| Departure time | Time of the departure in format `HH:MM`.                                 |                        | <ul><li>[x] </li></ul> | `-dt`       | `--departure-time` | *None*           | `--departure-tome '13:00'`          |
| Return date    | Date of the return in format `DD/MM/YYYY`.                               |                        | <ul><li>[x] </li></ul> | `-rd`       | `--return-date`    | *None*           | `--return-date '25/05/2023'`        |
| Return time    | Time of the return in format `HH:MM`.                                    |                        | <ul><li>[x] </li></ul> | `-rt`       | `--return-time`    | *None*           | `--return-time '10:00'`             |
| Cars           | List of cars to watch for.                                               |                        | <ul><li>[x] </li></ul> | `-ca`       | `--cars`           | *None*           | `--cars 'RENAULT CLIO,PEUGEOT 208'` |
| Current price  | Price to show as static value for comparison (usually the booked price). | <ul><li>[x] </li></ul> | <ul><li>[x] </li></ul> | `-cp`       | `--current-price`           | *None*           | `--current price 500` |
| Ntfy token | Token to trigger phone push notification from [Ntfy](https://ntfy.sh/) platform (free).                                               |                        | <ul><li>[x] </li></ul> | `-ntfy`       | `--ntfy-token`           | *None*           | `--ntfy-token 'my_tnfy_token'` |

## Cronjob

### Add the parser script as cronjob

```bash
crontab -e
*/30 * * * * /opt/bspauto/bspauto-bash-scraper-v1/bsp-auto.sh --aws-profile my_aws_profile --aws-bucket bspauto-results --quiet --airport '3720' --departure-date '14/05/2023' --departure-time '13:30' --return-date '25/05/2023' --return-time '10:30' --current-price '575'
```

## Dockerhub

Link to Dockerhub : [https://hub.docker.com/r/germainlefebvre4/bspauto-bash-scraper](https://hub.docker.com/r/germainlefebvre4/bspauto-bash-scraper)
