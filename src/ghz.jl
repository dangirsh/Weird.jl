using Base.Iterators: product, flatten
using Combinatorics: permutations
using Test
using Random

@enum Color red blue

@enum Texture smooth rough

Property = Union{Color, Texture}

@enum MeasurementAction peek poke

struct Box
    color::Color
    texture::Texture
end

Box(red, smooth)

Triple{T} = NTuple{3, T} where T <: Any

ExperimentContext = Triple{MeasurementAction}

ExperimentResult = Triple{Property}

SystemState = Triple{Box}

function Base.rand(::Type{Box})
    all_colors = instances(Color)
    all_textures = instances(Texture)
    color, texture = product(all_colors, all_textures) |> collect |> rand
    Box(color, texture)
end

Base.rand(::Type{NTuple{3, T}}) where T = (rand(T), rand(T), rand(T))

triple_box_factory() = rand(SystemState)

function measure(box::Box, action::MeasurementAction)::Property
    if action == peek
        box.color
    else
        @assert action == poke
        box.texture
    end
end

function measure(state::SystemState, context::ExperimentContext)::ExperimentResult
    ExperimentResult(measure(box, action) for (box, action) in zip(state, context))
end

export context1, context2, run_experiments

const context1 = (poke, peek, peek)
const context2 = (poke, poke, poke)

function run_experiments(num_runs)
    rng = MersenneTwister(42)

   function experiment(id)
       state = triple_box_factory()
       context = rand(rng, Bool) ? context1 : context2
       result = measure(state, context)
       (context, result)
    end

    [experiment(id) for id in 1:num_runs]
end
