using Test
using TextUserInterfaces

init_tui()

# Check if the libraries were loaded
# ==============================================================================

@testset "Libraries loading..." begin
    @test TextUserInterfaces.ncurses.libncurses != C_NULL
    @test TextUserInterfaces.ncurses.libpanel   != C_NULL
    @test TextUserInterfaces.ncurses.libmenu    != C_NULL
    @test TextUserInterfaces.ncurses.libform    != C_NULL
end

# Check if the NCurses version is consistent
# ==============================================================================

@testset "NCurses version..." begin
    ncurses_version = curses_version()

    @test haskey(ncurses_version, :major) == true
    @test haskey(ncurses_version, :minor) == true
    @test haskey(ncurses_version, :patch) == true
    @test ncurses_version.major           >= 5

end

destroy_tui()
