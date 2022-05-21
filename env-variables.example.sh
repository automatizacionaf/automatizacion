#
# Definicion de nuestra Alicacion
#
export JAT_FORCE_DELETE_DEPLOYMMENT_STACK="FALSE"
export JAT_ENT="jat"
export JAT_APP="facturacion"
export JAT_GIT_ORGANIZATION="FlyJetSmart"
export JAT_GIT_REPOSITORY="jetsmart-facturacion-lambda"

#
# Gestion de acceso VPC y SUBNETS, descomentar si hay lambdas que usen VPC
#
#export JAT_LAMBDA_VPC_ID="ID DE LA VPC DONDE CORRERAN LAS LAMBDAS"
#export JAT_LAMBDA_SUBNET_ID_LIST="RELLENAR CON LISTA DE ID DE SUBNETS SEPARADOS POR ; SIN ESPACIOS, QUE USARAN LAS LAMBDAS"

#
# Gestion de acceso a Sumologic
#
export JAT_SUMOLOGIC_HOST="SUMO LOGIC SERVER sin https://"
export JAT_SUMOLOGIC_PATH="SUMOLOGIC PATH"
export JAT_SUMOLOGIC_SQS_ENDPOINT="SUMOLOGIC QUEUE ENDPOINT"

#
# Gestion de acceso a RDS/MYSQL
#
export JAT_MYSQL_ARN="ARN DE LA INSTACIA DE BASE DE DATOS A UTILIZAR"
export JAT_MYSQL_PORT="PUERTO DE LA BASE DE DATOS"
export JAT_MYSQL_USER="USUARIO CREADO EN LA INSTANCIA DE BASES DE DATOS A UTILIZAR"
export JAT_MYSQL_PASS_ROTATION_TIME="TIEMPO EN DIAS EN QUE SE REALIZARA ROTACION DE LA PASS DE MYSQL_USER"
export JAT_MYSQL_DBNAME="voucher"

#
# Gestion de acceso a ODS
#
export JAT_MSSQLODSUSER="ODS USER FOR APP"
export JAT_MSSQLODSPASSWORD="ODS PASSWORD FOR APP"
export JAT_MSSQLODSSERVER="ODS SERVER FOR APP"
export JAT_MSSQLODSPORT="ODS PORT FOR APP"
export JAT_MSSQLODSSTREAM="ODS STREAM true or false, FOR APP (true)"
export JAT_MSSQLODSDATABASE="ODS DATABASE FOR APP"
export JAT_MSSQLODSREQUESTTIMEOUT="ODS REQUEST TIMEOUT FOR APP"
export JAT_MSSQLODSENCRYPT="ODS ENCRYPT true or false, FOR APP (false)"
export JAT_MSSQLODSCOMPRESSDATA="ODS COMPRESS DATA true or false, FOR APP (true)"
export JAT_MSSQLODSFULLRESULT="ODA FULL RESULT true or false, FOR APP (false)"

# #
# # Gestion de acceso a Navitaire
# #
# export JAT_NAV_TOK_CRED_USERNAME="NAVITAIRE USER FOR APP"
# export JAT_NAV_TOK_CRED_PASSWORD="NAVITAIRE PASSWORDS FOR APP"
# export JAT_NAV_TOK_CRED_ALTERNATE_IDENTIFIER="NAVITAIRE ALTERNATIVE USER IDENTIFIER FOR APP"
# export JAT_NAV_TOK_CRED_DOMAIN="NAVITAIRE DOMAIN FOR APP"
# export JAT_NAV_TOK_CRED_LOCATION="NAVITAIRE LOCATION FOR APP"
# export JAT_NAV_TOK_CRED_CHANNEL_TYPE="NAVITAIRE CHANNEL TYPE FOR APP"
# export JAT_NAV_TOK_CRED_APPLICATION_NAME="NAVITAIRE APLICATION NAME FOR APP = JAT_APP"
# export JAT_NAV_TOK_CRED_LOGIN_ROLE=""
# export JAT_NAV_TOKEN_URL="NAVITAIRE GET TOKEN FOR APP"


# SNS

export JAT_SNS_EMAIL_LIST_SUBSCRIPTION="consolidated-invoice-result@jetsmart.com"

############
##
## Ini: Gestion de Recursos Heredados 
##

#
# Gestion de Recursos que cumplen con la convenciom de nombres entre Ambientes
#

## Nombre de lambdas refactorizadas
export JAT_LAMBDA_NAME_SCHEDULEINVOICE="scheduledInvoicing"
export JAT_LAMBDA_NAME_GETPAYMENTTOINVOICE="getPaymentToInvoice"
export JAT_LAMBDA_NAME_GETPAYMENTTOTIMEOUT="getPaymentTimeout"
export JAT_LAMBDA_NAME_XMLINVOICE="xmlInvoiceGenerator"

## Nombre de lambdas externas
export JAT_LAMBDA_ARN_DYNAMODB_EXPORT="arn:aws:lambda:AWS_REGION:AWS_ACCOUNT:function:jat-common-functions-v2-${JAT_ENV}-fn-dynamo-export-to-csv"
export JAT_LAMBDA_NAME_DYNAMODB_EXPORT="jat-common-functions-v2-${JAT_ENV}-fn-dynamo-export-to-csv"

# SQS 
export JAT_SQS_SEND_PAYMENTS="payments-to-invoice.fifo"
export JAT_SQS_PAYMENTS_TIMEOUT="payments-timeout.fifo"

#
# Gestion de recursos que no cumplen con al convencion de nombres y que cambian entre PROD y otros ambientes
#

export JAT_CREATE_RESOURCES="true"

# S3 
#PROD -->> jat-facturacion-storageprod : prefix="", postfix="-prod"
#OTROS -->> jat-facturacion-ENC-storage : prefix="-ENV", postfix=""
export JAT_DATA_APP_S3_POSTFIX="-prod"
export JAT_DATA_APP_S3_PREFIX=""
export JAT_DATA_APP_S3_BUCKET="storage" 
export JAT_DATA_APP_S3_SNS_FILTER_PATH="DynamodbCsvExported/"

# Tablas Dynamo Heredadas: conservan este nombre en producción, en otros Ambientes: agregar "-"" al comienzo del nombre --> se les agregara prefijo JAT_ENT-JAT_APP-JAT-ENVJAT_DYNAMODB_TABLE_NAME_***
export JAT_DYNAMODB_TABLE_NAME_PREFIX=""
export JAT_DYNAMODB_TABLE_NAME_SUCCESSFULINVOICE="SuccessfulInvoice"
export JAT_DYNAMODB_TABLE_NAME_UNSUCCESSFULINVOICE="UnSuccessfulInvoice"
export JAT_DYNAMODB_TABLE_NAME_TEMPORARYPAYMENTS="TemporaryPayments"

##
## Fin: Gestion de Recursos Heredados 
##
###########