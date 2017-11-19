#!/bin/bash
set -e

if (( $# < 1 || $# > 2))
then
  echo "Usage: bosh-azure [start|stop] [workspace-dir]"
  exit 1
else
    ws=${2:-"/tmp/bosh"}
    if [[ ! -d "$ws" ]] 
	then
    	#echo "$2 is not a valid directory"
    	#echo "Usage: bosh-azure [start|stop] [workspace-dir]"
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
	export BOSH_DEPLOYMENT_DIR=$BOSH_WORKSPACE_ROOT_DIR/deployments/azure
    source ~/azure/azurecred.sh
	
	case "$1" in
  		"start")
			bosh create-env $BOSH_DEPLOYMENT_RS_DIR/bosh.yml \
    			-o $BOSH_DEPLOYMENT_RS_DIR/azure/cpi.yml \
    			-o $BOSH_DEPLOYMENT_RS_DIR/external-ip-with-registry-not-recommended.yml \
    			--state $BOSH_DEPLOYMENT_DIR/state.json \
    			--vars-store $BOSH_DEPLOYMENT_DIR/creds.yml \
    			--vars-file  $BOSH_WORKSPACE_ROOT_DIR/azure-vars.yml \
    			-v subscription_id=${ARM_SUBSCRIPTION_ID} \
    			-v tenant_id=${ARM_TENANT_ID} \
    			-v client_id=${ARM_CLIENT_ID} \
    			-v client_secret=${ARM_CLIENT_SECRET}

			bosh alias-env azure -e <(bosh int $BOSH_WORKSPACE_ROOT_DIR/azure-vars.yml --path /external_ip) --ca-cert <(bosh int $BOSH_DEPLOYMENT_DIR/creds.yml --path /director_ssl/ca)
			export BOSH_CLIENT=admin
			export BOSH_CLIENT_SECRET=`bosh int $BOSH_DEPLOYMENT_DIR/creds.yml --path /admin_password`
			bosh -e azure env
			bosh -e azure login
			#sudo route add -net 10.244.0.0/16     192.168.50.6 
    	;;
 		 "stop")
		    #bosh -e azure clean-up --all
			bosh delete-env $BOSH_DEPLOYMENT_RS_DIR/bosh.yml \
    			-o $BOSH_DEPLOYMENT_RS_DIR/azure/cpi.yml \
    			-o $BOSH_DEPLOYMENT_RS_DIR/external-ip-with-registry-not-recommended.yml \
    			--state $BOSH_DEPLOYMENT_DIR/state.json \
    			--vars-store $BOSH_DEPLOYMENT_DIR/creds.yml \
    			--vars-file  $BOSH_WORKSPACE_ROOT_DIR/azure-vars.yml \
    			-v subscription_id=${ARM_SUBSCRIPTION_ID} \
    			-v tenant_id=${ARM_TENANT_ID} \
    			-v client_id=${ARM_CLIENT_ID} \
    			-v client_secret=${ARM_CLIENT_SECRET}
    	;;

  	*)
    	echo "Usage: bosh-azure [start|stop] [workspace-dir]"
    	exit 1
    	;;
	esac
	
fi
