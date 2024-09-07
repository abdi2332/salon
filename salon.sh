#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){
  SERVICE=$($PSQL "SELECT service_id, name FROM services;")

  echo -e "$SERVICE" | while read SERVICE_ID BAR NAME

  do 

  echo -e "$SERVICE_ID) $NAME service"

  done

  read SERVICE_ID_SELECTED

  SERVICE_AVAILABLE=$($PSQL "SELECT service_id, name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_AVAILABLE ]]

  then

  echo -e "\nI could not find that service. What would you like today?"
  MAIN_MENU

  else

  echo -e "\nWhat's your phone number?"

  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]

  then

  echo -e "\nI don't have a record for that phone number, what's your name?"

  read CUSTOMER_NAME

  CUSTOMER_INFO=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME"

  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  APPOINTMENT_INCLUSION=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME', '$SERVICE_ID_SELECTED', '$CUSTOMER_ID')")

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  else

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  APPOINTMENT_INCLUSION=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME', '$SERVICE_ID_SELECTED', '$CUSTOMER_ID')")

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  fi
  fi

}
MAIN_MENU