-module(httpcbench_delay).

-behaviour(cowboy_http_handler).
-export([init/3,
         handle/2,
         terminate/3
        ]).

init(_, Req, []) ->
    {ok, Req, state}.

handle(Req, state) ->
    ok = timer:sleep(10),
    {ok, Req2} = cowboy_req:reply(200, Req),
    {ok, Req2, state}.

terminate(_Reason, _Req, state) ->
    ok.
