-module(canhaz_views).
-export([hello/3,urls/0,fetch/2]).

urls() -> [
	   {"^hello/?$", hello},
           {"^hello/(.+?)/?$", hello},
	   {"^fetch/?$", fetch}
].
%% " 

hello('GET', Req, Username) ->
    canhaz_shortcuts:render_ok(Req, canhaz_dtl, [{username, Username}]);
hello(Method,Req,_) ->
    Username = canhaz_shortcuts:get_request_element(Method,Req,"username","Anonymous"),
    canhaz_shortcuts:render_ok(Req, canhaz_dtl, [{username, Username}]).

page_info(URL) ->
    case httpc:request(URL) of
        {ok,{_,_Headers,Body}} ->
%%            got_page_info(URL,content_length(Headers),Body);
	    {ok,Body};
        {error,Reason} -> 
            {error,Reason}
    end.


fetch('GET',Req) ->
    Url = canhaz_shortcuts:get_request_element('GET',Req,"url",""),
    {ok,Body} = page_info(Url),
    Req:ok({"text/plain", Body}).
