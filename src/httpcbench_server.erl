-module(httpcbench_server).

-export([start/0]).

start() ->
    {ok, _} = application:ensure_all_started(cowboy),
    PathList = 
        [{<<"/delay">>, httpcbench_delay, []}
        ],
    Routes = [{'_', PathList}],
    Dispatch = cowboy_router:compile(Routes),
    {ok, _} = cowboy:start_http(talko_redirect, 100,
                                [{port, 8443}],
                                [{env, [{dispatch, Dispatch}]}]),
    ok.
