#############################################################################################
#This utility class was taken from   							    #	
#https://svn.blender.org/svnroot/bf-blender/trunk/blender/build_files/scons/tools/bcolors.py#
#for printing in different colors in terminal						    #			
#############################################################################################
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

    def disable(self):
        self.HEADER = ''
        self.OKBLUE = ''
        self.OKGREEN = ''
        self.WARNING = ''
        self.FAIL = ''
        self.ENDC = ''
