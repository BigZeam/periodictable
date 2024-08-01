PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
ATOMIC_NUMBER=1
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
if [[ $1 =~ ^[0-9]+$ ]]
then
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
else
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' or name = '$1'")
fi

if [[ -z $ATOMIC_NUMBER ]]
then
echo I could not find that element in the database.
else 
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")

TABLE_JOIN=$($PSQL "SELECT * FROM properties INNER JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")

echo "$TABLE_JOIN" | while IFS='|' read TYPE_ID NUMBER MASS MELT BOIL TYPE
do
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
done
fi
fi