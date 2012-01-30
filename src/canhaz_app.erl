%% @author Mochi Media <dev@mochimedia.com>
%% @copyright canhaz Mochi Media <dev@mochimedia.com>

%% @doc Callbacks for the canhaz application.

-module(canhaz_app).
-author("Mochi Media <dev@mochimedia.com>").

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for canhaz.
start(_Type, _StartArgs) ->
    canhaz_deps:ensure(),
    canhaz_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for canhaz.
stop(_State) ->
    ok.
