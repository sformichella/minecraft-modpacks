GITHUB_USER_NAME=sformichella
GITHUB_REPO_NAME=minecraft-modpacks
GITHUB_API_URL=https://api.github.com/repos/$GITHUB_USER_NAME/$GITHUB_REPO_NAME/releases
GITHUB_URL=https://github.com/$GITHUB_USER_NAME/$GITHUB_REPO_NAME/archive/refs/tags

# Check jq (JSON parser) is installed.
if ! hash jq
then
  echo "jq is not installed on this system."
  exit 1;
fi

# Check release version is provided.
if [ -z ${RELEASE_VERSION+x} ];
then
  echo "Please provide a RELEASE_VERSION."
  exit 1;
fi

# Get release metadata.
RESULT=$(curl -s "$GITHUB_API_URL/tags/v$RELEASE_VERSION")

STATUS=$(echo "$RESULT" | jq -r '.status')

# Check release exists.
if [ $STATUS == 404 ];
then
  echo "v$RELEASE_VERSION was not found."
  exit 1;
fi

# Ensure nothing weird happened.
if [ $STATUS != null ];
then
  echo "Unexpected response status: $STATUS"
  exit 1;
fi

if [ -d "$GITHUB_REPO_NAME-$RELEASE_VERSION" ];
then
  echo "$GITHUB_REPO_NAME-$RELEASE_VERSION is already downloaded"
  exit 0;
else
  mkdir $GITHUB_REPO_NAME-$RELEASE_VERSION;
fi

curl -sL "$GITHUB_URL/v$RELEASE_VERSION.tar.gz" | tar -xz
echo "Done!"
