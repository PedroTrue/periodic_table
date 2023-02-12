#/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then

  echo "Please provide an element as an argument."

else

  if [[ "$(echo $1 | grep -E '^[0-9]+$')" ]]
  then
    
    RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number=$1")
  
  else
    
    SYMB=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
    
    if [[ "$SYMB" ]]
    then

      RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON properties.type_id=types.type_id WHERE elements.symbol='$1'")
    
    else

      RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON properties.type_id=types.type_id WHERE elements.name='$1'")
    
    fi
  fi

  if [[ -z $RESULT ]]
  then

    echo "I could not find that element in the database."

  else

    read ATOM BAR SYM BAR NAME BAR ATOM BAR MASS BAR MELT BAR BOIL BAR TYPE_ID BAR TYPE_ID BAR TYPE <<< $RESULT

    echo "The element with atomic number $ATOM is $NAME ($SYM). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  
  fi
fi
