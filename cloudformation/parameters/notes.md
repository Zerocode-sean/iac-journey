# Parameters notes

This folder contains parameter files and examples for the S3 CloudFormation stack.

## What parameters are
Parameters let you customize stack behavior without changing the template itself. They are useful for values like bucket names, environments, tags, or retention settings.

## AWS CloudFormation parameter properties
CloudFormation parameters support a set of properties that control the value, validation, and display behavior of a parameter.

The 10 core parameter properties most commonly referenced are:
- `Type`: defines the parameter data type, such as `String`, `Number`, `List<Number>`, or `AWS::SSM::Parameter::Value<String>`
- `Default`: supplies a default value if the user does not provide one
- `AllowedValues`: restricts the user to a fixed list of valid values
- `AllowedPattern`: validates a value against a regex pattern
- `MinLength`: minimum allowed length for a string value
- `MaxLength`: maximum allowed length for a string value
- `ConstraintDescription`: explains the validation rule to the user
- `MinValue`: minimum value for a numeric parameter
- `MaxValue`: maximum value for a numeric parameter
- `NoEcho`: hides the parameter value in the console and logs

Common supporting fields you will also see in many templates:
- `Description`: explains what the parameter is used for

## Example
```yaml
Parameters:
  EnvironmentName:
    Type: String
    Default: dev
    AllowedValues:
      - dev
      - test
      - prod
    Description: Environment name for the stack
    ConstraintDescription: Must be one of dev, test, or prod
```

## SSM parameter type
The `AWS::SSM::Parameter::Value<String>` type is not one of the 10 validation properties listed above. It is a parameter `Type` used to read a value from AWS Systems Manager Parameter Store at deploy time.

Example:
```yaml
Parameters:
  DbPassword:
    Type: AWS::SSM::Parameter::Value<String>
    Description: Password stored in SSM Parameter Store
    Default: /myapp/prod/db/password
```

## AWS-specific parameter types and pseudo parameters
CloudFormation also supports AWS-specific parameter `Type` values and built-in pseudo parameters.

Examples:
- `AWS::EC2::VPC::Id`
- `AWS::EC2::Subnet::Id`
- `AWS::EC2::SecurityGroup::Id`
- `AWS::EC2::KeyPair::KeyName`
- `AWS::SSM::Parameter::Value<String>`
- `AWS::SSM::Parameter::Value<List<String>>`

Pseudo parameters:
- `AWS::AccountId`
- `AWS::Region`
- `AWS::StackName`
- `AWS::StackId`
- `AWS::Partition`
- `AWS::URLSuffix`
- `AWS::NoValue`

## Notes for this project
- Keep parameter names clear and consistent.
- Prefer meaningful defaults only when they are safe and environment-appropriate.
- Use descriptions so other engineers understand the purpose of each value.
- Validate names and values to avoid deployment failures.
- If a value is sensitive, consider using SSM parameter references instead of hardcoding it.

## Best practices
- Use descriptive names such as `BucketName` or `Environment` rather than short vague names.
- Keep parameters grouped logically by purpose.
- Document assumptions in the template or in a companion README.
- Avoid overly broad allowed values unless the stack truly supports them.

## When to use parameters
Use parameters when you want users or automation to supply values at deploy time instead of hardcoding them into the template.
