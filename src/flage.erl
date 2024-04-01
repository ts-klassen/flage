-module(flage).

-export([
        to_bmp/1
      , from_bmp/1
    ]).

to_bmp(Binary) ->
    flage_bmp:encode(Binary).

from_bmp(Binary) ->
    flage_bmp:decode(Binary).
