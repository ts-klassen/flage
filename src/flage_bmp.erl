-module(flage_bmp).
-export([
        encode/1
      , decode/1
    ]).

encode(Binary) when is_binary(Binary), size(Binary) < 16*16*3-4 ->
    encode_(16, Binary);
encode(Binary) when is_binary(Binary), size(Binary) < 32*32*3-4 ->
    encode_(32, Binary);
encode(Binary) when is_binary(Binary), size(Binary) < 64*64*3-4 ->
    encode_(64, Binary);
encode(Binary) when is_binary(Binary), size(Binary) < 128*128*3-4 ->
    encode_(128, Binary);
encode(Binary) when is_binary(Binary), size(Binary) < 256*256*3-4 ->
    encode_(256, Binary);
encode(Binary) when is_binary(Binary), size(Binary) < 512*512*3-4 ->
    encode_(512, Binary);
encode(Binary) when is_binary(Binary), size(Binary) < 1024*1024*3-4 ->
    encode_(1024, Binary);
encode(Binary) when is_binary(Binary), size(Binary) < 2048*2048*3-4 ->
    encode_(2048, Binary);
encode(Arg1) ->
    erlang:error(badarg, [Arg1]).

encode_(N, B) ->
    S = size_to_bin(size(B)),
    H = header(N),
    R = crypto:strong_rand_bytes(N*N*3-4-size(B)),
    <<H/binary, S/binary, B/binary, R/binary>>.

decode(<<_:138/binary, S:4/binary, T/binary>>) ->
    Size = bin_to_size(S),
    <<Payload:Size/binary, _/binary>> = T,
    Payload.

header(N) ->
    Head = head(N),
    Mid = mid(),
    Pad = pad(),
    <<Head/binary, Mid/binary, Pad/binary>>.

size_to_bin(N) ->
    A = N div 256 div 256 rem 256,
    B = N div 256 rem 256,
    C = N rem 256,
    <<0, A/integer, B/integer, C/integer>>.

bin_to_size(<<0, A/integer, B/integer, C/integer>>) ->
    256*256*A + 256*B + C.

head(16) ->
    <<66,77,138,3,0,0,0,0,0,0,138,0,0,0,124,0,0,0
     ,16,0,0,0,16,0,0,0,1,0,24,0,0,0,0,0,0,3,0>>;
head(32) ->
    <<66,77,138,12,0,0,0,0,0,0,138,0,0,0,124,0,0,0
     ,32,0,0,0,32,0,0,0,1,0,24,0,0,0, 0,0,0,12,0>>;
head(64) ->
    <<66,77,138,48,0,0,0,0,0,0,138,0,0,0,124,0,0,0
     ,64,0,0,0,64,0,0,0,1,0,24,0,0,0, 0,0,0,48,0>>;
head(128) ->
    <<66,77,138,192,0,0,0,0,0,0,138,0,0,0,124,0,0,0
     ,128,0,0,0,128,0,0,0,1,0,24,0,0,0,0,0,0,192,0>>;
head(256) ->
    <<66,77,138,0,3,0,0,0,0,0,138,0,0,0,124,0,0,0,0
     ,1,0,0,0,1,0,0,1,0,24,0,0,0,0,0,0,0,3>>;
head(512) ->
    <<66,77,138,0,12,0,0,0,0,0,138,0,0,0,124,0,0,0,0
     ,2,0,0,0,2,0,0,1,0,24,0,0,0,0, 0,0,0,12>>;
head(1024) ->
    <<66,77,138,0,48,0,0,0,0,0,138,0,0,0,124,0,0,0,0
     ,4,0,0,0,4,0,0,1,0,24,0,0,0,0, 0,0,0,48>>;
head(2048) ->
    <<66,77,138,0,192,0,0,0,0,0,138,0,0,0,124,0,0,0,0
     ,8,0,0,0,8,0,0,1,0,24,0,0,0,0,0,0,0,192>>.

mid() ->
    <<0,35,46,0,0,35,46,0,0,0,0,0,0,0,0,0,0,0,0,255,0,0,255,0,0,255
     ,0,0,0,0,0,0,0,66,71,82,115,0>>.

pad() ->
    <<0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>.

