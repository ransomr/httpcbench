httpcbench
==========

Erlang HTTP client benchmarks

The current test attempts to create 1000 concurrent https connections to a local server, which
responds after 10 ms.

## Results ##

Results show results at 100 iterations (100,000 connections).

| Client | runtime | wall_clock | mem | failures |
| ------ | --:| --:| ---:| --------:|
| hackney (default pool) | 127340 | 317962 | 16.905 | 0 |
| httpc | 41170 | 95313 | 114.466 | 336 |
| ibrowse | 100640 | 116245 | 14.762 | 33 |
| lhttpc | 20680 | 29901 | 10.954 | 0 |
