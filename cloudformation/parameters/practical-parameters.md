# Practical parameter exercise for EC2

This file is designed as a hands-on learning guide for CloudFormation parameters. It breaks the practice into four mini templates and ends with one full combined example.

## Learning objective
Practice these four parameter patterns:

1. Use an AWS-specific parameter type for `KeyName`
2. Use a plain `String` parameter for `AvailabilityZone`
3. Use a plain `String` parameter for `InstanceType`
4. Use an SSM-backed parameter for `InstanceType`

Important: in a real template, use only one source for the instance type value at a time.

---

## Step 1: AWS-specific parameter type for EC2 KeyName

### Mini template
```yaml
Parameters:
  KeyName:
    Type: AWS::EC2::KeyPair::KeyName
    Description: Name of an existing EC2 key pair

Resources:
  WebServer:
    Type: AWS::EC2::Instance
    Properties:
      KeyName: !Ref KeyName
      ImageId: ami-0c02fb55956c7d316
      InstanceType: t3.micro
```

### Why this matters
- `AWS::EC2::KeyPair::KeyName` is AWS-specific.
- It ensures the key pair already exists.

---

## Step 2: String parameter for Availability Zone

### Mini template
```yaml
Parameters:
  AvailabilityZone:
    Type: String
    Default: us-east-1a
    AllowedValues:
      - us-east-1a
      - us-east-1b
      - us-east-1c
    Description: Availability zone for the EC2 instance

Resources:
  WebServer:
    Type: AWS::EC2::Instance
    Properties:
      AvailabilityZone: !Ref AvailabilityZone
      ImageId: ami-0c02fb55956c7d316
      InstanceType: t3.micro
```

### Why this matters
- This is the simplest parameter pattern.
- You can validate the value with `AllowedValues`.

---

## Step 3: String parameter for InstanceType

### Mini template
```yaml
Parameters:
  InstanceType:
    Type: String
    Default: t3.micro
    AllowedValues:
      - t2.micro
      - t3.micro
      - t3.small
      - t3.medium
    Description: EC2 instance type for the workload

Resources:
  WebServer:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: !Ref InstanceType
      ImageId: ami-0c02fb55956c7d316
```

### Why this matters
- This is the normal way to collect instance size at deploy time.
- `AllowedValues` prevents invalid instance sizes.

---

## Step 4: SSM-backed parameter for InstanceType

### Prerequisite: create the SSM parameter
```bash
aws ssm put-parameter \
  --name "/ec2/instance-type" \
  --value "t3.micro" \
  --type "String" \
  --overwrite
```

### Mini template
```yaml
Parameters:
  InstanceTypeFromSSM:
    Type: AWS::SSM::Parameter::Value<String>
    Default: /ec2/instance-type
    Description: EC2 instance type stored in SSM Parameter Store

Resources:
  WebServer:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: !Ref InstanceTypeFromSSM
      ImageId: ami-0c02fb55956c7d316
```

### Why this matters
- The value is managed outside the template in SSM.
- This is useful for shared configuration values and secrets.

---

## Final combined template

```yaml
Parameters:
  KeyName:
    Type: AWS::EC2::KeyPair::KeyName
    Description: Name of an existing EC2 key pair

  AvailabilityZone:
    Type: String
    Default: us-east-1a
    AllowedValues:
      - us-east-1a
      - us-east-1b
      - us-east-1c
    Description: Availability zone for the EC2 instance

  InstanceType:
    Type: String
    Default: t3.micro
    AllowedValues:
      - t2.micro
      - t3.micro
      - t3.small
      - t3.medium
    Description: EC2 instance type for the workload

  InstanceTypeFromSSM:
    Type: AWS::SSM::Parameter::Value<String>
    Default: /ec2/instance-type
    Description: EC2 instance type stored in SSM Parameter Store

Resources:
  WebServer:
    Type: AWS::EC2::Instance
    Properties:
      KeyName: !Ref KeyName
      AvailabilityZone: !Ref AvailabilityZone
      InstanceType: !Ref InstanceTypeFromSSM
      ImageId: ami-0c02fb55956c7d316
```

### Important note
In production, choose one instance type source at a time. The combined example is only for learning how each type works.

---

## Summary

1. `AWS::EC2::KeyPair::KeyName` = AWS-specific resource validation
2. `String` = user-entered value with validation
3. `String` = common instance type input
4. `AWS::SSM::Parameter::Value<String>` = value read from SSM Parameter Store

This gives you a clean practice flow for understanding AWS CloudFormation parameters.
