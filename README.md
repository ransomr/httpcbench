httpcbench
==========

Erlang HTTP client benchmarks

The current test attempts to create 1000 concurrent https connections to a local server, which
responds after 10 ms.

## Results ##

Results show results at 100 iterations (100,000 connections).

| Client | runtime | wall_clock | mem | failures |
| ------ | --:| --:| ---:| --------:|
| hackney (default pool) | 38560 | 30912 | 16.110 | 0 |
| httpc | 34080 | 27913 | 54.083 | 0 |
| httpc (optimized) | 33540 | 26981 | 55.402 | 0 |
| ibrowse | 212720 | 112853 | 14.567 | 0 |
| ibrowse (optimized) | 22410 | 21029 | 59.849 | 0 |
| lhttpc | 27820 | 29276 | 12.893 | 0 |

Results are from Erlang 17.2.1. Running on Ubuntu 12.04 VM with 4 cores running on a 2013 MacBook Pro.

httpc performs MUCH worse if {max_keepalive, infinity} is not set on the server.

## Running the tests ##

Make sure you have a high nofile limit, and enough sockets (on Ubuntu, 
`sudo sysctl -w net.ipv4.ip_local_port_range="2048 65535"`).

#### Terminal 1:

`./run_server`

#### Terminal 2:

`./run_client CLIENT`

CLIENT is one of hackney, httpc, httpc_opt, ibrowse, ibrowse_opt, lhttpc
