# webapp

Allow to run spot nodes as much as you want, controlled by autoscaling
1. Change subnets to correct value
   https://github.com/YuriiVK/webapp/blob/main/webapp.yaml#L54-L56
2. Put instruction to run on each node
   https://github.com/YuriiVK/webapp/blob/main/webapp.yaml#L103-L106
3. Set parameters actual for you and deploy stack
```
KeyName=lenovo
SSHAllow='90.230.54.217/32'
AppName="Web-APP-$(date +%Y%m%dT%H%M%S)"
VPC='vpc-802220eb'
SubnetIds='subnet-34777779, subnet-80444beb, subnet-b58222c8'
NodesCount=3
SSMPrefix='dns'
aws cloudformation create-stack --stack-name $AppName \
--parameters ParameterKey=KeyName,ParameterValue=$KeyName \
             ParameterKey=SSHAllow,ParameterValue=$SSHAllow \
             ParameterKey=AppName,ParameterValue=$AppName \
             ParameterKey=VPC,ParameterValue=$VPC \
             ParameterKey=SubnetIds,ParameterValue=$SubnetIds \
             ParameterKey=NodesCount,ParameterValue=$NodesCount \
             ParameterKey=SSMPrefix,ParameterValue=$SSMPrefix \
--capabilities CAPABILITY_IAM --template-body file://webapp.yaml
```
 SSHAllow - Your external IP that allowed to ssh to instances
 By default it will be t2.micro with maximal spot price 0.004$
 Works for region eu-central-1 and us-east-1, it's easy extendable.
