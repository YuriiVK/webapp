# webapp

Allow to run spot nodes as much as you want, controlled by autoscaling
1. Set parameters actual for your VPC
2. Create SSM paameter store string not secure variables with names:
  /dns/sem       value "available"
  /dns/targets   each string is a target IP/DNS. A node will pick one of target
                 and set $TARGET variable in user_data script. You can use $TARGET
                 in your code here https://github.com/YuriiVK/webapp/blob/main/webapp.yaml#L125-L128
3. Put instruction you wish to run on each node
    https://github.com/YuriiVK/webapp/blob/main/webapp.yaml#L125-L128
4. Deploy stack
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

Available regions: eu-central-1/us-east-1/eu-west-1/us-west-2/eu-west-3/us-north-1/ca-central-1:

SSHAllow - Your external IP that allowed to ssh to instances
By default it will be t2.micro with maximal spot price 0.004$
SSMPrefix - Prefix for SSM parameters by default - dns
