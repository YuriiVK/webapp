REGION=$(hostname | awk -F. '{print $2}')
PREFIX=$1 #prefix for parameters
#generate rendom for timeouts, up to 10 sec
R=$((1+$RANDOM % 10))
declare -a TARGETS
while [ "$SEM" != "$(hostname)" ]; do
  while [ "$SEM" != "available" ]; do
    sleep $R
    SEM=$(aws ssm get-parameter --name "/dns/sem" --region $REGION|jq -r .Parameter.Value)
  done
  #set parameter write lock in the semaphore
  aws ssm put-parameter --name "/dns/sem" --overwrite --region $REGION --value $(hostname)
  sleep $R
  #check if lock successful
  SEM=$(aws ssm get-parameter --name "/dns/sem" --region $REGION|jq -r .Parameter.Value)
done
#get first element as TARGET and shift it to the end of array
TARGETS=($(aws ssm get-parameter --name "/dns/targets" --region $REGION|jq -r .Parameter.Value))
#get first TARGET from SSM parameter and rotate massive
TARGET=${TARGETS[0]}
unset TARGETS[0]
TARGETS+=($TARGET)
echo ------------TARGET=$TARGET-------------------
#update rotated TARGETS in the SSM parameter
T=$(printf "%s\n" "${TARGETS[@]}")
aws ssm put-parameter --name "/dns/targets" --overwrite --region $REGION --value "$T"
#release lock
aws ssm put-parameter --name "/dns/sem" --overwrite --region $REGION --value "available"
