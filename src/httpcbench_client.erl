%% -*- mode: erlang;erlang-indent-level: 4;indent-tabs-mode: nil -*-
%% ex: ts=4 sw=4 ft=erlang et
-module(httpcbench_client).

-export([hackney/0,
         httpc/0,
         ibrowse/0,
         lhttpc/0]).

-define(CALLS, 1000).

mb(Memory) ->
    Memory / 1024 / 1024.

test(Fun) ->
    Memory = erlang:memory(total),
    io:format("Starting ~p calls (~.3f MB)~n", [?CALLS, mb(Memory)]),
    test_loop(Fun, Memory, 0, 0, 0, 0).

test_loop(Fun, Memory, Count, RunTime, ClockTime, Failures) ->
    statistics(runtime),
    statistics(wall_clock),
    ok = start_calls(Fun, ?CALLS),

    {_Successes, Failures2} = collect_calls(?CALLS, {0, 0}),
    {_, RunTime2} = statistics(runtime),
    {_, ClockTime2} = statistics(wall_clock),
    Memory2 = erlang:memory(total),

    %% io:format("~p rutime, ~p wall_clock, ~.3f MB (~.3f increase), ~p failures~n", 
    %%           [RunTime, ClockTime, mb(Memory2), mb(Memory2 - Memory), Failures]),
    io:format("~p: ~p rt, ~p ct, ~.3f MB (~.3f increase), ~p failures~n", 
              [Count + ?CALLS,
               RunTime2 + RunTime, 
               ClockTime2 + ClockTime, 
               mb(Memory2), 
               mb(Memory2 - Memory), 
               Failures2 + Failures]),
    test_loop(Fun, Memory, 
              Count + ?CALLS, RunTime2 + RunTime, ClockTime2 + ClockTime, Failures2 + Failures).

start_calls(_, 0) ->
    ok;
start_calls(Fun, N) ->
    Self = self(),
    spawn(
      fun() ->
              Result =
                  try 
                      ok = Fun()
                  catch
                      T:X ->
                          io:format("~p:~p~n", [T, X]),
                          error
                  end,
              Self ! {done, Result}
      end),
    %% timer:sleep(1),
    start_calls(Fun, N - 1).

collect_calls(0, Acc) ->
    Acc;
collect_calls(N, {S, F}) ->
    receive
        {done, ok} ->
            collect_calls(N - 1, {S + 1, F});
        {done, error} ->
            collect_calls(N - 1, {S, F + 1})
    end.

hackney() ->
    {ok, _} = application:ensure_all_started(hackney),
    ok = test(fun hackney_get/0),
    io:format("Done~n"),
    ok.

hackney_get() ->
    {ok, 200, _Headers, Ref} = hackney:get(<<"https://localhost:8443/delay">>, [], <<>>, 
                                           [{pool, default},
                                            {ssl_options, [{verify, verify_peer},
                                                           {cacertfile, "./priv/ssl/rootCA.pem"}
                                                          ]}]),
    {ok, _} = hackney:body(Ref),
    ok.

httpc() ->
    {ok, _} = application:ensure_all_started(inets),
    {ok, _} = application:ensure_all_started(ssl),
    httpc:set_options([{max_sessions, 100}]),
    ok = test(fun httpc_get/0),
    io:format("Done~n"),
    ok.

httpc_get() ->
    {ok, {{_, 200, _}, _, _}} =
        httpc:request(get, {"https://localhost:8443/delay", []}, 
                      [{ssl, [{verify, verify_peer},
                              {cacertfile, "./priv/ssl/rootCA.pem"}
                             ]}], 
                      []),
    ok.

lhttpc() ->
    {ok, _} = application:ensure_all_started(lhttpc),
    ok = test(fun lhttpc_get/0),
    io:format("Done~n"),
    ok.

lhttpc_get() ->
    {ok, {{200, _}, _, _}} =
        lhttpc:request("https://localhost:8443/delay", get, [], [], infinity, 
                       [{connect_options, [{verify, verify_peer},
                                           {cacertfile, "./priv/ssl/rootCA.pem"}
                                          ]}]),
    ok.

ibrowse() ->
    {ok, _} = application:ensure_all_started(ssl),
    {ok, _} = ibrowse:start(),
    ok = test(fun ibrowse_get/0),
    io:format("Done~n"),
    ok.

ibrowse_get() ->
    case ibrowse:send_req("https://localhost:8443/delay", [], get, [],
                          [{ssl_options, [{verify, verify_peer},
                                          {cacertfile, "./priv/ssl/rootCA.pem"}
                                         ]}],
                          infinity) of
        {ok, "200", _, _} ->
            ok;
        {error, retry_later} ->
            timer:sleep(1),
            ibrowse_get()
    end.
