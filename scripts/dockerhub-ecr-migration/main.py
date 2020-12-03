#!/usr/bin/python

import requests
import json
import subprocess

repositories = [
    'terraform',
    'aws',
    'one-cli',
    'serverless',
    'docker-kube-tools',
    'docker-aws-azure-ad',
    'ecs-deploy',
    'aws-okta-auth',
    'shell',
    'ssm-loader',
    'openvpn',
    'ssosync',
    'serverless-python',
    'php',
    'glue-libs',
    'aws-google-auth',
    'es-auto-upgrade',
    'terraform-docs',
    'maven',
    'sbt-dind',
    'aws-sam',
    'nginx-hello',
    'musketeers',
    'one',
    'hello',
    'dnxlabs'
]


full_size = 0
total_tags = 0


for repository in repositories:
    url = 'https://hub.docker.com/v2/repositories/dnxsolutions/%s/tags?page_size=1000' % repository
    r = requests.get(url)

    data = r.json()
    total_tags += data['count']

    for result in data['results']:
        tag = result['name']
        full_size  += round(result['full_size'] / 1000000, 2)
        pull_command = 'docker pull dnxsolutions/%s:%s' % (repository, tag)
        tag_command = 'docker tag dnxsolutions/%s:%s public.ecr.aws/v9i6s3d6/%s:%s'% (repository, tag, repository, tag)
        push_ecr_command = 'docker push public.ecr.aws/v9i6s3d6/%s:%s' % (repository, tag)
        rmi_command = 'docker rmi public.ecr.aws/v9i6s3d6/%s:%s' % (repository, tag)
        rmi_command_2 = 'docker rmi dnxsolutions/%s:%s' % (repository, tag)

        print(pull_command)
        subprocess.call(pull_command, shell=True)

        print(tag_command)
        subprocess.call(tag_command, shell=True)

        print(rmi_command)
        subprocess.call(push_ecr_command, shell=True)

        print(push_ecr_command)
        subprocess.call(rmi_command, shell=True)
        subprocess.call(rmi_command_2, shell=True)

    # print(full_size)
    # print(total_tags)
