MODRINTH_URL=https://api.modrinth.com/v2

MODLIST=$(cat create-and-cc-tweaked/modlist.json)

echo "$MODLIST" | jq -c ".[]" |
while read -r MOD;
do
  FILENAME=$(echo "$MOD" | jq -r ".filename")
  URL=$(echo "$MOD" | jq -r ".url")
  VERSION=$(echo "$MOD" | jq -r ".version")
  # echo $FILENAME
  # echo $URL
  # echo $VERSION
  MOD_ID=${URL##*/}

  VERSIONS_RESPONSE=$(
    curl \
    -s \
    --get \
    --data-urlencode "game_versions=[\"1.21.1\"]" \
    --data-urlencode "loaders=[\"neoforge\"]" \
    "$MODRINTH_URL/project/$MOD_ID/version"
  )

  VERSION_URL=$(
    echo $VERSIONS_RESPONSE |
    jq -r ".[].files[] | select(.filename==\"$FILENAME\") | .url"
  )

  # echo $VERSIONS_RESPONSE
  echo $VERSION_URL

  curl "$VERSION_URL" -o "./mods/$FILENAME"
done
