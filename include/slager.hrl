
-define(LOGFORMAT, application:get_env(slager, format, slager)).

-define(HLOG(HashKey, FileName, Format, Message), slager:hash_log(HashKey, FileName, Format, Message)).

-define(DEBUG(Format, Message),
    begin
        case application:get_env(slager, type, lager) of
            lager ->
                lager:debug(slager:log(?LOGFORMAT, debug, Format), Message);
            slager ->
                sdebug:debug(slager:log(?LOGFORMAT, debug, Format), Message);
            skip ->
                slager:skip_log(slager:log(?LOGFORMAT, debug, Format), Message)
        end
    end).
-define(INFO(Format, Message),
    begin
        case application:get_env(slager, type, lager) of
            lager ->
                lager:info(slager:log(?LOGFORMAT, info, Format), Message);
            slager ->
                sinfo:info(slager:log(?LOGFORMAT, info, Format), Message);
            skip ->
                slager:skip_log(slager:log(?LOGFORMAT, info, Format), Message)
        end
    end).
-define(WARNING(Format, Message),
    begin
        case application:get_env(slager, type, lager) of
            lager ->
                lager:warning(slager:log(?LOGFORMAT, warning, Format), Message);
            slager ->
                swarning:warning(slager:log(?LOGFORMAT, warning, Format), Message);
            skip ->
                slager:skip_log(slager:log(?LOGFORMAT, warning, Format), Message)
        end
    end).
-define(ERROR(Format, Message),
    begin
        case application:get_env(slager, type, lager) of
            lager ->
                lager:error(slager:log(?LOGFORMAT, error, Format), Message);
            slager ->
                serror:error(slager:log(?LOGFORMAT, error, Format), Message);
            skip ->
                slager:skip_log(slager:log(?LOGFORMAT, error, Format), Message)
        end
    end).
-define(DEBUG(Format),
    begin
        case application:get_env(slager, type, lager) of
            lager ->
                lager:debug(slager:log(?LOGFORMAT, debug, Format));
            slager ->
                sdebug:debug(slager:log(?LOGFORMAT, debug, Format));
            skip ->
                slager:skip_log(slager:log(?LOGFORMAT, debug, Format))
        end
    end).
-define(INFO(Format),
    begin
        case application:get_env(slager, type, lager) of
            lager ->
                lager:info(slager:log(?LOGFORMAT, info, Format));
            slager ->
                sdebug:info(slager:log(?LOGFORMAT, info, Format));
            skip ->
                slager:skip_log(slager:log(?LOGFORMAT, info, Format))
        end
    end).
-define(WARNING(Format),
    begin
        case application:get_env(slager, type, lager) of
            lager ->
                lager:warning(slager:log(?LOGFORMAT, warning, Format));
            slager ->
                swarning:warning(slager:log(?LOGFORMAT, warning, Format));
            skip ->
                slager:skip_log(slager:log(?LOGFORMAT, warning, Format))
        end
    end).
-define(ERROR(Format),
    begin
        case application:get_env(slager, type, lager) of
            lager ->
                lager:error(slager:log(?LOGFORMAT, error, Format));
            slager ->
                serror:error(slager:log(?LOGFORMAT, error, Format));
            skip ->
                slager:skip_log(slager:log(?LOGFORMAT, error, Format))
        end
    end).
