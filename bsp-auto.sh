#!/bin/bash
#set -x

QUIET=1

TRIP_DATE_FROM="14/05/2023"
TRIP_DATE_TO="24/05/2023"

cars=()
cars[0]="RENAULT MEGANE"
cars[1]="RENAULT SCENIC"
cars[2]="PEUGEOT 3008"
cars[3]="JEEP COMPASS"
cars[4]="VW PASSAT"
CURRENT_PRICE=257

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -q|--quiet)
      QUIET=0
      shift # past argument
      ;;
    -df|--date-to)
      TRIP_DATE_FROM="$2"
      shift # past argument
      shift # past value
      ;;
    -dt|--date-to)
      TRIP_DATE_TO="$2"
      shift # past argument
      shift # past value
      ;;
    -p|--current-price)
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

date=`date "+%F %T"`
dirname=$(dirname `readlink -f $0`)
dirname='.'

TRIP_DATE_FROM_ENCODED=$(echo -n ${TRIP_DATE_FROM} | jq -sRr @uri)
TRIP_DATE_TO_ENCODED=$(echo -n ${TRIP_DATE_TO} | jq -sRr @uri)

header="date"
content=""

URL='https://www.bsp-auto.com/fr/list.asp?ag_depart=2715&date_a='${TRIP_DATE_FROM_ENCODED}'&heure_a=15%3A00&ag_retour=2715&date_d='${TRIP_DATE_TO_ENCODED}'&heure_d=15%3A00&chkage=1&age=25'


if [ $QUIET -eq 1 ]; then
  echo "From ${TRIP_DATE_FROM} to ${TRIP_DATE_TO}"
  echo "URL: ${URL}"
  echo "Result file: $dirname/bsp-auto"
  echo ""
fi

curl -s "$URL" > $dirname/bsp-auto.curl

# Set header
for i in ${!cars[@]} ; do
  header="$header,${cars[$i]}"
done

# Set content
for i in ${!cars[@]} ; do
  price=`cat $dirname/bsp-auto.curl | grep -A1 -i -a "class=tit_modele>${cars[i]}" | head -2 | grep -o -P "class=tarif>\K([0-9]*)"`
  content="$content,$price"
done

# Add colummn current if set
if [ "$CURRENT_PRICE" != "" ] ; then
  header="$header,Current"
  content="$content,$CURRENT_PRICE"
fi

# Print intermediate result
echo "$date$content" >> $dirname/bsp-auto.result

# Print header and content in final file
echo $header > $dirname/bsp-auto
sort -r $dirname/bsp-auto.result >> $dirname/bsp-auto

cat $dirname/bsp-auto

# Check if price is better and send email
line_last=(`tail -1 $dirname/bsp-auto.result | cut -d',' -f2- | tr ',' '\n'`)
line_before=(`tail -2 $dirname/bsp-auto.result | head -1| cut -d',' -f2- | tr ',' '\n'`)
for((i=0;i<${#line_last[@]};i++)) ; do
  # Handle new values
  if [ "${line_last[$i]}" != "" ] && [ "${line_before[$i]}" != "" ] ; then
    # Test if value is better than the min
    if [ "${line_last[$i]}" -lt "${CURRENT_PRICE}" ] ; then
      flag_email=0
    fi
  fi
done
