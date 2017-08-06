# Network policy Demo

## How to try the demo

  - Start the cluster
    ```sh
    make all
    ```
  - Internal client can access the nginx while the external one can not
    ```sh
    $ kubectl exec external-client-1537983838-j55z0 -- wget --spider --timeout=1 nginx
	Spider mode enabled. Check if remote file exists.
	--2017-08-06 00:35:52--  http://nginx/
	Resolving nginx (nginx)... 10.108.79.56
	Connecting to nginx (nginx)|10.108.79.56|:80... failed: Connection timed out.
	Retrying.

	Spider mode enabled. Check if remote file exists.
	--2017-08-06 00:35:54--  (try: 2)  http://nginx/
	Connecting to nginx (nginx)|10.108.79.56|:80... failed: Connection timed out.
	Retrying.

	Spider mode enabled. Check if remote file exists.
	--2017-08-06 00:35:57--  (try: 3)  http://nginx/
	Connecting to nginx (nginx)|10.108.79.56|:80... failed: Connection timed out.
	Retrying.

	Spider mode enabled. Check if remote file exists.
	--2017-08-06 00:36:01--  (try: 4)  http://nginx/
	Connecting to nginx (nginx)|10.108.79.56|:80... failed: Connection timed out.
	Retrying.

	^C
	$ kubectl exec internal-client-4102685276-sv337 -- wget --spider --timeout=1 nginx
	Spider mode enabled. Check if remote file exists.
	--2017-08-06 00:36:21--  http://nginx/
	Resolving nginx (nginx)... 10.108.79.56
	Connecting to nginx (nginx)|10.108.79.56|:80... connected.
	HTTP request sent, awaiting response... 200 OK
	Length: 612 [text/html]
	Remote file exists and could contain further links,
	but recursion is disabled -- not retrieving.
    ```
  - Tear down the cluster
    ```sh
    make clean
    ```
