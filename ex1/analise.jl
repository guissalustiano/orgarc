using Plots


arctan(x) = 4/(1+x^2)
plot(arctan, 0, 1, label="arctan(x)")


nThreads = 4;
num_steps = 30
step = 1.0/num_steps
half_step = step/2

colors = palette(:tab10)

for i = 1:num_steps
  x = (i-0.5)*step
  y = arctan(x)
  thread_id = (i-1) % nThreads

  x0 = x-half_step
  x1 = x+half_step
  rect = Shape([(x0, 0), (x0, y), (x1, y), (x1, 0)])

  color = colors[thread_id + 1]
  if (i <= nThreads)
    plot!(rect, fillcolor = plot_color(color, 0.5), label="thread $thread_id")
  else
    plot!(rect, fillcolor = plot_color(color, 0.5), label = "")
  end
end


savefig("plot.png")
