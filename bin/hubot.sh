#!/bin/sh

set -e

npm install
export PATH="node_modules/.bin:node_modules/hubot/node_modules/.bin:$PATH"
export HUBOT_SLACK_TOKEN=xoxb-22321469687-7wkNHMSwBaFdF7Nb3QpYhcUy

exec node_modules/.bin/hubot --name "reminder" "$@"
