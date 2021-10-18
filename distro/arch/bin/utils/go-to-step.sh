#!/bin/bash

STEP_FILE="/tmp/set-up-arch--step"
function goToStep {
  currentStep=$1
  cmd=$(sed -n "/$currentStep:/{:a;n;p;ba};" $0 | grep -v ':$')
  eval "$cmd"
  exit
}
