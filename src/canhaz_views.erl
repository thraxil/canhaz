-module(canhaz_views).
-export([urls/0,fetch/2]).

urls() -> [
	   {"^fetch/?$", fetch}
].
%% " 

remove_duplicates(L) ->
    sets:to_list(sets:from_list(L)).

page_fetch(URL) ->
    case httpc:request(URL) of
        {ok,{_,_Headers,Body}} ->
	    {ok,Body};
        {error,Reason} -> 
            {error,Reason}
    end.

results_to_proplist({Tag,Attrs,Children}) ->
    {Tag,[{attrs,Attrs},{children,[results_to_proplist(R) || R <- Children]}]};
results_to_proplist(Text) ->
    {text,Text}.

fetch('GET',Req) ->
    Url = canhaz_shortcuts:get_request_element('GET',Req,"url",""),
    XPath = canhaz_shortcuts:get_request_element('GET',Req,"xpath","//img/@src"),
    case page_fetch(Url) of 
	{ok,Body} ->
	    Tree = mochiweb_html:parse(Body),
	    Results = remove_duplicates(mochiweb_xpath:execute(XPath,Tree)),
	    Req:ok({"application/json", 
		    mochijson2:encode([{"results",
					[results_to_proplist(R) || R <- Results]
				       }])});
	{error,Reason} ->
	    Req:ok({"application/json",
		    mochijson2:encode([{"error",Reason}])})
    end.

