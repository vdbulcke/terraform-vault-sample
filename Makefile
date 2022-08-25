
full-demo: cleanup init apply create-users 


fmt:
	terraform fmt

validate:
	terraform validate

start_dev: 
	vault server -dev -dev-root-token-id=root-token

init:
	vault secrets disable secret/
	terraform init

cleanup:
	./cleanup.sh


create-users: 
	./tutorial/create_users.sh


apply:
	terraform apply -auto-approve