#!/bin/bash
#set -x

AWS_PROFILE="--profile my_aws_profile"
AWS_BUCKET="my-aws-bucket"

QUIET=1

# TRIP_AIRPORT="3720"
# TRIP_DEPARTURE_DATE="14/05/2023"
# TRIP_DEPARTURE_TIME="13:30"
# TRIP_RETURN_DATE="25/05/2023"
# TRIP_RETURN_TIME="10:30"
# TRIP_AIRPORT="3720"

cars=()
cars[0]="RENAULT MEGANE"
cars[1]="RENAULT SCENIC"
cars[2]="PEUGEOT 3008"
cars[3]="JEEP COMPASS"
cars[4]="VW PASSAT"
cars[5]="RENAULT CAPTUR"
cars[6]="RENAULT KANGOO"
cars[7]="DACIA DUSTER"

CURRENT_PRICE=""

POSITIONAL_ARGS=()

function usage() {
  echo "Usage: $0 [--quiet] [--aws-profile <my_aws_profile>] [--aws-bucket <my-aws-bucket>] [--airport <airport_id>] [--departure-date <date_slash>] [-departure-time <time_colon>] [--return-date <date_slash>] [--return-time <time_colon>]"  
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -profile|--aws-profile)
      AWS_PROFILE="$2"
      shift # past argument
      shift # past value
      ;;
    -bucket|--aws-bucket)
      AWS_BUCKET="$2"
      shift # past argument
      shift # past value
      ;;
    -q|--quiet)
      QUIET=0
      shift # past argument
      ;;
    -ap|--airport)
      TRIP_AIRPORT="$2"
      shift # past argument
      shift # past value
      ;;
    -dd|--departure-date)
      TRIP_DEPARTURE_DATE="$2"
      shift # past argument
      shift # past value
      ;;
    -dt|--departure-time)
      TRIP_DEPARTURE_TIME="$2"
      shift # past argument
      shift # past value
      ;;
    -rd|--return-date)
      TRIP_RETURN_DATE="$2"
      shift # past argument
      shift # past value
      ;;
    -rt|--return-time)
      TRIP_RETURN_TIME="$2"
      shift # past argument
      shift # past value
      ;;
    -cp|--current-price)
      CURRENT_PRICE="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters


MISSING_ARGS_FLAG=1
MISSING_ARGS_TEXT="Error: Missing parameters:\n"
if [ -z "${AWS_PROFILE}" ]; then
  MISSING_ARGS_TEXT="${MISSING_ARGS_TEXT} - AWS Profile\n"
  MISSING_ARGS_FLAG=0
fi
if [ -z "${AWS_BUCKET}" ]; then
  MISSING_ARGS_TEXT="${MISSING_ARGS_TEXT} - AWS Bucket\n"
  MISSING_ARGS_FLAG=0
fi
if [ -z "${TRIP_AIRPORT}" ]; then
  MISSING_ARGS_TEXT="${MISSING_ARGS_TEXT} - Airport code\n"
  MISSING_ARGS_FLAG=0
fi
if [ -z "${TRIP_DEPARTURE_DATE}" ]; then
  MISSING_ARGS_TEXT="${MISSING_ARGS_TEXT} - Departure date\n"
  MISSING_ARGS_FLAG=0
fi
if [ -z "${TRIP_DEPARTURE_TIME}" ]; then
  MISSING_ARGS_TEXT="${MISSING_ARGS_TEXT} - Departure time\n"
  MISSING_ARGS_FLAG=0
fi
if [ -z "${TRIP_RETURN_DATE}" ]; then
  MISSING_ARGS_TEXT="${MISSING_ARGS_TEXT} - Return date\n"
  MISSING_ARGS_FLAG=0
fi
if [ -z "${TRIP_RETURN_TIME}" ]; then
  MISSING_ARGS_TEXT="${MISSING_ARGS_TEXT} - Return time\n"
  MISSING_ARGS_FLAG=0
fi
if [ ${MISSING_ARGS_FLAG} -eq 0 ]; then
  echo -e "${MISSING_ARGS_TEXT}"
  usage
  exit 1
fi

date=`date "+%F %T"`
dirname=$(dirname `readlink -f $0`)

TRIP_DEPARTURE_DATE_URLENCODED=$(echo -n ${TRIP_DEPARTURE_DATE} | jq -sRr @uri)
TRIP_DEPARTURE_TIME_URLENCODED=$(echo -n ${TRIP_DEPARTURE_TIME} | jq -sRr @uri)
TRIP_RETURN_DATE_URLENCODED=$(echo -n ${TRIP_RETURN_DATE} | jq -sRr @uri)
TRIP_RETURN_TIME_URLENCODED=$(echo -n ${TRIP_RETURN_TIME} | jq -sRr @uri)
TRIP_DEPARTURE_DATE_DIRENCODED=$(echo -n ${TRIP_DEPARTURE_DATE} | tr '/' '\n' | tac | paste -s -d '')
TRIP_DEPARTURE_TIME_DIRENCODED=$(echo -n ${TRIP_DEPARTURE_TIME} | tr ':' 'h')
TRIP_RETURN_DATE_DIRENCODED=$(echo -n ${TRIP_RETURN_DATE} | tr '/' '\n' | tac | paste -s -d '')
TRIP_RETURN_TIME_DIRENCODED=$(echo -n ${TRIP_RETURN_TIME} | tr ':' 'h')

header="date"
content=""
result_dir="results/${TRIP_DEPARTURE_DATE_DIRENCODED}-${TRIP_DEPARTURE_TIME_DIRENCODED}_${TRIP_RETURN_DATE_DIRENCODED}-${TRIP_RETURN_TIME_DIRENCODED}/${TRIP_AIRPORT}"
result_file="results.csv"

URL='https://www.bsp-auto.com/fr/list.asp?ag_depart='${TRIP_AIRPORT}'&date_a='${TRIP_DEPARTURE_DATE_URLENCODED}'&heure_a='${TRIP_DEPARTURE_TIME_URLENCODED}'&ag_retour='${TRIP_AIRPORT}'&date_d='${TRIP_RETURN_DATE_URLENCODED}'&heure_d='${TRIP_RETURN_TIME_URLENCODED}'&chkage=1&age=25'

if [ $QUIET -eq 1 ]; then
  echo "From ${TRIP_DEPARTURE_DATE} ${TRIP_DEPARTURE_TIME} to ${TRIP_RETURN_DATE} ${TRIP_RETURN_TIME}"
  echo "URL: ${URL}"
  echo "Result file: ${result_dir}/${result_file}"
  echo ""
fi

mkdir -p ${dirname}/${result_dir}
curl -s "${URL}" > ${dirname}/${result_dir}/wip.curl

# Set header
for i in ${!cars[@]} ; do
  header="$header,${cars[$i]}"
done

# Set content
for i in ${!cars[@]} ; do
  price=`cat ${dirname}/${result_dir}/wip.curl | grep -A1 -i -a "class=tit_modele>${cars[i]}" | head -2 | grep -o -P "class=tarif>\K([0-9]*)"`
  content="${content},${price}"
done

# Add colummn current if set
header="$header,Current Price"
content="${content},${CURRENT_PRICE}"

# Print intermediate result
echo "$date${content}" >> ${dirname}/${result_dir}/wip.result

# Print header and content in final file
echo $header > ${dirname}/${result_dir}/${result_file}
sort -r ${dirname}/${result_dir}/wip.result >> ${dirname}/${result_dir}/${result_file}

if [ ${QUIET} -eq 1 ]; then
  cat ${dirname}/${result_dir}/${result_file}
fi


# Publish on S3 Bucket
AWS_QUIET=""
if [ ${QUIET} -eq 0 ]; then
  AWS_QUIET="${AWS_QUIET} --quiet"
else
  echo ""
fi
aws s3 cp ${dirname}/${result_dir}/${result_file} s3://${AWS_BUCKET}/${result_dir}/${result_file} --profile ${AWS_PROFILE} ${AWS_QUIET}
aws s3api put-object-acl --bucket ${AWS_BUCKET} --key ${result_dir}/${result_file} --acl public-read --profile ${AWS_PROFILE}


# # Check if price is better and send email
# line_last=(`tail -1 ${dirname}/wip.result | cut -d',' -f2- | tr ',' '\n'`)
# line_before=(`tail -2 ${dirname}/wip.result | head -1| cut -d',' -f2- | tr ',' '\n'`)
# for((i=0;i<${#line_last[@]};i++)) ; do
#   # Handle new values
#   if [ "${line_last[$i]}" != "" ] && [ "${line_before[$i]}" != "" ] ; then
#     # Test if value is better than the min
#     if [ "${line_last[$i]}" -lt "${CURRENT_PRICE}" ] ; then
#       flag_email=0
#     fi
#   fi
# done
