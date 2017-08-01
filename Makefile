DOCKERREPO := "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(shell lsb_release -cs) stable"

docker:
	sudo apt-get update
	sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository -r $(DOCKERREPO)
	sudo add-apt-repository $(DOCKERREPO)
	sudo apt-get update
	sudo apt-get install -y docker-ce
	sudo usermod -aG docker $(USER)
	@echo "=============================================================="
	@echo "You need to login out once to access docker as an regular user"
	@echo "=============================================================="

setup:
	$(MAKE) docker
