%%%-------------------------------------------------------------------
%%% @author yangyajun03
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 四月 2018 下午5:48
%%%-------------------------------------------------------------------
-module(slager).
-author("yangyajun03").

-include("slager.hrl").
%% API
-export([
    log/3,
    format/2,
    skip_log/1,
    skip_log/2,

    log_test/0,
    log_press_test/2,
    log_loop/1
]).
log(Log, Level, Format) ->
    Log:format(Level, Format).

format(debug, Format) ->
    Format;
format(info, Format) ->
    Format;
format(warning, Format) ->
    Format;
format(error, Format) ->
    Format.

skip_log(_Format, _Message) ->
    ok.

skip_log(_Format) ->
    ok.

log_test() ->
    Data = <<"There`s not a day goes by I don`t feel regret. Not because I`m in here,
    or because you think I should. I look back on the way I was then. Then a young,
    stupid kid who committed that terrible crime. I want to talk to him. I want to try and
    talk some sense to him, tell him the way things are. But I can`t. That kid`s long gone
    and this old man is all that`s left. I got to live with that. Rehabilitated?
    It`s just a bull... word. So you go on and stamp your form, sorry, and stop wasting my time.
    Because to tell you the truth, I don`t give a shit.">>,

    %设置动态变量
    lager:md([{key, <<"default">>}]),
    erlang:put(key, <<"key">>),
    ?DEBUG("Two parameters of the log output, the application name is slager,data:~p", [Data]),
    ?INFO("Two parameters of the log output, the application name is slager,data:~p", [Data]),
    ?WARNING("Two parameters of the log output, the application name is slager,data:~p", [Data]),
    ?ERROR("Two parameters of the log output, the application name is slager,data:~p", [Data]),

    ?DEBUG("One parameters of the log output, the application name is slager."),
    ?INFO("One parameters of the log output, the application name is slager."),
    ?WARNING("One parameters of the log output, the application name is slager."),
    ?ERROR("One parameters of the log output, the application name is slager.").

log_loop(0) ->
    ok;
log_loop(Num) ->
    log_test(),
    log_loop(Num -1).

log_press_test(ProcessNum, LoopNum) ->
    lists:foreach(fun(_N) ->
            spawn(slager, log_loop, [LoopNum])
        end,
        lists:seq(1, ProcessNum)).
