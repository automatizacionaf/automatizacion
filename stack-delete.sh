#!/bin/bash

set -eu

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
        JAT_BRANCH="develop"
    fi
    if [ "${1}" == "cert" ]; then
        JAT_BRANCH="certification"
    fi
    if [ "${1}" == "prod" ]; then
        JAT_BRANCH="main"
    fi
fi 

if [ "$#" -eq 3 ]; then
    if [ "${1}" == "legacy" ] || [ "${1}" == "dev" ] || [ "${1}" == "cert" ] || [ "${1}" == "prod" ]; then
        echo "Your Environment must be diferent of 'dev' or 'cert' or 'prod' or 'legacy' and start with 'dev-' or 'cert-':"
        echo "  setup-stack needs three arguments. Usage: "
        echo "      setup-stack Your-Environment Your-GitHut-Env-Token Your-GitHub-Branch"
        exit 3
    fi
    JAT_BRANCH="${3}"

    JAT_ENV_START=${JAT_ENV:0:4}
    JAT_BRANCH_START=${JAT_BRANCH:0:4}

    if [ "$JAT_ENV_START" == "dev-" ] && [ "$JAT_BRANCH_START" != "dev-" ]; then
        echo "Your Branch must be start with 'dev-' :"
        echo "  setup-stack needs three arguments. Usage: "
        echo "      setup-stack Your-Environment Your-GitHut-Env-Token Your-GitHub-Branch"
        exit 3
    fi
    JAT_ENV_START=${JAT_ENV:0:5}
    JAT_BRANCH_START=${JAT_BRANCH:0:5}
    if [ "$JAT_ENV_START" == "cert-" ] && [ "$JAT_BRANCH_START" != "cert-" ]; then
        echo "Your Branch must be start with 'cert-' :"
        echo "  setup-stack needs three arguments. Usage: "
        echo "      setup-stack Your-Environment Your-GitHut-Env-Token Your-GitHub-Branch"
        exit 3
    fi
fi

JAT_ENV="${1}"
JAT_TOKEN="${2}"

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

JAT_VARIABLES="${1}"
JAT_VARIABLES_STAR=${JAT_VARIABLES:0:4}
if [ "$JAT_VARIABLES_STAR" == "dev-" ]; then
    echo "Load App variables from ${JAT_VARIABLES}-variables.sh"
    source ./${JAT_VARIABLES}-variables.sh
fi

JAT_VARIABLES_STAR=${JAT_VARIABLES:0:5}
if [ "$JAT_VARIABLES_STAR" == "cert-" ]; then
    echo "Load App variables from ${JAT_VARIABLES}-variables.sh"
    source ./${JAT_VARIABLES}-variables.sh
fi

#########################   END CUSTOM VARIABLE PROJECT DEFINITION ########################
###########################################################################################

if [ "ENV" != "legacy" ]; then
    JAT_APP_ENV="$JAT_APP-${1}"
else
    JAT_ENV="dev"
fi

JAT_SETUP_STACK_NAME="$JAT_ENT-$JAT_APP_ENV-stack-setup"

echo "Stack to Create/Update: $JAT_SETUP_STACK_NAME"

JAT_STACK_INFO=`aws cloudformation describe-stacks --stack-name $JAT_SETUP_STACK_NAME 2>&1 | awk -F ": " 'FNR == 4 { print substr($NF, 2, length($NF) -3 ) }' || echo '' `

echo "APP : $JAT_APP"
echo "ENV : $JAT_ENV"
echo "Stack ID (ARN) : $JAT_STACK_INFO"
echo "BRANCH : $JAT_BRANCH"

if [ "$JAT_STACK_INFO" == "" ]; then
    echo "Creando Stack $JAT_SETUP_STACK_NAME"
    echo "Archivo para deploy: setup.yml"

    aws cloudformation create-stack \
        --stack-name $JAT_SETUP_STACK_NAME \
        --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND\
        --region us-east-2 \
        --parameters \
            ParameterKey=App,ParameterValue=$JAT_APP \
            ParameterKey=Env,ParameterValue=$JAT_ENV \
            ParameterKey=GitHubOAuthToken,ParameterValue=$JAT_TOKEN \
            ParameterKey=GitHubRepo,ParameterValue=$JAT_REPOSITORY \
            ParameterKey=GitHubBranch,ParameterValue=$JAT_BRANCH \
            ParameterKey=ForceDeleteDeploymentStack,ParameterValue=$JAT_FORCE_DELETE_DEPLOYMMENT_STACK \
            ParameterKey=LambdaVpcId,ParameterValue=$JAT_LAMBDA_VPC_ID \
            ParameterKey=LambdaSubnetListId,ParameterValue=\"$JAT_LAMBDA_SUBNET_ID_LIST\" \
            ParameterKey=SumologicQueue,ParameterValue=$JAT_SUMOLOGIC_SQS_ENDPOINT \
            ParameterKey=SumologicHost,ParameterValue=$JAT_SUMOLOGIC_HOST \
            ParameterKey=SumologicPath,ParameterValue=$JAT_SUMOLOGIC_PATH \
            ParameterKey=RDSPort,ParameterValue=$JAT_MYSQL_PORT \
            ParameterKey=RDSArn,ParameterValue=$JAT_MYSQL_ARN \
            ParameterKey=RDSUsername,ParameterValue=$JAT_MYSQL_USER \
            ParameterKey=RDSPassword,ParameterValue=\"$JAT_MYSQL_PASS\" \
            ParameterKey=RDSPassRotTime,ParameterValue=$JAT_MYSQL_PASS_ROTATION_TIME \
            ParameterKey=RDSBaseName,ParameterValue=$JAT_MYSQL_DBNAME \
            ParameterKey=mssqlODSUser,ParameterValue=$JAT_MSSQLODSUSER \
            ParameterKey=mssqlODSPassword,ParameterValue=\"$JAT_MSSQLODSPASSWORD\" \
            ParameterKey=mssqlODSServer,ParameterValue=$JAT_MSSQLODSSERVER \
            ParameterKey=mssqlODSPort,ParameterValue=$JAT_MSSQLODSPORT \
            ParameterKey=mssqlODSStream,ParameterValue=$JAT_MSSQLODSSTREAM \
            ParameterKey=mssqlODSDatabase,ParameterValue=$JAT_MSSQLODSDATABASE \
            ParameterKey=mssqlODSRequestTimeout,ParameterValue=$JAT_MSSQLODSREQUESTTIMEOUT \
            ParameterKey=mssqlODSEncrypt,ParameterValue=$JAT_MSSQLODSENCRYPT \
            ParameterKey=mssqlODSCompressData,ParameterValue=$JAT_MSSQLODSCOMPRESSDATA \
            ParameterKey=mssqlODSFullResult,ParameterValue=$JAT_MSSQLODSFULLRESULT \
        --template-body file://setup.yml
else
    echo "Actualizar Stack $JAT_SETUP_STACK_NAME"
    aws cloudformation update-stack \
        --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
        --region us-east-2 \
        --stack-name $JAT_SETUP_STACK_NAME \
        --parameters \
            ParameterKey=App,ParameterValue=$JAT_APP \
            ParameterKey=Env,ParameterValue=$JAT_ENV \
            ParameterKey=GitHubOAuthToken,ParameterValue=$JAT_TOKEN \
            ParameterKey=GitHubRepo,ParameterValue=$JAT_REPOSITORY \
            ParameterKey=GitHubBranch,ParameterValue=$JAT_BRANCH \
            ParameterKey=ForceDeleteDeploymentStack,ParameterValue=$JAT_FORCE_DELETE_DEPLOYMMENT_STACK \
            ParameterKey=LambdaVpcId,ParameterValue=$JAT_LAMBDA_VPC_ID \
            ParameterKey=LambdaSubnetListId,ParameterValue=\"$JAT_LAMBDA_SUBNET_ID_LIST\" \
            ParameterKey=SumoLogicQueue,ParameterValue=$JAT_SUMOLOGIC_SQS_ENDPOINT \
            ParameterKey=SumologicHost,ParameterValue=$JAT_SUMOLOGIC_HOST \
            ParameterKey=SumologicPath,ParameterValue=$JAT_SUMOLOGIC_PATH \
            ParameterKey=RDSPort,ParameterValue=$JAT_MYSQL_PORT \
            ParameterKey=RDSArn,ParameterValue=$JAT_MYSQL_ARN \
            ParameterKey=RDSUsername,ParameterValue=$JAT_MYSQL_USER \
            ParameterKey=RDSPassword,ParameterValue=\"$JAT_MYSQL_PASS\" \
            ParameterKey=RDSPassRotTime,ParameterValue=$JAT_MYSQL_PASS_ROTATION_TIME \
            ParameterKey=RDSBaseName,ParameterValue=$JAT_MYSQL_DBNAME \
            ParameterKey=mssqlODSUser,ParameterValue=$JAT_MSSQLODSUSER \
            ParameterKey=mssqlODSPassword,ParameterValue=\"$JAT_MSSQLODSPASSWORD\" \
            ParameterKey=mssqlODSServer,ParameterValue=$JAT_MSSQLODSSERVER \
            ParameterKey=mssqlODSPort,ParameterValue=$JAT_MSSQLODSPORT \
            ParameterKey=mssqlODSStream,ParameterValue=$JAT_MSSQLODSSTREAM \
            ParameterKey=mssqlODSDatabase,ParameterValue=$JAT_MSSQLODSDATABASE \
            ParameterKey=mssqlODSRequestTimeout,ParameterValue=$JAT_MSSQLODSREQUESTTIMEOUT \
            ParameterKey=mssqlODSEncrypt,ParameterValue=$JAT_MSSQLODSENCRYPT \
            ParameterKey=mssqlODSCompressData,ParameterValue=$JAT_MSSQLODSCOMPRESSDATA \
            ParameterKey=mssqlODSFullResult,ParameterValue=$JAT_MSSQLODSFULLRESULT \
        --template-body file://setup.yml
fi

aws secretsmanager  delete-secret --secret-id jat-core-workflow-voucher-dev-sb1-rds-voucher-secret --force-delete-without-recovery
aws secretsmanager  delete-secret --secret-id jat-core-workflow-voucher-dev-sb1-ods-secret --force-delete-without-recovery
aws secretsmanager  delete-secret --secret-id jat-core-workflow-voucher-dev-sb1-sumologic-secret --force-delete-without-recovery