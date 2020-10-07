eks: tf
	terraform apply

tf:
	terraform init

consul-config:
	@printf "${CONSUL_HTTP_TOKEN}" > secrets/token
	@cat secrets/client_config.json | jq -j -r .encrypt > secrets/gossipEncryption
	@$(eval CONSUL_HOST := $(shell cat secrets/client_config.json | jq -r -j '.retry_join[0]'))
	@echo 'hcp_consul_host = "$(CONSUL_HOST)"' > ./terraform.tfvars

k8s-secrets:
	terraform output consul_helm_values > values.yml
	aws eks --region ${AWS_REGION} update-kubeconfig --name k8s-to-hcp-consul
	kubectl create secret generic hcp-consul --from-file='caCert=./secrets/ca.pem' --from-file='gossipEncryptionKey=./secrets/gossipEncryption'
	kubectl create secret generic hcp-consul-bootstrap-token --from-file='token=./secrets/token'
	kubectl create secret generic consul-client-acl-token --from-file='token=./secrets/token'

consul: k8s-secrets
	helm install consul hashicorp/consul -f values.yml

clean:
	helm del consul || true
	rm -f values.yml
	kubectl delete jobs consul-server-acl-init consul-server-acl-init-cleanup || true
	kubectl delete secret hcp-consul hcp-consul-bootstrap-token consul-client-acl-token
