#/bin/bash

# Get All the regions
export REGIONS=$(aws ec2 describe-regions | jq -r ".Regions[].RegionName")

# Get VPC from the region
for region in $REGIONS; do
    # list vpcs
    echo $region
    aws --region=$region ec2 describe-vpcs | jq ".Vpcs[]|{is_default: .IsDefault, cidr: .CidrBlock, id: .VpcId} | select(.is_default)"
done

# Ask if you are sure to delete the resources
read -p "Are you sure? " -n 1 -r
echo
if [[ $ANSWER =~ ^[Yy]$ ]]
then
    for region in $REGIONS ; do
        echo "Destroying region: $region"
        # list vpcs
        export IDs=$(aws --region=$region ec2 describe-vpcs | jq -r ".Vpcs[]|{is_default: .IsDefault, id: .VpcId} | select(.is_default) | .id")
        for id in "$IDs" ; do
            if [ -z "$id" ] ; then
                continue
            fi

            # kill igws
            for igw in `aws --region=$region ec2 describe-internet-gateways | jq -r ".InternetGateways[] | {id: .InternetGatewayId, vpc: .Attachments[0].VpcId} | select(.vpc == \"$id\") | .id"` ; do
                echo "Destroying IGW $region $id $igw"
                aws --region=$region ec2 detach-internet-gateway --internet-gateway-id=$igw --vpc-id=$id
                aws --region=$region ec2 delete-internet-gateway --internet-gateway-id=$igw
            done

            # kill subnets
            for sub in `aws --region=$region ec2 describe-subnets | jq -r ".Subnets[] | {id: .SubnetId, vpc: .VpcId} | select(.vpc == \"$id\") | .id"` ; do
                echo "Destroying Subnet $region $id $sub"
                aws --region=$region ec2 delete-subnet --subnet-id=$sub
            done

            echo "Destroying VPC $region $id"
            aws --region=$region ec2 delete-vpc --vpc-id=$id
        done
    done
fi