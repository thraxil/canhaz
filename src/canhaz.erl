%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc canhaz.

-module(canhaz).
-author("Mochi Media <dev@mochimedia.com>").
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.


%% @spec start() -> ok
%% @doc Start the canhaz server.
start() ->
    canhaz_deps:ensure(),
    ensure_started(crypto),
    application:start(canhaz).


%% @spec stop() -> ok
%% @doc Stop the canhaz server.
stop() ->
    application:stop(canhaz).
