using Plots

data = [
  (1, 1.276),
  (2, 0.623),
  (4, 0.311),
  (6, 0.395),
  (8, 0.307),
  (10, 0.349),
  (12, 0.330),
  (14, 0.328),
  (16, 0.304)
]

scatter(data, title="Tempo de execução vs Número de threads", label="real time of execution")
ylabel!("Tempo de execução [s]")
xlabel!("Número de threads")

savefig("plot.png")
