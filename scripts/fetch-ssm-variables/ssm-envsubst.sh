#!/bin/bash
source .env.ssm
envsubst < example.tpl.json > example.json