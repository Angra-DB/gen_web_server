{library, gen_web_server,
[{description, "A generic web server."},
 {vsn, "0.01"},
 {modules, [gen_web_server, gws_server, gws_conection_sup]},
 {registered, [gws_connection_sup]}
]}.
