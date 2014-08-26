httpcbench
==========

Erlang HTTP client benchmarks

The current test attempts to create 1000 concurrent https connections to a local server, which
responds after 10 ms.

## Results ##

Results show results at 100 iterations (100,000 connections).

| Client | runtime | wall_clock | mem | failures |
| ------ | --:| --:| ---:| --------:|
| hackney (default pool) | 182640 | 152840 | 22.292 | 0 |
| httpc | 25270 | 29243 | 52.063 | 0 |
| httpc (optimized) | 26300 | 28873 | 42.440 | 0 |
| ibrowse | 112650 | 115722 | 14.551 | 0 |
| ibrowse (optimized) | 20680 | 26067 | 53.450 | 0 |
| lhttpc | 19550 | 29043 | 14.814 | 0 |

Results are from Erlang 17.0. Running on Ubuntu 12.04 VM with 6 cores running on a 2013 MacBook Pro.

httpc performs MUCH worse if {max_keepalive, infinity} is not set on the server.

## Running the tests ##

Make sure you have a high nofile limit, and enough sockets (on Ubuntu, 
`sudo sysctl -w net.ipv4.ip_local_port_range="2048 65535"`).

#### Terminal 1:

`./run_server`

#### Terminal 2:

`./run_client CLIENT`

CLIENT is one of hackney, httpc, httpc_opt, ibrowse, ibrowse_opt, lhttpc
