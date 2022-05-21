AWSReservedSSO_DeveloperDev_97ddf84b610b91a9:~/environment $  ./stack-setup.sh dev-tst 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 dev-tst
# 
# Definicion de nuestra Alicacion
#
export AJFR_FORCE_DELETE_DEPLOYMMENT_STACK="FALSE"
export AJFR_ENT="AJFR"
export AJFR_APP="scraping"
export AJFR_PROVIDER="af"
export AJFR_BUSINESS_UNIT="automatizacion"
export AJFR_COMPONENT="scraping"
export AJFR_GIT_ORGANIZATION="automatizacionaf"
export AJFR_GIT_REPOSITORY="automatizaacion"

#
# Gestion de acceso VPC y SUBNETS, descomentar si hay lambdas que usen VPC
#
#export AJFR_LAMBDA_VPC_ID="ID DE LA VPC DONDE CORRERAN LAS LAMBDAS"
#export AJFR_LAMBDA_SUBNET_ID_LIST="RELLENAR CON LISTA DE ID DE SUBNETS SEPARADOS POR ; SIN ESPACIOS, QUE USARAN LAS LAMBDAS"

export AJFR_LAMBDA_VPC_ID="vpc-00b33a81d1f6cee7e"

export AJFR_LAMBDA_SUBNET_ID_LIST="subnet-0286a53da6c70c1b6,subnet-0d77a64d56e217ad9,subnet-034e48dfb99c95f22"

# SNS

export AJFR_SNS_EMAIL_LIST_SUBSCRIPTION="consolidated-invoice-result@jetsmart.com"

############
##
## Ini: Gestion de Recursos Heredados 
##

#
# Gestion de Recursos que cumplen con la convenciom de nombres entre Ambientes
#

## Nombre de lambdas refactorizadas
#export AJFR_LAMBDA_NAME_GETODSPAYMENTS="getOdsPayments"
#export AJFR_LAMBDA_NAME_SCHEDULEINVOICE="scheduledInvoicing"
#export AJFR_LAMBDA_NAME_GETPAYMENTTOINVOICE="getPaymentToInvoice"
#export AJFR_LAMBDA_NAME_GETPAYMENTTOTIMEOUT="getPaymentTimeout"
##export AJFR_LAMBDA_NAME_XMLINVOICE="xmlInvoiceGenerator"
##export AJFR_LAMBDA_NAME_GETODSPAYMENTDATA="getOdsPaymentData"
#export AJFR_LAMBDA_NAME_PROCESSPAYMENTDATA="ProcessPaymentData"
#export AJFR_LAMBDA_NAME_INSERTTEMPORARYPAYMENTS="insertTemporaryPayments"
#export AJFR_LAMBDA_NAME_FINISHINVOICEPROCESS="finishInvoicingProcess"
#export AJFR_LAMBDA_NAME_PROCESSCONSOLIDATED="processConsolidated"
#export AJFR_LAMBDA_NAME_SAVECSVTOS3="saveCSVtoS3"
#export AJFR_LAMBDA_NAME_SAVEPDFTOS3="savePDFtoS3"


## Nombre de lambdas para setup
## AJFR-facturacion-afr-dev-mssqlClient
export AJFR_LAMBDA_NAME_MSSQLCLIENT="mssqlClient"

## Nombre de lambdas externas
export AJFR_LAMBDA_EXT_NAME_MAILGUNCLIENT="AJFR-common-functions-nodejs12-dev-mailGunClient"

# SQS 
export AJFR_SQS_VISIBILITYTIMEOUT="300"
export AJFR_SQS_RECEIVEMESSAGEWAITTIMESECONDS="20"
export AJFR_SQS_MESSAGERETENTIONPERIOD="1209600"
export AJFR_SQS_INVOICING_ACTIVACTOR="invoicing-activator.fifo"
export AJFR_SQS_UNCERTAIN_INVOICES="uncertain-invoices"

#
# Gestion de recursos que no cumplen con la convencion de nombres y que cambian entre PROD y otros ambientes
#

export AJFR_CREATE_RESOURCES="true"

# S3 
#PROD -->> AJFR-facturacion-storage-prod : prefix="", postfix="-prod"
#OTROS -->> AJFR-facturacion-ENC-storage : prefix="-ENV", postfix=""
export AJFR_DATA_APP_S3_POSTFIX=""
export AJFR_DATA_APP_S3_PREFIX="-${AJFR_ENV}"
export AJFR_DATA_APP_S3_BUCKET="storage" 
export AJFR_DATA_APP_S3_SNS_FILTER_PATH="DynamodbCsvExported/"
export AJFR_DATA_APP_S3_TEMP_BUCKET="temp" 
export AJFR_DATA_APP_S3_SAM_DEPLOY_BUCKET="sam-deploy"
#Crear S3 para saveCSVtoS3 y savePDFtoS3

# Tablas Dynamo Heredadas: conservan este nombre en producción, en otros Ambientes: agregar "-"" al comienzo del nombre --> se les agregara prefijo AJFR_ENT-AJFR_APP-AJFR-ENVAJFR_DYNAMODB_TABLE_NAME_***
export AJFR_DYNAMODB_DELETE_POLICY='Delete'
export AJFR_DYNAMODB_TABLE_NAME_PREFIX="${AJFR_ENT}-${AJFR_APP}-${AJFR_ENV}-"
export AJFR_DYNAMODB_TABLE_NAME_TEMPORARYPAYMENTS="TemporaryPayments"
export AJFR_DYNAMODB_TABLE_NAME_SUCCESSFULINVOICE="SuccessfulInvoice"

##
##   Otras variables
##
##############################
export AJFR_VAR_CRON_ENABLE="false"

export AJFR_VAR_SQSMESSAGERETENTIONPERIOD="1209600"
export AJFR_VAR_SQSVISIBILITYTIMEOUT="300"
export AJFR_VAR_SQSRECEIVEMESSAGEWAITTIMESECONDS="20"
export AJFR_VAR_FOLDERNAME_TEMP="reconciliation-report/temp"
export AJFR_VAR_FOLDERNAME="reconciliation-report"

export AJFR_VAR_SQSQUEUESNUM="20"
export AJFR_VAR_PREFIX_RECONCILIATION="${AJFR_ENT}-${AJFR_APP}-${AJFR_ENV}-reconciliation-"
export AJFR_VAR_SUFIX=".fifo"
export AJFR_VAR_MAXNUMSQSQUEUESSLACK="50" 
export AJFR_VAR_PREFIX_FINALCIAL="${AJFR_ENT}-${AJFR_APP}-${AJFR_ENV}-financial-"
export AJFR_VAR_SUMMARYFOLDERNAME="financial-report/temp"
export AJFR_VAR_SUMMARYFOLDERRPT="financial-report"


##
## Fin: Gestion de Recursos Heredados 
##
###########
