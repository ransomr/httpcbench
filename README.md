httpcbench
==========

Erlang HTTP client benchmarks

The current test attempts to create 1000 concurrent https connections to a local server, which
responds after 10 ms.

## Results ##

Results show results at 100 iterations (100,000 connections).
rt = runtime
ct = wall_clock

### hackney (default pool) ###

100000: 127340 rt, 317962 ct, 74.704 MB (16.905 increase), 0 failures

### httpc ###

100000: 41170 rt, 95313 ct, 171.960 MB (114.466 increase), 336 failures

(Memory usage fluctuates greatly when using httpc)

### lhttpc ###

100000: 20680 rt, 29901 ct, 68.123 MB (10.954 increase), 0 failures
