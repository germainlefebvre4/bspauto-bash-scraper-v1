#!/bin/bash
#set -x
date=`date "+%F %T"`
dirname=$(dirname `readlink -f $0`)
dirname='.'

header="date"
content=""
cars=()
cars[0]="RENAULT MEGANE"
cars[1]="RENAULT SCENIC"
cars[2]="PEUGEOT 3008"
cars[3]="JEEP COMPASS"
cars[4]="VW PASSAT"
current_price=257

URL='https://www.bsp-auto.com/fr/list.asp?ag_depart=2715&date_a=21%2F05%2F2023&heure_a=15%3A00&ag_retour=2715&date_d=02%2F06%2F2023&heure_d=15%3A00&chkage=1&age=25'

curl -s "$URL" > $dirname/bsp-auto.curl

# Set header
for i in ${!cars[@]} ; do
  header="$header,${cars[$i]}"
done

# Set content
for i in ${!cars[@]} ; do
  prix=`cat $dirname/bsp-auto.curl | grep -A1 -i -a "class=tit_modele>${cars[i]}" | head -2 | grep -o -P "class=tarif>\K([0-9]*)"`
  content="$content,$prix"
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
