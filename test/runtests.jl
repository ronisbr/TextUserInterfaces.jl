using Test
using TextUserInterfaces

# Check if the libraries were loaded
# ==============================================================================

@testset "Libraries loading..." begin
    init_tui()

    @test TextUserInterfaces.ncurses.libncurses != C_NULL
    @test TextUserInterfaces.ncurses.libpanel   != C_NULL
    @test TextUserInterfaces.ncurses.libmenu    != C_NULL
    @test TextUserInterfaces.ncurses.libform    != C_NULL

    destroy_tui()
end

# Check if the NCurses version is consistent
# ==============================================================================

@testset "NCurses version..." begin
    init_tui()

    ncurses_version = curses_version()

    @test haskey(ncurses_version, :major) == true
    @test haskey(ncurses_version, :minor) == true
    @test haskey(ncurses_version, :patch) == true
    @test ncurses_version.major           >= 5

    destroy_tui()
end

# Check if terminal resizing is working
# ==============================================================================

@testset "Terminal resizing..." begin
    init_tui()

    resizeterm(25,80)

    @test LINES() == 25
    @test COLS()  == 80

    destroy_tui()
end

# Log test
# ==============================================================================

# Check some functionalities using logs.
cd("./log_test/")
include("./log_test/log_test.jl")
cd("../")
