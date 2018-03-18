#!/bin/bash

# Execute this file to start the server. You can run it by typing this into your terminal:
# 
#  $ ./run.sh
#

set -euo pipefail

bundle && bundle exec rails server
