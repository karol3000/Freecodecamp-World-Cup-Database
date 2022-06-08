#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams")"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != 'winner' ]]
then
  #get winner team_id
  WINNER_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
  #if no winner team_id
  if [[ -z $WINNER_TEAM_ID ]]
  then
    #add winner to teams table
    INSERT_TEAM_RESPONSE="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
    if [[ $INSERT_TEAM_RESPONSE == 'INSERT 0 1' ]]
    then
      echo Inserted $WINNER
      #get winner team_id
      WINNER_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    fi
  fi

  #get opponent team_id
  OPPONENT_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
  #if no opponent team_id
  if [[ -z $OPPONENT_TEAM_ID ]]
  then
    #add opponent to teams table
    INSERT_TEAM_RESPONSE="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    if [[ $INSERT_TEAM_RESPONSE == 'INSERT 0 1' ]]
    then
      echo Inserted $OPPONENT
      #get opponent team_id
      OPPONENT_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    fi
  fi

  #add row to games
  INSERT_GAME_RESPONSE="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
    VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
    if [[ $INSERT_GAME_RESPONSE == 'INSERT 0 1' ]]
    then
     echo Inserted $YEAR, $ROUND, $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS
    fi
fi
done
