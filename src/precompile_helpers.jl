# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains functions to help the precompilation.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

const _bodyfunction = Dict{Method,Any}()

# Function obtained from MatLang.
#
# https://github.com/juliamatlab/MatLang

function _lookup_kwbody(mnokw::Method)
    function getsym(arg)
        isa(arg, Symbol) && return arg
        @assert isa(arg, GlobalRef)
        return arg.name
    end

    f = get(_bodyfunction, mnokw, nothing)
    if f === nothing
        fmod = mnokw.module
        # The lowered code for `mnokw` should look like
        #   %1 = mkw(kwvalues..., #self#, args...)
        #        return %1
        # where `mkw` is the name of the "active" keyword body-function.
        ast = Base.uncompressed_ast(mnokw)
        if isa(ast, Core.CodeInfo) && length(ast.code) >= 2
            callexpr = ast.code[end-1]
            if isa(callexpr, Expr) && callexpr.head == :call
                fsym = callexpr.args[1]
                if isa(fsym, Symbol)
                    f = getfield(fmod, fsym)
                elseif isa(fsym, GlobalRef)
                    if fsym.mod === Core && fsym.name === :_apply
                        f = getfield(mnokw.module, getsym(callexpr.args[2]))
                    elseif fsym.mod === Core && fsym.name === :_apply_iterate
                        f = getfield(mnokw.module, getsym(callexpr.args[3]))
                    else
                        f = getfield(fsym.mod, fsym.name)
                    end
                else
                    f = missing
                end
            else
                f = missing
            end
        else
            f = missing
        end
        _bodyfunction[mnokw] = f
    end
    return f
end

# Precompile fname()
macro precompile(fname)
    ex = quote
        if !precompile($fname, ())
            @warn("The method $($fname)$_argtypes could not be precompiled.")
        end
    end

    return esc(ex)
end

# Precompile fname(argtypes)
macro precompile(fname, argtypes)
    ex = quote
        local _argtypes = typeof($argtypes) <: Tuple ? $argtypes : ($argtypes,)
        if !precompile($fname, _argtypes)
            @warn("The method $($fname)$_argtypes could not be precompiled.")
        end
    end

    return esc(ex)
end

# Precompile fname(argtypes; kwnames::kwtypes)
macro precompile(fname, argtypes, kwnames, kwtypes)
    ex = quote
        local _argtypes = typeof($argtypes) <: Tuple ? $argtypes : ($argtypes,)
        local _kwtypes  = typeof($kwtypes)  <: Tuple ? $kwtypes  : ($kwtypes,)
        local _kwnames  = typeof($kwnames)  <: Tuple ? $kwnames  : ($kwnames,)

        if !precompile(Core.kwfunc($fname),
                       (NamedTuple{_kwnames, Tuple{_kwtypes...}},
                        typeof($fname), _argtypes...))
            @warn("The method $($fname)$_argtypes could not be precompiled.")
        end

        let fbody = try _lookup_kwbody(which($fname, _argtypes)) catch missing end
            result = false
            if !ismissing(fbody)
                result = precompile(fbody, (_kwtypes..., typeof($fname), _argtypes...))
            end

            !result && @warn("The body method $($fname)$_argtypes could not be precompiled.")
        end
    end

    return esc(ex)
end
