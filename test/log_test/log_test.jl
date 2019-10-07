# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   This test initializes TUI, create widgets, and compare the log the with
#   model.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

@testset "Log test..." begin
    include("./model.jl")
    log_test()

    # Compare the created log with the reference.
    result = read("tui.log",String)
    expect = read("reference.log",String)

    @test result == expect
end
