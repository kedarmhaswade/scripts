#!/bin/bash
function exit_the_script_if_failed () {
  STATUS=$?
  if [[ ${STATUS} -ne 0 ]]; then
    echo "Previous command: [$1] failed with exit status: ${STATUS}"
    exit ${STATUS}
  fi
}
CMD="sudo lss"
eval ${CMD}
exit_the_script_if_failed ${CMD}
