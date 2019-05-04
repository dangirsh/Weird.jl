using Test, Weird
using Combinatorics: permutations
using Base.Iterators: flatten

function unordered_match((p_a, p_b, p_c), triples)
    # would be nice to use Match.jl here, but it fails for Enums!
    # https://github.com/kmsquire/Match.jl/issues/25
    [p_a, p_b, p_c] ∈ flatten(map(permutations, triples))
end

function proposition1(result::ExperimentResult)
    unordered_match(result, [
        (smooth, red, red),
        (smooth, blue, blue),
        (rough, red, blue)
    ])
end

function proposition2(result::ExperimentResult)
    unordered_match(result, [(smooth, smooth, rough)])
end


# @test proposition1((smooth, red, red))
# @test !proposition1((smooth, red, blue))
# @test proposition1((rough, red, blue))
# @test !proposition1((rough, blue, blue))

# @test proposition2((smooth, smooth, rough))
# @test proposition2((rough, smooth, smooth))
# @test !proposition2((rough, rough, rough))
# @test !proposition2((smooth, rough, rough))
# @test !proposition2((red, red, blue))

num_experiments = 10

for (context, result) in run_experiments(num_experiments)

    if context == context1
        @test proposition1(result)
    elseif context ==context2
        @test proposition2(result)
    else
        @error "Unknown context: $(context)."
    end

end
