import sys
import cProfile, pstats
import ga_polynomial as GA_POLY
import consts as Consts

data = []
dataMatrix = []

""" entry point """

if __name__ == '__main__':
    if len(sys.argv) == 1:
        try:
            pr = cProfile.Profile()
            pr.enable()
            data = GA_POLY.getData(Consts.DATA_FILE)
            dataMatrix = GA_POLY.getDataMatrix(data)
            GA_POLY.ga_polynomial()
            pr.disable()
            with open(r"profile", "w+") as s:
                ps = pstats.Stats(pr, stream=s).sort_stats('cumulative')
                ps.print_stats()
        except ValueError as e:
            print(e)
    else:
        print(Consts.USAGE)