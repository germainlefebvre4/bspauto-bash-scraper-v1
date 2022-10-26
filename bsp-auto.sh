#!/bin/bash
#set -x
date=`date "+%F %T"`
dirname=$(dirname `readlink -f $0`)
dirname='.'

header="date"
content=""
cars=()
cars[0]="RENAULT TWINGO*"
current_price=257

URL='https://www.bsp-auto.com/fr/list.asp?ag_depart=3327&ag_retour=3327&vu=0&date_a=24%2F03%2F2020&heure_a=15%3A30&date_d=04%2F04%2F2020&heure_d=15%3A00'

curl -s "$URL" > $dirname/bsp-auto.curl

# Set header
for i in ${!cars[@]} ; do
  header="$header,${cars[$i]}"
done

# Set content
for i in ${!cars[@]} ; do
  price=`cat $dirname/bsp-auto.curl | grep -A1 -i -a "class=tit_modele>RENAULT TWINGO*" | head -2 | tail -1 | grep -o -P "class=tarif>\K([0-9]*)"`
  content="$content,$price"
done

# Add colummn current if set
if [ "$current_price" != "" ] ; then
  header="$header,Current"
  content="$content,$current_price"
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
    if [ "${line_last[$i]}" -lt "${current_price}" ] ; then
      flag_email=0
    fi
  fi
done
