-module(gen_web_server).

-export([ start_link/3 % starts the server informing the Callback Module, the Port, and the init Args
        , start_link/4 % starts the server informing both IP and port
        , http_reply/1, http_reply/2, http_reply/3   % auxiliar functions for replying to HTTP requests
        ]). 

-export([behaviour_info/1]).


behaviour_info(callbacks) ->
    [ {init, 1}
    , {get, 3}
    , {post, 4}
    , {put, 4}
    , {delete, 3}
    ];
behaviour_info(_Other) ->
    undefined. 


start_link(Callback, Port, UserArgs) ->
    start_link(Callback, undefined, Port, UserArgs).

start_link(Callback, IP, Port, UserArgs) ->
    gws_connections_sup:start_link(Callback, IP, Port, UserArgs).

http_reply(Code, Headers, Body) ->
    ContentBytes = iolist_to_binary(Body),
    Length = byte_size(ContentBytes),
    [io_lib:format("HTTP/1.1 ~s\r\n~sContent-Length: ~w\r\n\r\n", [response(Code), headers(Headers), Length]), ContentBytes].

http_reply(Code) ->
    http_reply(Code, <<>>).

http_reply(Code, Body) ->
    http_reply(Code, [{"Content-Type", "text/html"}], Body).

headers([{K, V} | Headers]) ->
    [io_lib:format("~s: ~s\r\n", [K, V]) | headers(Headers)]; 
headers([]) ->
    [].


response(100) -> "100 Continue";
response(200) -> "200 OK"; 
response(404) -> "404 Not Found"; 
response(501) -> "501 Not Implemented"; 
response(Code) -> integer_to_list(Code). 

