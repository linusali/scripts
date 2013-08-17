#!/bin/sh
 
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
echo "This script must be run as root" 1>&2
exit 1
fi
 
# Load configuration
. /etc/route53/config
 
# Export access key ID and secret for cli53
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
 
# Use command line scripts to get instance ID and public hostname
LOCAL_IPV4=$(ec2metadata | grep ':' | cut -d ' ' -f 2)
 
# Create a new CNAME record on Route 53, replacing the old entry if nessesary
cli53 rrcreate "$ZONE" "$(hostname)" A "$LOCAL_IPV4" --replace --ttl "$TTL"
