#!/bin/sh

set -e

npm install
export PATH="node_modules/.bin:node_modules/hubot/node_modules/.bin:$PATH"
export HUBOT_SLACK_TOKEN=`cat .hubot_slack_token`

exec node_modules/.bin/hubot --adapter slack --name "reminder" "$@"

