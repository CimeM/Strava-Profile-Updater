# Required ENV variables:
#  STRAVA_CLIENT_SECRET=
#  STRAVA_ACCESS_TOKEN=
#  STRAVA_CLIENT_ID=
#  REFRESH_TOKEN_FILE=
#  STRAVA_ATHLETE_ID=

# //////////////////////////////////////////////////////////////////
#  run from this point on if you already have the refresh token 
#  saved in the file
# //////////////////////////////////////////////////////////////////

# read the refresh token if it exists
if test -f "$REFRESH_TOKEN_FILE"; then
    STRAVA_REFRESH_TOKEN=$(cat $REFRESH_TOKEN_FILE)
else
    echo "refresh token file does not exist"
fi

#echo $STRAVA_REFRESH_TOKEN

# refresh the access token -
response=$(curl -X POST https://www.strava.com/oauth/token -F client_id=$STRAVA_CLIENT_ID -F client_secret=$STRAVA_CLIENT_SECRET -F refresh_token=$STRAVA_REFRESH_TOKEN -F grant_type=refresh_token)

# response example
# {"token_type":"Bearer","access_token":"","expires_at":,"expires_in":,"refresh_token":""}

STRAVA_ACCESS_TOKEN=$(echo $response | jq '.access_token' | tr -d '"')
STRAVA_REFRESH_TOKEN=$(echo $response | jq '.refresh_token' | tr -d '"')

#echo $STRAVA_ACCESS_TOKEN
#echo $STRAVA_REFRESH_TOKEN

response=$( curl -X GET https://www.strava.com/api/v3/athletes/$STRAVA_ATHLETE_ID/stats -H 'Authorization: Bearer '$STRAVA_ACCESS_TOKEN )

echo $response

response=$(curl -X GET https://www.strava.com/api/v3/athletes/$STRAVA_ATHLETE_ID/activities -H 'Authorization: Bearer '$STRAVA_ACCESS_TOKEN)

echo $response

# save the token for re-use 
echo $STRAVA_REFRESH_TOKEN > $REFRESH_TOKEN_FILE


