-module(emq_login_limit).

-include_lib("emqttd/include/emqttd.hrl").

-export([check_limit/2]).

check_limit(Username, MaxOnline) ->
    ClientList = emqttd_mgmt:client_by_name(Username),
    if 
        MaxOnline > erlang:length(ClientList) ->
            ok;
        true ->
            {error, <<"limited">>}
    end.




