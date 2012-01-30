-module(canhaz_views).
-export([urls/0,fetch/2]).

urls() -> [
	   {"^fetch/?$", fetch}
].
%% " 

remove_duplicates(L) ->
    sets:to_list(sets:from_list(L)).
% extract content-length from the http headers
content_length(Headers) ->
    list_to_integer(proplists:get_value("content-length",Headers,"0")).

%% abs url inside the same server ej: /img/image.png    
full_url({Root,_Context},ComponentUrl=[$/|_]) ->
    Root ++ ComponentUrl;

%% full url ej: http://other.com/img.png
full_url({_Root,_Context},ComponentUrl="http://"++_) ->
    ComponentUrl;

% everything else is considerer a relative path.. obviously its wrong (../img) 
full_url({Root,Context},ComponentUrl) ->
    Root ++ Context ++ "/" ++ ComponentUrl.

% returns the  domain, and current context path. 
% url_context("http://www.some.domain.com/content/index.html)
%      -> {"http://www.some.domain.com", "/content"}
url_context(URL) ->
    {http,_,Root,_Port,Path,_Query} = http_uri:parse(URL), 
    Ctx = string:sub_string(Path,1, string:rstr(Path,"/")),
    {"http://"++Root,Ctx}.

page_fetch(URL) ->
    case httpc:request(URL) of
        {ok,{_,_Headers,Body}} ->
%%            got_page_info(URL,content_length(Headers),Body);
	    {ok,Body};
        {error,Reason} -> 
            {error,Reason}
    end.


fetch('GET',Req) ->
    Url = canhaz_shortcuts:get_request_element('GET',Req,"url",""),
    {ok,Body} = page_fetch(Url),
    Tree = mochiweb_html:parse(Body),
    Imgs = remove_duplicates(mochiweb_xpath:execute("//img/@src",Tree)),
%    [Head|_Body] = element(3,Tree),
%    [TitleElement|_OtherHead] = element(3,Head),
%    [Title] = element(3,TitleElement),
%    [First|Rest] = Imgs,
    Req:ok({"application/json", mochijson2:encode([{"images",Imgs}])}).
