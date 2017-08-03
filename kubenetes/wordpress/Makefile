storage:
	kubectl delete -f storage.yaml || true
	sudo rm -rf /tmp/wordpress
	kubectl create -f storage.yaml

mysql:
	kubectl delete secret mysql-pass || true
	# Make sure there is no new line in the password.txt, otherwise wordpress will crash
	tr --delete '\n' <password.txt >.strippedpassword.txt && mv .strippedpassword.txt password.txt
	kubectl create secret generic mysql-pass --from-file=password.txt
	kubectl delete -f mysql.yaml || true
	kubectl create -f mysql.yaml

wordpress:
	kubectl delete -f wordpress.yaml || true
	kubectl create -f wordpress.yaml

all:
	$(MAKE) storage
	$(MAKE) mysql
	$(MAKE) wordpress

clean:
	kubectl delete -f wordpress.yaml || true
	kubectl delete -f mysql.yaml || true
	kubectl delete secret mysql-pass || true
	kubectl delete -f storage.yaml || true

.PHONY: all clean storage mysql wordpress
