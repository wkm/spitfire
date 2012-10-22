# Spitfire

Extremely low overhead file and directory transfer, mainly by not bothering with encryption.

	spitfire transfer --source-host host1 \ 
		--source-dir /var/run/kafka/logs \
		--destination-host host2 \
		--destination-dir /tmp/spitfirelogs2 

Internally spitfire works by opening a socket on both hosts through `nc` and using `tar` to transfer contents.

You'll have no problem saturating dual gigabit uplinks with in-datacenter transfers.
