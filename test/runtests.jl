using Test
using TextUserInterfaces

init_tui()

@test TextUserInterfaces.ncurses.libncurses != C_NULL
@test TextUserInterfaces.ncurses.libpanel   != C_NULL
@test TextUserInterfaces.ncurses.libmenu    != C_NULL
@test TextUserInterfaces.ncurses.libform    != C_NULL

destroy_tui()
