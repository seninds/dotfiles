#!/bin/bash

export DEPLOY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -r "${DEPLOY_DIR}/.bash/env" ];       then source "${DEPLOY_DIR}/.bash/env";       fi
if [ -r "${DEPLOY_DIR}/.bash/aliases" ];   then source "${DEPLOY_DIR}/.bash/aliases";   fi
if [ -r "${DEPLOY_DIR}/.bash/prompt" ];    then source "${DEPLOY_DIR}/.bash/prompt";    fi
if [ -r "${DEPLOY_DIR}/.bash/functions" ]; then source "${DEPLOY_DIR}/.bash/functions"; fi
if [ -r "${DEPLOY_DIR}/.bash/agents" ];    then source "${DEPLOY_DIR}/.bash/agents";    fi
