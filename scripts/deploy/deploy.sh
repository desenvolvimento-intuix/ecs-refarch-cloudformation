################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "PARAMETER 1 : database script name "
   echo "PARAMETER 2 : intuix user password "
   echo "SYNTAX : sh ./scripts/deploy.sh 'script_name' 'password' "
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
   esac
done

#upload files in S3
aws s3 sync . s3://intuix-infrastructure  --exclude 'scripts/deploy/.env.json' \
                                           --exclude '.git/*' \
                                           --exclude '.gitignore' \
                                           --exclude 'README.md'
                          
                          
# #deploy template on cloudformation
aws cloudformation deploy \
    --template-file ./master.yaml \
    --stack-name intuix-cluster \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides file://./scripts/deploy/.env.json
    

if [ ! -z "$1" ]; then
     PGPASSWORD=$2 psql \
     -h auroracluster.cluster-cibh5tsssve7.us-east-1.rds.amazonaws.com \
     -d cosecurity \
     -U cosecurity \
     -p 5432 \
     -a -q -f ./database/$1
fi
