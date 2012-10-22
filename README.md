# Spitfire

Extremely low overhead file and directory transfer, mainly by not bothering with encryption.

    spitfire host1:/var/www/xyz host2:/var/www/abc

Internally spitfire works by opening a socket on both hosts through `nc` and using `tar` to transfer contents. Optionally with `pigz` for file compression.

You'll have no problem saturating dual gigabit uplinks with in-datacenter transfers.