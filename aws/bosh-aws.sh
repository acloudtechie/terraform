#!/bin/bash
set -e

if (( $# < 1 || $# > 2))
then
  echo "Usage: bosh-aws [start|stop] [workspace-dir]"
  exit 1
else
    ws=${2:-"/tmp/bosh"}
    if [[ ! -d "$ws" ]]
	then
    	#echo "$2 needs to be a valid directory for bosh workspace"
    	#echo "Usage: bosh-aws [start|stop] [workspace-dir]"
    	#exit 1
		mkdir $ws
    fi    
    export BOSH_WORKSPACE_ROOT_DIR=$ws
    
    
    if [[ ! -d "$BOSH_WORKSPACE_ROOT_DIR/bosh-deployment" ]]
	then
    	pushd $BOSH_WORKSPACE_ROOT_DIR
    	git clone https://github.com/cloudfoundry/bosh-deployment
    	popd
    	
    fi
    
	export BOSH_DEPLOYMENT_RS_DIR=$BOSH_WORKSPACE_ROOT_DIR/bosh-deployment
	export BOSH_DEPLOYMENT_DIR=$BOSH_WORKSPACE_ROOT_DIR/deployments/aws
	source ~/aws/awscred.sh
	
	case "$1" in
  		"start")
			bosh create-env $BOSH_DEPLOYMENT_RS_DIR/bosh.yml \
    			-o $BOSH_DEPLOYMENT_RS_DIR/aws/cpi.yml \
    			-o $BOSH_DEPLOYMENT_RS_DIR/external-ip-with-registry-not-recommended.yml \
    			--state $BOSH_DEPLOYMENT_DIR/state.json \
    			--vars-store $BOSH_DEPLOYMENT_DIR/creds.yml \
    			--var-file private_key=$AWS_PRIVATE_KEY_PATH \
    			--vars-file  $BOSH_WORKSPACE_ROOT_DIR/aws-vars.yml \
    			-v access_key_id=${AWS_ACCESS_KEY_ID} \
    			-v secret_access_key=${AWS_SECRET_ACCESS_KEY}

			bosh alias-env aws -e `bosh int $BOSH_WORKSPACE_ROOT_DIR/aws-vars.yml --path /external_ip` --ca-cert <(bosh int $BOSH_DEPLOYMENT_DIR/creds.yml --path /director_ssl/ca)

			export BOSH_CLIENT=admin
			export BOSH_CLIENT_SECRET=`bosh int $BOSH_DEPLOYMENT_DIR/creds.yml --path /admin_password`
			bosh -e aws env    	
			#sudo route add -net 10.244.0.0/16     192.168.50.6 
    	;;
 		 "stop")
		    #bosh -e azure clean-up --all
			bosh delete-env $BOSH_DEPLOYMENT_RS_DIR/bosh.yml \
    			-o $BOSH_DEPLOYMENT_RS_DIR/aws/cpi.yml \
    			-o $BOSH_DEPLOYMENT_RS_DIR/external-ip-with-registry-not-recommended.yml \
    			--state $BOSH_DEPLOYMENT_DIR/state.json \
    			--vars-store $BOSH_DEPLOYMENT_DIR/creds.yml \
    			--var-file private_key=$AWS_PRIVATE_KEY_PATH \
    			--vars-file  $BOSH_WORKSPACE_ROOT_DIR/aws-vars.yml \
    			-v access_key_id=${AWS_ACCESS_KEY_ID} \
    			-v secret_access_key=${AWS_SECRET_ACCESS_KEY}
    	;;

  	*)
    	echo "Usage: bosh-aws [start|stop] [workspace-dir]"
    	exit 1
    	;;
	esac
	
fi