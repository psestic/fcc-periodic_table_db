#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN() {
  # check whether argument is provided
  if [[ -z $1 ]]
  then
    echo -e "Please provide an element as an argument."
  
  # check whether argument is atomic number 
  elif [[ $1 =~ ^[0-9]+$ ]]
  then
    # get atomic_number, name, symbol, type, mass, melting- and boiling point of element
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
    echo $ELEMENT_INFO | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
    SEARCH_AND_PRINT
    done
  
  # check whether argument is symbol
  elif [[ $1 =~ ^[A-Z][a-z]$ || $1 =~ ^[A-Z]$ ]]
  then
    # get atomic_number, name, symbol, type, mass, melting- and boiling point of element
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol = '$1'")
    echo $ELEMENT_INFO | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
    SEARCH_AND_PRINT
    done

  # check whether argument is name
  elif [[ $1 =~ ^[A-Z][a-z]+$ ]]
  then
    # get atomic_number, name, symbol, type, mass, melting- and boiling point of element
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1'")
    echo $ELEMENT_INFO | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
    SEARCH_AND_PRINT
    done
  
  # if argument is invalid
  else
    echo -e "I could not find that element in the database."
  fi
}

SEARCH_AND_PRINT() {
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo -e "I could not find that element in the database."
  else
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
}


MAIN $1
