%% -*- mode: erlang;erlang-indent-level: 4;indent-tabs-mode: nil -*-
%% ex: ts=4 sw=4 ft=erlang et
-module(httpcbench_server).

-export([start/0]).

start() ->
    {ok, _} = application:ensure_all_started(cowboy),
    PathList = 
        [{<<"/delay">>, httpcbench_delay, []}
        ],
    Routes = [{'_', PathList}],
    PrivDir = "./priv",
    Dispatch = cowboy_router:compile(Routes),
    {ok, _} = cowboy:start_https(talko_redirect, 100,
                                 [{port, 8443},
                                  {cacertfile, PrivDir ++ "/ssl/server.crt"},
                                  {certfile, PrivDir ++ "/ssl/server.crt"},
                                  {keyfile, PrivDir ++ "/ssl/server.key"}],
                                 [{env, [{dispatch, Dispatch}]}]),
    ok.
