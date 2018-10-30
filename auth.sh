#!/bin/bash


# See README for instructions
# Github v3 API docs: https://developer.github.com/v3/
# Non-Web application authentication flow: https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/#non-web-application-flow


# Uncomment the line below to set DEFAULT_PATH to this directory. This will allow you to run these scripts from this directory.
export DEFAULT_PATH=.


# UNSECURE: Important credentials for your Github OAuth application. Once you register an app, add your client ID and secret here to test.
# See: https://developer.github.com/v3/guides/basics-of-authentication/#registering-your-app
CLIENT_ID="XXXXXXXXXXXXXXXXXXXX"
CLIENT_SECRET="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"



# Login function
function login() {

  # Only prompt login flow if LOGGED_IN is set
  if [[ ! -v $LOGGED_IN ]]
  then

    # Prompt user for username
    echo -n "\nPlease enter your Github username: "

    # Save given username to variable
    read githubUsername

    # Create authorization for this application
    # Requires CLIENT_ID, and CLIENT_SECRET
    # See: https://developer.github.com/v3/oauth_authorizations/#create-a-new-authorization
    githubOAuthLogin=$(curl --silent -X PUT "https://api.github.com/authorizations/clients/$CLIENT_ID" \
      -u "$githubUsername" \
      -H "Content-Type: application/json" \
      -d '{
            "client_secret": "'"$CLIENT_SECRET"'",
            "scopes": [
              "repo"
            ],
            "note": "prune oAuth for repo scope"
          }')

    # Retrieve any desired OAuth data from response JSON and save to variables (line 36)
    # See: https://developer.github.com/v3/oauth_authorizations/#response-5
    userToken=$(echo $githubOAuthLogin | jq '.token')

    # Create and format .session.sh, set session data (line 134, line 144)
    resetSession
    setSession_userName "$githubUsername"

    # Only set token or fingerprint if Github API returns one (line 151)
    # See: https://developer.github.com/v3/oauth_authorizations/#response-if-returning-an-existing-token
    # See: https://developer.github.com/v3/oauth_authorizations/#get-or-create-an-authorization-for-a-specific-app-and-fingerprint
    if [[ $#userToken -gt 2 ]]
    then
      setUserToken "$userToken"
    fi

    # Set GITHUB_USER_TOKEN and GITHUB_USERNAME
    source $DEFAULT_PATH/.token.sh
    source $DEFAULT_PATH/.session.sh

    # Create LOGGED_IN in .session.sh
    echo "LOGGED_IN=true" >> .session.sh

    # Display success feedback to user
    echo "\n\tNow logged in as '$GITHUB_USERNAME'.\n"

  else

    # If LOGGED_IN is unset, display error
    echo "\n\tERROR: Already logged in as $GITHUB_USERNAME."
    echo "\n\tPlease logout first using \`logout\` if you would like to log in as another user.\n"
  fi

  # Set LOGGED_IN
  if [[ -a ".session.sh" ]]
  then
    source $DEFAULT_PATH/.session.sh
  fi
}



# Logout function
function logout() {

  # If .session.sh exists, set variables
  if [[ -a ".session.sh" ]]
  then
    source $DEFAULT_PATH/.session.sh
  fi

  # Only logout if user is logged in
  if [[ -v LOGGED_IN ]]
  then

    # Unset session environment variables
    resetSession

    # Delete .session.sh
    rm .session.sh

    # UNSECURE: Unset Github token as environment variable (but do not delete)
    unset GITHUB_USER_TOKEN

    # Display success feedback to user
    echo "\n\tLogged out successfully.\n"

  else

    # If not logged in, prompt user to login
    echo "\n\tLooks like you're not currently logged into the prune Github client."
    echo -n "\n\tWould you like to login? [ Yy / Nn ]: "

    # Save user feedback to variable
    read answer

    # If user replied Y/y, initiate login (line 21)
    case ${ghprune_answer:0:1} in
      y|Y) login;;
      *)   echo " ";;
    esac
  fi
}



# Format .session.sh and unset session environment variables
function resetSession() {
  echo "#!/bin/bash\n" > .session.sh
  source $DEFAULT_PATH/.session.sh
  unset GITHUB_USERNAME
  unset LOGGED_IN
}



# Create Github username session environment variable
function setSession_userName() {
  echo "GITHUB_USERNAME=\"$1\"" >> .session.sh
}



# UNSECURE: Create Github user token environment variable
function setUserToken() {
  echo "#!/bin/bash\n\nGITHUB_USER_TOKEN=$1" > .token.sh
}