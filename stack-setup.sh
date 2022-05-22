#!/bin/bash
#set -eu
AJFR_ENV="${1}"
AJFR_GIT_TOKEN="${2}"

if [ "$#" -lt 2 ]; then 
    echo "Usage : "
    echo "  Opt 1) setup-stack Environment GitHut-Env-Token "
    echo "      Environments must be one of this --> 'dev', 'cert', 'prod', 'legacy'"
    echo ""
    echo "  Opt 2) setup-stack MyEnvironment My-GitHut-Env-Token My-GitHub-Branch"
    echo "      MyEnvironment = 'xyzd'"
    exit 1
fi 
if [ "$#" -eq 2 ]; then
    if [ "${1}" != "legacy" ] && [ "${1}" != "dev" ] &&  [ "${1}" != "cert" ] && [ "${1}" != "prod" ]; then
        echo "Environments must be one of this --> 'dev' or 'cert' or 'prod' or 'legacy':"
        echo "  Usage: "
        echo "      setup-stack Environment GitHut-Env-Token"
        exit 2
    fi
    if [ "${1}" == "legacy" ] || [ "${1}" == "dev" ]; then 
        AJFR_GIT_BRANCH="develop"
    fi
    if [ "${1}" == "cert" ]; then
        AJFR_GIT_BRANCH="certification"
    fi
    if [ "${1}" == "prod" ]; then
        AJFR_GIT_BRANCH="main"
    fi
fi 
if [ "$#" -eq 3 ]; then
    if [ "${1}" == "legacy" ] || [ "${1}" != "dev" ] || [ "${1}" == "cert" ] || [ "${1}" == "prod" ]; then
        echo "Your Environment must be diferent of 'dev' or 'cert' or 'prod' or 'legacy' and start with 'dev-' or 'cert-':"
        echo "  setup-stack needs three arguments. Usage: "
        echo "      setup-stack Your-Environment Your-GitHut-Env-Token Your-GitHub-Branch"
        exit 3
    fi
    AJFR_GIT_BRANCH="${3}"

    AJFR_ENV_START=${AJFR_ENV:0:4}
    AJFR_GIT_BRANCH_START=${AJFR_GIT_BRANCH:0:4}

    if [ "$AJFR_ENV_START" == "dev" ] && [ "$AJFR_GIT_BRANCH_START" != "dev" ]; then
        echo "Your Branch must be start with 'dev-' :"
        echo "  setup-stack needs three arguments. Usage: "
        echo "      setup-stack Your-Environment Your-GitHut-Env-Token Your-GitHub-Branch"
        exit 3
    fi
    AJFR_ENV_START=${AJFR_ENV:0:5}
    AJFR_GIT_BRANCH_START=${AJFR_GIT_BRANCH:0:5}
    if [ "$AJFR_ENV_START" == "cert-" ] && [ "$AJFR_GIT_BRANCH_START" != "cert-" ]; then
        echo "Your Branch must be start with 'cert-' :"
        echo "  setup-stack needs three arguments. Usage: "
        echo "      setup-stack Your-Environment Your-GitHut-Env-Token Your-GitHub-Branch"
        exit 3
    fi
fi
###########################################################################################
#########################   START CUSTOM VARIABLE PROJECT DEFINITION ######################
if [ "${1}" == "dev" ]; then
    echo "Load App variables from dev-variables.sh"
    source ./dev-variables.sh
fi

if [ "${1}" == "cert" ]; then
    echo "Load App variables from cert-variables.sh"
    source ./cert-variables.sh
fi

if [ "${1}" == "prod" ]; then
    echo "Load App variables from prod-variables.sh"
    source ./prod-variables.sh
fi

AJFR_VARIABLES="${1}"
AJFR_VARIABLES_STAR=${AJFR_VARIABLES:0:4}
if [ "$AJFR_VARIABLES_STAR" == "dev-" ]; then
    echo "Load App variables from ${AJFR_VARIABLES}-variables.sh"
    source ./${AJFR_VARIABLES}-variables.sh
fi

AJFR_VARIABLES_STAR=${AJFR_VARIABLES:0:5}
if [ "$AJFR_VARIABLES_STAR" == "cert-" ]; then
    echo "Load App variables from ${AJFR_VARIABLES}-variables.sh"
    source ./${AJFR_VARIABLES}-variables.sh
fi

#########################   END CUSTOM VARIABLE PROJECT DEFINITION ########################
###########################################################################################

if [ "ENV" != "legacy" ]; then
    AJFR_APP_ENV="$AJFR_APP-${1}"
else
    AJFR_ENV="dev"
fi

AJFR_SETUP_STACK_NAME="$AJFR_ENT-$AJFR_APP_ENV-stack-setup"

echo "Stack to Create/Update: $AJFR_SETUP_STACK_NAME"

AJFR_STACK_INFO=`aws cloudformation describe-stacks --stack-name $AJFR_SETUP_STACK_NAME 2>&1 | awk -F ": " 'FNR == 4 { print substr($NF, 2, length($NF) -3 ) }' || echo '' `

echo "APP : $AJFR_APP"
echo "ENV : $AJFR_ENV"
echo "Stack ID (ARN) : $AJFR_STACK_INFO"
echo "BRANCH : $AJFR_GIT_BRANCH"
echo "SHELL :  $SHELL"

cp setup.yml setup_tmp.yml
for varname in "${!AJFR_@}"
do
    echo "s;$varname;${!varname};g"
    if [ "$SHELL" == "/bin/bash" ]; then
        sed -i "s;$varname;${!varname};g" setup_tmp.yml
    else 
        sed -i '' "s;$varname;${!varname};g" setup_tmp.yml
    fi
done

if [ "$AJFR_STACK_INFO" == "" ]; then
    echo "Creando Stack $AJFR_SETUP_STACK_NAME"
    echo "Archivo para deploy: setup.yml"

    aws cloudformation create-stack \
        --stack-name $AJFR_SETUP_STACK_NAME \
        --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND\
        --region us-east-2 \
        --template-body file://setup_tmp.yml
else
    echo "Actualizar Stack $AJFR_SETUP_STACK_NAME"
    aws cloudformation update-stack \
        --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
        --region us-east-2 \
        --stack-name $AJFR_SETUP_STACK_NAME \
        --template-body file://setup_tmp.yml
fi