## module to store consts

USAGE = "USAGE:\t./ga_polynomial"
FRAGMENT_LENGTH = 32
MAX_POPULATION = 500#0
FRAGMENT_PER_SOLUTION = 6
FITNESS_THRESHOLD = 0.01
SAMPLE_SIZE = int(MAX_POPULATION * 0.05)
CROSSOVER_RATE = 0.7
UNIFORM_CROSSOVER_PROB = 0.5
SOLUTION_MUTATION_RATE = 2 / FRAGMENT_PER_SOLUTION
TRIES = 100#0#0
ELITES_NUMBER = int(MAX_POPULATION * 0.01)
DATA_FILE = "datfile.dat"
HISTORY_FILE = "history.dump"
GNP_CONF_FILE = "conf.gnp"
CONF = ("set terminal png\n" +
        "set output \"output.jpg\"\n" +
        "set autoscale xy\n" +
        "plot \'{}\' using 1:2 title \"datfile\" lw 2 with line, ({})+({}*x)+({}*x**2)+({}*x**3)+({}*x**4)+({}*x**5) title \"myfunc\" lw 2 with line;")
GNP_EXEC = "gnuplot -persist {}".format(GNP_CONF_FILE)
