#################### ChainProgress Type ####################

type ChainProgress
  chain::Integer
  iters::Integer
  counter::Integer
  runin::Integer
  threshold::Float64
  t0::Float64

  function ChainProgress(chain::Integer, iters::Integer)
    new(chain, iters, 0, max(1, min(10, iround(0.01 * iters))), 0.0, time())
  end
end


#################### ChainProgress Methods ####################

function next!(p::ChainProgress)
  p.counter += 1
  if p.counter / p.iters >= p.threshold && p.counter >= p.runin
    p.threshold += 0.10
    print(STDOUT, p)
  end
  p
end

function Base.print(io::IO, p::ChainProgress)
  elapsed = time() - p.t0
  remaining = elapsed * (p.iters / p.counter - 1.0)
  str = @sprintf("Chain %u: %3u%% [%s of %s remaining]",
                 p.chain,
                 100.0 * p.counter / p.iters,
                 strfsec(remaining),
                 strfsec(elapsed + remaining))
  println(io, str)
end

function strfsec(sec::Real)
  hr, sec = divrem(sec, 3600)
  min, sec = divrem(sec, 60)
  @sprintf "%u:%02u:%02u" hr min sec
end
