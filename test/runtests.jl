using Test
using TextUserInterfaces
using TextUserInterfaces.NCurses

# Check If The Libraries Were Loaded
# ==========================================================================================

@testset "Libraries loading..." begin
    init_tui()

    @test TextUserInterfaces.ncurses.libncurses != C_NULL
    @test TextUserInterfaces.ncurses.libpanel   != C_NULL
    @test TextUserInterfaces.ncurses.libmenu    != C_NULL
    @test TextUserInterfaces.ncurses.libform    != C_NULL

    destroy_tui()
end

# Check If The NCurses Version Is Consistent
# ==========================================================================================

@testset "NCurses version..." begin
    init_tui()

    ncurses_version = curses_version()

    @test haskey(ncurses_version, :major) == true
    @test haskey(ncurses_version, :minor) == true
    @test haskey(ncurses_version, :patch) == true
    @test ncurses_version.major           >= 5

    destroy_tui()
end
