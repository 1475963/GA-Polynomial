## module to store consts

USAGE = "USAGE:\t./ga_polynomial"
FRAGMENT_LENGTH = 16
MAX_POPULATION = 800#0
FRAGMENT_PER_SOLUTION = 6
FITNESS_THRESHOLD = 0.01
SAMPLE_SIZE = MAX_POPULATION * 0.1
CROSSOVER_RATE = 0.75
UNIFORM_CROSSOVER_PROB = 0.5
SOLUTION_MUTATION_RATE = 0.1
TRIES = 10#0#00
DATA_FILE = "datfile.dat"
HISTORY_FILE = "history.dump"
GNP_CONF_FILE = "conf.gnp"
CONF = ("set terminal png\n" +
        "set output \"output.jpg\"\n" +
        "set xrange[-100:900]\n" +
        "plot \'{}\' using 1:2 title \"datfile\" lw 2 with line, ({})+({}*x)+({}*x**2)+({}*x**3)+({}*x**4)+({}*x**5) title \"myfunc\" lw 2 with line;")
GNP_EXEC = "gnuplot -persist {}".format(GNP_CONF_FILE)
