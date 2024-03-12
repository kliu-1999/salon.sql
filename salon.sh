#!/bin/bash
echo ~~~~~ MY SALON ~~~~~
echo -e '\nWelcome to My Salon, how can I help you?'
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
choice_exists=False
while [ $choice_exists != True ] 
do
  i=1
  while [ $i -lt 4 ];
  do
    service_name=$($PSQL "select name from services where $i=service_id")
    echo $i")" $service_name
    ((i+=1))
  done
  read SERVICE_ID_SELECTED
  if [ $SERVICE_ID_SELECTED -lt $i ] && [ $SERVICE_ID_SELECTED -gt 0 ]
  then
    choice_exists=True
  else
    echo Service does not exist, please reenter your choice
  fi
done
service_selected=$($PSQL "select name from services where $SERVICE_ID_SELECTED=service_id")
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
phone_exists=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
echo $phone_exists
if [[ -z $phone_exists ]]
then
  echo I don't have a record for that phone number, what's your name?
  read CUSTOMER_NAME
  insert_customer=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi
c_id=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME'")
echo What time would you like your $service_selected, $CUSTOMER_NAME?
read SERVICE_TIME
insert_appt=$($PSQL "insert into appointments(customer_id, service_id, time) values($c_id, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
echo I have put you down for a $service_selected at $SERVICE_TIME, $CUSTOMER_NAME.



