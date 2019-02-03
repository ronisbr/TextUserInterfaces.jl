const keycodes =
Dict(
     "\eOA"                   => Keystroke("\eOA"                   , :up              , false , false , false) ,
     "\e[1;2A"                => Keystroke("\e[1;2A"                , :up              , false , false , true ) ,
     "\e[1;5A"                => Keystroke("\e[1;5A"                , :up              , false , true  , false) ,
     "\e[1;6A"                => Keystroke("\e[1;6A"                , :up              , false , true  , true ) ,
     "\e[1;9A"                => Keystroke("\e[1;9A"                , :up              , true  , false , false) ,
     "\e[1;10A"               => Keystroke("\e[1;10A"               , :up              , true  , false , true ) ,
     "\eOB"                   => Keystroke("\eOB"                   , :down            , false , false , false) ,
     "\e[1;2B"                => Keystroke("\e[1;2B"                , :down            , false , false , true ) ,
     "\e[1;5B"                => Keystroke("\e[1;5B"                , :down            , false , true  , false) ,
     "\e[1;6B"                => Keystroke("\e[1;6B"                , :down            , false , true  , true ) ,
     "\e[1;9B"                => Keystroke("\e[1;9B"                , :down            , true  , false , false) ,
     "\e[1;10B"               => Keystroke("\e[1;10B"               , :down            , true  , false , true ) ,
     "\eOC"                   => Keystroke("\eOC"                   , :right           , false , false , false) ,
     "\e[1;2C"                => Keystroke("\e[1;2C"                , :right           , false , false , true ) ,
     "\e[1;5C"                => Keystroke("\e[1;5C"                , :right           , false , true  , false) ,
     "\e[1;6C"                => Keystroke("\e[1;6C"                , :right           , false , true  , true ) ,
     "\e[1;9C"                => Keystroke("\e[1;9C"                , :right           , true  , false , false) ,
     "\e[1;10C"               => Keystroke("\e[1;10C"               , :right           , true  , false , true ) ,
     "\eOD"                   => Keystroke("\eOD"                   , :left            , false , false , false) ,
     "\e[1;2D"                => Keystroke("\e[1;2D"                , :left            , false , false , true ) ,
     "\e[1;5D"                => Keystroke("\e[1;5D"                , :left            , false , true  , false) ,
     "\e[1;6D"                => Keystroke("\e[1;6D"                , :left            , false , true  , true ) ,
     "\e[1;9D"                => Keystroke("\e[1;9D"                , :left            , true  , false , false) ,
     "\e[1;10D"               => Keystroke("\e[1;10D"               , :left            , true  , false , true ) ,
     "\e[A"                   => Keystroke("\e[A"                   , :up              , false , false , false) ,
     "\e\e[A"                 => Keystroke("\e\e[A"                 , :up              , true  , false , false) ,
     "\e[B"                   => Keystroke("\e[B"                   , :down            , false , false , false) ,
     "\e\e[B"                 => Keystroke("\e\e[B"                 , :down            , true  , false , false) ,
     "\e[C"                   => Keystroke("\e[C"                   , :right           , false , false , false) ,
     "\e\e[C"                 => Keystroke("\e\e[C"                 , :right           , true  , false , false) ,
     "\e[D"                   => Keystroke("\e[D"                   , :left            , false , false , false) ,
     "\e\e[D"                 => Keystroke("\e\e[D"                 , :left            , true  , false , false) ,
     "\e[H"                   => Keystroke("\e[H"                   , :home            , false , false , false) ,
     "\e[1;2H"                => Keystroke("\e[1;2H"                , :home            , false , false , true ) ,
     "\e[1;5H"                => Keystroke("\e[1;5H"                , :home            , false , true  , false) ,
     "\e[1;9H"                => Keystroke("\e[1;9H"                , :home            , true  , false , false) ,
     "\e[1;10H"               => Keystroke("\e[1;10H"               , :home            , true  , false , true ) ,
     "\e[1;13H"               => Keystroke("\e[1;13H"               , :home            , true  , true  , false) ,
     "\e[F"                   => Keystroke("\eOF"                   , :end             , false , false , false) ,
     "\e[1;2F"                => Keystroke("\e[1;2F"                , :end             , false , false , true ) ,
     "\e[1;5F"                => Keystroke("\e[1;5F"                , :end             , false , true  , false) ,
     "\e[1;9F"                => Keystroke("\e[1;9F"                , :end             , true  , false , false) ,
     "\e[1;10F"               => Keystroke("\e[1;10F"               , :end             , true  , false , true ) ,
     "\e[1;13F"               => Keystroke("\e[1;13F"               , :end             , true  , true  , false) ,
     "\eOP"                   => Keystroke("\eOP"                   , :F1              , false , false , false) ,
     "\eOQ"                   => Keystroke("\eOQ"                   , :F2              , false , false , false) ,
     "\eOR"                   => Keystroke("\eOR"                   , :F3              , false , false , false) ,
     "\eOS"                   => Keystroke("\eOS"                   , :F4              , false , false , false) ,
     "\e[15~"                 => Keystroke("\e[15~"                 , :F5              , false , false , false) ,
     "\e[17~"                 => Keystroke("\e[17~"                 , :F6              , false , false , false) ,
     "\e[18~"                 => Keystroke("\e[18~"                 , :F7              , false , false , false) ,
     "\e[19~"                 => Keystroke("\e[19~"                 , :F8              , false , false , false) ,
     "\e[20~"                 => Keystroke("\e[20~"                 , :F9              , false , false , false) ,
     "\e[21~"                 => Keystroke("\e[21~"                 , :F10             , false , false , false) ,
     "\e[23~"                 => Keystroke("\e[23~"                 , :F11             , false , false , false) ,
     "\e[24~"                 => Keystroke("\e[24~"                 , :F12             , false , false , false) ,
     "\e[1;2P"                => Keystroke("\e[1;2P"                , :F1              , false , false , true)  ,
     "\e[1;2Q"                => Keystroke("\e[1;2Q"                , :F2              , false , false , true)  ,
     "\e[1;2R"                => Keystroke("\e[1;2R"                , :F3              , false , false , true)  ,
     "\e[1;2S"                => Keystroke("\e[1;2S"                , :F4              , false , false , true)  ,
     "\e[15;2~"               => Keystroke("\e[15;2~"               , :F5              , false , false , true)  ,
     "\e[17;2~"               => Keystroke("\e[17;2~"               , :F6              , false , false , true)  ,
     "\e[18;2~"               => Keystroke("\e[18;2~"               , :F7              , false , false , true)  ,
     "\e[19;2~"               => Keystroke("\e[19;2~"               , :F8              , false , false , true)  ,
     "\e[20;2~"               => Keystroke("\e[20;2~"               , :F9              , false , false , true)  ,
     "\e[21;2~"               => Keystroke("\e[21;2~"               , :F10             , false , false , true)  ,
     "\e[23;2~"               => Keystroke("\e[23;2~"               , :F11             , false , false , true)  ,
     "\e[24;2~"               => Keystroke("\e[24;2~"               , :F12             , false , false , true)  ,
     "\e[1;3P"                => Keystroke("\e[1;3P"                , :F1              , true  , false , false) ,
     "\e[1;3Q"                => Keystroke("\e[1;3Q"                , :F2              , true  , false , false) ,
     "\e[1;3R"                => Keystroke("\e[1;3R"                , :F3              , true  , false , false) ,
     "\e[1;3S"                => Keystroke("\e[1;3S"                , :F4              , true  , false , false) ,
     "\e[15;3~"               => Keystroke("\e[15;3~"               , :F5              , true  , false , false) ,
     "\e[17;3~"               => Keystroke("\e[17;3~"               , :F6              , true  , false , false) ,
     "\e[18;3~"               => Keystroke("\e[18;3~"               , :F7              , true  , false , false) ,
     "\e[19;3~"               => Keystroke("\e[19;3~"               , :F8              , true  , false , false) ,
     "\e[20;3~"               => Keystroke("\e[20;3~"               , :F9              , true  , false , false) ,
     "\e[21;3~"               => Keystroke("\e[21;3~"               , :F10             , true  , false , false) ,
     "\e[23;3~"               => Keystroke("\e[23;3~"               , :F11             , true  , false , false) ,
     "\e[24;3~"               => Keystroke("\e[24;3~"               , :F12             , true  , false , false) ,
     "\e[1;5P"                => Keystroke("\e[1;5P"                , :F1              , false , true  , false) ,
     "\e[1;5Q"                => Keystroke("\e[1;5Q"                , :F2              , false , true  , false) ,
     "\e[1;5R"                => Keystroke("\e[1;5R"                , :F3              , false , true  , false) ,
     "\e[1;5S"                => Keystroke("\e[1;5S"                , :F4              , false , true  , false) ,
     "\e[15;5~"               => Keystroke("\e[15;5~"               , :F5              , false , true  , false) ,
     "\e[17;5~"               => Keystroke("\e[17;5~"               , :F6              , false , true  , false) ,
     "\e[18;5~"               => Keystroke("\e[18;5~"               , :F7              , false , true  , false) ,
     "\e[19;5~"               => Keystroke("\e[19;5~"               , :F8              , false , true  , false) ,
     "\e[20;5~"               => Keystroke("\e[20;5~"               , :F9              , false , true  , false) ,
     "\e[21;5~"               => Keystroke("\e[21;5~"               , :F10             , false , true  , false) ,
     "\e[23;5~"               => Keystroke("\e[23;5~"               , :F11             , false , true  , false) ,
     "\e[24;5~"               => Keystroke("\e[24;5~"               , :F12             , false , true  , false) ,
     "\eOn"                   => Keystroke("\eOn"                   , :keypad_dot      , false , false , false) ,
     "\eOM"                   => Keystroke("\eOM"                   , :keypad_enter    , false , false , false) ,
     "\eOj"                   => Keystroke("\eOj"                   , :keypad_asterisk , false , false , false) ,
     "\eOk"                   => Keystroke("\eOk"                   , :keypad_plus     , false , false , false) ,
     "\eOm"                   => Keystroke("\eOm"                   , :keypad_minus    , false , false , false) ,
     "\eOo"                   => Keystroke("\eOo"                   , :keypad_slash    , false , false , false) ,
     "\eOX"                   => Keystroke("\eOX"                   , :keypad_equal    , false , false , false) ,
     "\eOp"                   => Keystroke("\eOp"                   , :keypad_0        , false , false , false) ,
     "\eOq"                   => Keystroke("\eOq"                   , :keypad_1        , false , false , false) ,
     "\eOr"                   => Keystroke("\eOr"                   , :keypad_2        , false , false , false) ,
     "\eOs"                   => Keystroke("\eOs"                   , :keypad_3        , false , false , false) ,
     "\eOt"                   => Keystroke("\eOt"                   , :keypad_4        , false , false , false) ,
     "\eOu"                   => Keystroke("\eOu"                   , :keypad_5        , false , false , false) ,
     "\eOv"                   => Keystroke("\eOv"                   , :keypad_6        , false , false , false) ,
     "\eOw"                   => Keystroke("\eOw"                   , :keypad_7        , false , false , false) ,
     "\eOx"                   => Keystroke("\eOx"                   , :keypad_8        , false , false , false) ,
     "\eOy"                   => Keystroke("\eOy"                   , :keypad_9        , false , false , false) ,
     "\e[3~"                  => Keystroke("\e[3~"                  , :delete          , false , false , false) ,
     "\e[5~"                  => Keystroke("\e[5~"                  , :pageup          , false , false , false) ,
     "\e\e[5~"                => Keystroke("\e\e[5~"                , :pageup          , true  , false , false) ,
     "\e[6~"                  => Keystroke("\e[6~"                  , :pagedown        , false , false , false) ,
     "\e\e[6~"                => Keystroke("\e\e[6~"                , :pagedown        , true  , false , false) ,
     "\e"*string(Char(0x153)) => Keystroke("\e"*string(Char(0x153)) , :pageup          , true  , false , false) ,
     "\e"*string(Char(0x152)) => Keystroke("\e"*string(Char(0x152)) , :pagedown        , true  , false , false) ,
    )

const nocharval = typemax(UInt32)
