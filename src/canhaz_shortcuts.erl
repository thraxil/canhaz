-module(canhaz_shortcuts).
-export([render_ok/3,get_request_element/4,get_cookie_value/3]).

render_ok(Req, TemplateModule, Params) ->
    {ok, Output} = TemplateModule:render(Params),
    % Here we use mochiweb_request:ok/1 to render a reponse
    Req:ok({"text/html", Output}).

get_request_data('GET',Req) ->
    Req:parse_qs();
get_request_data('POST',Req) ->
    Req:parse_post().

get_cookie_value(Req, Key, Default) ->
    case Req:get_cookie_value(Key) of
        undefined -> Default;
        Value -> Value
    end.

get_request_element(Method,Req,Key,Default) ->
    Data = get_request_data(Method,Req),
    proplists:get_value(Key, Data, Default).

    
