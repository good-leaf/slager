
-module(slager).

-include("../include/slager.hrl").
%% API
-export([
    log/3,
    format/2,
    skip_log/1,
    skip_log/2,
    much_trace/1,
    hash_log/4
]).

-export([
    log_format_test/0,
    log_format_loop/1,
    log_press_format_test/2,
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

much_trace(FileName) ->
    FileSize  = application:get_env(slager, file_size, 100),
    FileNum  = application:get_env(slager, file_num, 30),
    lager_trace(much0_lager_event, much0, FileName, FileSize, FileNum),
    lager_trace(much1_lager_event, much1, FileName, FileSize, FileNum),
    lager_trace(much2_lager_event, much2, FileName, FileSize, FileNum),
    lager_trace(much3_lager_event, much3, FileName, FileSize, FileNum),
    lager_trace(much4_lager_event, much4, FileName, FileSize, FileNum).

lager_trace(Sink, Type, FileName, FileSize, Count) ->
    {ok, Service} = inet:gethostname(),
    AppKey  = application:get_env(slager, app_key, "app_key"),
    LogEnv = application:get_env(slager, log_env, "log_env"),
    lager:trace_file(atom_to_list(Type) ++ "/" ++ atom_to_list(FileName) ++ ".log",
        [{Type, FileName}, {sink, Sink}], info,
        [
            {size, FileSize * 1024 * 1024},
            {count, Count},
            {formatter_config, [date, " ", time, " ",
                Service, " ", AppKey, " [info] ",
                atom_to_list(FileName), " ", LogEnv, " ", message, "\n"]
            }
        ]).

hash_log(HashKey, FileName, Format, Val) ->
    log_msg(erlang:phash2(HashKey, 5), FileName, Format, Val).

log_msg(0, Name, Format, Val) -> much0:info([{much0, Name}], Format, [Val]);
log_msg(1, Name, Format, Val) -> much1:info([{much1, Name}], Format, [Val]);
log_msg(2, Name, Format, Val) -> much2:info([{much2, Name}], Format, [Val]);
log_msg(3, Name, Format, Val) -> much3:info([{much3, Name}], Format, [Val]);
log_msg(4, Name, Format, Val) -> much4:info([{much4, Name}], Format, [Val]).


%%--------------------------------------------------------------------------------------------
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


log_format_test() ->
    %设置动态变量
    lager:md([{key, <<"default">>}]),
    erlang:put(key, <<"key">>),
    Data = <<"There`s not a day goes by I don`t feel regret. Not because I`m in here,
    or because you think I should. I look back on the way I was then. Then a young,
    stupid kid who committed that terrible crime. I want to talk to him. I want to try and
    talk some sense to him, tell him the way things are. But I can`t. That kid`s long gone
    and this old man is all that`s left. I got to live with that. Rehabilitated?
    It`s just a bull... word. So you go on and stamp your form, sorry, and stop wasting my time.
    Because to tell you the truth, I don`t give a shit.">>,
    %需要字符传形式
    Kv = log:kv_generate([
        {<<"trace_id">>, 100000000},
        {<<"tenant_id">>, <<"tenant_id">>},
        {<<"app_call_uuid">>, app_call_uuid},
        {<<"app_uuid">>, "app_uuid"},
        {<<"service_uuid">>, <<>>},
        {<<"uuid">>, <<"uuid">>}
    ]),
    ?DEBUG("~p Two parameters of the log output, the application name is slager,data:~p", [Kv, Data]),
    ?INFO("~p Two parameters of the log output, the application name is slager,data:~p", [Kv, Data]),
    ?WARNING("~p Two parameters of the log output, the application name is slager,data:~p", [Kv, Data]),
    ?ERROR("~p Two parameters of the log output, the application name is slager,data:~p", [Kv, Data]).

log_format_loop(0) ->
    ok;
log_format_loop(Num) ->
    log_format_test(),
    log_format_loop(Num -1).

log_press_format_test(ProcessNum, LoopNum) ->
    lists:foreach(fun(_N) ->
        spawn(slager, log_format_loop, [LoopNum])
                  end,
        lists:seq(1, ProcessNum)).