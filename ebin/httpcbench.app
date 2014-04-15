{application,httpcbench,
             [{registered,[]},
              {description,"Erlang HTTP client benchmarks"},
              {vsn,"0.1.0"},
              {applications,[kernel,stdlib,httpc,cowboy,hackney]},
              {mod,{httpcbenc_app,[]}},
              {env,[]},
              {modules,[httpcbench_delay,httpcbench_server]}]}.
