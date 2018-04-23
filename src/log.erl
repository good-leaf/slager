%%%-------------------------------------------------------------------
%%% @author yangyajun03
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 四月 2018 下午2:18
%%%-------------------------------------------------------------------
-module(log).
-author("yangyajun03").

%% API
-export([
    format/2,
    kv_generate/1
]).

to_binary(X) when is_integer(X) -> integer_to_binary(X);
to_binary(X) when is_float(X) -> float_to_binary(X);
to_binary(X) when is_atom(X) -> atom_to_binary(X, utf8);
to_binary(X) when is_binary(X) -> case X of <<>> -> <<" ">>;X -> X end;
to_binary(X) when is_list(X) ->
    case io_lib:printable_list(X) of
        true ->
            list_to_binary(X);
        false ->
            term_to_binary(X)
    end.

format(Level, Format) ->
    {ok, Host} = inet:gethostname(),
    LogEnv = "test",
    AppKey = "slager",
    Pid = pid_to_list(self()),
    Host ++ " " ++ AppKey ++ " " ++ "[" ++ atom_to_list(Level) ++ "]" ++ " " ++ Pid ++ " "
        ++ LogEnv ++ " " ++ Format.

kv_generate(DataList) ->
    Kv = lists:foldl(fun(T, <<>>) ->
            {K, V} = T,
            BK = to_binary(K),
            BV = to_binary(V),
            <<BK/binary, "=", BV/binary>>;
        (T, Acc) ->
            {K, V} = T,
            BK = to_binary(K),
            BV = to_binary(V),
            <<Acc/binary, " ", BK/binary, "=", BV/binary>> end, <<>>, DataList),
    binary_to_atom(<<"#XMDT#{", Kv/binary, "}#XMDT#">>, utf8).
