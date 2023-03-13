# Use this code snippet in your app.
# If you need more information about configurations or implementing the sample code, visit the AWS docs:   
# https://aws.amazon.com/developers/getting-started/python/

import json
import base64
import os
import boto3
import base64
from botocore.exceptions import ClientError

# For capturing the values from the injected environment variable
def get_secret_dict_env(secret_name):
    secret_val = os.getenv(secret_name, None)
    secret_dict = json.loads(secret_val)
    return secret_dict

# Works if the container can access the secretsmanager as a ecstask
def get_secret_dict_cli(secret_name):
    # secret_name = "MPI_SSH_KEY"
    region_name = "us-east-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    # In this sample we only handle the specific exceptions for the 'GetSecretValue' API.
    # See https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    # We rethrow the exception by default.

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        if e.response['Error']['Code'] == 'DecryptionFailureException':
            # Secrets Manager can't decrypt the protected secret text using the provided KMS key.
            # Deal with the exception here, and/or rethrow at your discretion.
            raise e
        elif e.response['Error']['Code'] == 'InternalServiceErrorException':
            # An error occurred on the server side.
            # Deal with the exception here, and/or rethrow at your discretion.
            raise e
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            # You provided an invalid value for a parameter.
            # Deal with the exception here, and/or rethrow at your discretion.
            raise e
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            # You provided a parameter value that is not valid for the current state of the resource.
            # Deal with the exception here, and/or rethrow at your discretion.
            raise e
        elif e.response['Error']['Code'] == 'ResourceNotFoundException':
            # We can't find the resource that you asked for.
            # Deal with the exception here, and/or rethrow at your discretion.
            raise e
    else:
        # Decrypts secret using the associated KMS key.
        # Depending on whether the secret is a string or binary, one of these fields will be populated.
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
            secret_dict = json.loads(secret)
            return secret_dict
            # for key, value in secret_dict.items():
            #     print('Key: %s'%(key))
            #     print(value)
        else:
            print('Unhandled Binary Use Case for SecretBinary')
            return {}
            
    # Your code goes here. 

if __name__ == '__main__':
    home_dir = os.getenv('HOME', None)
    print(home_dir)
    if (home_dir is None):
        print('HOME environment not defined, returning with -1')
        exit(-1)

    # home_dir = '.'
    secret_name = os.getenv('SECRETMANAGER_KEY_NAME', "MPI_SSH_KEY")
    print("Key Name: %s"%(secret_name))
    # secret_name = "MPI_SSH_KEY"
    # secret_dict = get_secret_dict_cli(secret_name=secret_name)
    secret_dict = get_secret_dict_env(secret_name=secret_name)

    ssh_dir = '%s/.ssh'%(home_dir)
    # Exporting private key
    private_key_str_enc = secret_dict['%s_PRIVATE'%(secret_name)]
    private_key_str = base64.b64decode(private_key_str_enc).decode('utf-8')

    public_key_str_enc = secret_dict['%s_PUBLIC'%(secret_name)]
    public_key_str = base64.b64decode(public_key_str_enc).decode('utf-8')

    os.makedirs(ssh_dir, exist_ok=True)
    pub_key_file = '%s/ssh_host_rsa_key.pub'%(ssh_dir)
    authorized_keys_file = '%s/authorized_keys'%(ssh_dir)

    pvt_key_file = '%s/ssh_host_rsa_key'%(ssh_dir)
    id_rsa_file = '%s/id_rsa'%(ssh_dir)

    with open(pub_key_file, 'w') as fp:
        fp.write(public_key_str)

    with open(authorized_keys_file, 'w') as fp:
        fp.write(public_key_str)

    with open(pvt_key_file, 'w') as fp:
        fp.write(private_key_str)

    with open(id_rsa_file, 'w') as fp:
        fp.write(private_key_str)


    # Create the config
    with open('%s/config'%(ssh_dir), 'w') as fp:
        fp.write("       IdentityFile %s/id_rsa\n"%(ssh_dir))
        fp.write("       StrictHostKeyChecking no\n")
        fp.write("       UserKnownHostsFile /dev/null\n")
        fp.write("       Port 2022\n")

    # Create the sshd_config
    with open('%s/sshd_config'%(ssh_dir), 'w') as fp:
        fp.write("Port 2022\n")
        fp.write("HostKey %s/ssh_host_rsa_key\n"%(ssh_dir))
        fp.write("PidFile %s/sshd.pid\n"%(ssh_dir))

    # Create the config