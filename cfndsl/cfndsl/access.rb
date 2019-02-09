# frozen_string_literal: true
# rubocop:disable Metrics/BlockLength
# rubocop:disable Metrics/LineLength

# Access
# Version: 1.0
# Author: BB8

stack = 'access'

require 'cfndsl'
require 'securerandom'
require 'colorize'

CloudFormation do
  params = {}
  external_parameters.each_pair do |key, val|
    key = key.to_sym
    params[key] = val
  end

  env = params[:env]
  Env = env.capitalize
  ENV = env.upcase
  Description Env + ' Environment ' + stack.upcase + ' - Read only access to S3 bucket.'

  # Script Parameters
  Parameter(:User) do
    Description 'Username'
    Type String
  end

  Parameter(:Password) do
    Description 'Password'
    Type String
    NoEcho true
  end

  IAM_User(:OurUser) do
    UserName Ref(:User)
    LoginProfile(
      Password: Ref(:Password)
    )
  end

  Output(:OurUser) do
    Value Ref(:OurUser)
    Export FnJoin('-', [Ref('AWS::StackName'), 'OurUser'])
  end

  IAM_Policy('S3ReadPolicy') do
    PolicyDocument(
      Version: '2012-10-17',
      Statement: [
        {
          Effect: 'Allow',
          Action: [
            's3:ListBucketByTags',
            's3:GetLifecycleConfiguration',
            's3:GetBucketTagging',
            's3:GetInventoryConfiguration',
            's3:GetObjectVersionTagging',
            's3:ListBucketVersions',
            's3:GetBucketLogging',
            's3:ListBucket',
            's3:GetAccelerateConfiguration',
            's3:GetBucketPolicy',
            's3:GetObjectAcl',
            's3:GetEncryptionConfiguration',
            's3:GetBucketRequestPayment',
            's3:GetObjectVersionAcl',
            's3:GetObjectTagging',
            's3:GetMetricsConfiguration',
            's3:HeadBucket',
            's3:GetBucketPublicAccessBlock',
            's3:GetBucketPolicyStatus',
            's3:ListBucketMultipartUploads',
            's3:GetBucketWebsite',
            's3:GetBucketVersioning',
            's3:GetBucketAcl',
            's3:GetBucketNotification',
            's3:GetReplicationConfiguration',
            's3:ListMultipartUploadParts',
            's3:GetAccountPublicAccessBlock',
            's3:ListAllMyBuckets',
            's3:GetBucketCORS',
            's3:GetAnalyticsConfiguration',
            's3:GetBucketLocation'
          ],
          Resource: '*'
        }
      ]
    )
    PolicyName 'S3ReadPolicy'
    Users [Ref(:OurUser)]
  end

  # Preferred Stack name
  StackName = 'Preferred Stack name: '.green + "#{tags['ClientID']}-#{stack}-#{env}".yellow + "\n"
  File.write('temp', StackName, mode: 'a')
end

# rubocop:enable Metrics/BlockLength
# rubocop:enable Metrics/LineLength