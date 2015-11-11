import tabulate
import numpy as np
import matplotlib.pyplot as plt
import os

#######################################################
#This is a utility module for plotting graphs, drawing# 
#from the values passed by monitor                    #
#######################################################

cpuTimeSD = 0
elapsedTimesSD = 0
cpuTimeRange = 0
elapsedTimeRange = 0

fileName = None
directory = None

def createDirectory(d):

	if not os.path.exists(d):
		os.makedirs(d)
	global directory
	directory = d

def setFileName(name):
	global fileName
	fileName = name

def plot(cpuTimes,elapsedTimes):

	global cpuTimeSD
	global elapsedTimesSD
	global elapsedTimeRange
	global cpuTimeRange
	global fileName
	global directory

	figure0 = plt.figure(0)

	x = [i for i in range(1,len(cpuTimes)+1)]
	plt.plot(x,cpuTimes,'-b',label='CPU Time')
	#plt.plot(x,elapsedTimes,'-r',label='Elapsed Time')
	plt.xlabel('Runs',fontsize=18)
	plt.ylabel('Time',fontsize=18)
	plt.legend(loc='upper left')
	#plt.show()
	
	figure0.suptitle('CPU Time',fontsize= 20)
	figure0.savefig(directory+'/'+fileName+'CPUTime.jpg')

	figure1= plt.figure(1)
	plt.plot(x,elapsedTimes,'-r',label='Elapsed Time')
	plt.xlabel('Runs',fontsize=18)
	plt.ylabel('Time',fontsize=18)
	plt.legend(loc='upper left')
	plt.show()
	figure1.suptitle('Elapsed Time',fontsize= 20)
	figure1.savefig(directory+'/'+fileName+'ElapsedTime.jpg')


	cpuTimeSD = np.std(cpuTimes)
	elapsedTimesSD = np.std(elapsedTimes)
	cpuTimeRange = max(cpuTimes) - min(cpuTimes)
	elapsedTimeRange = max(elapsedTimes) - min(elapsedTimes)

def drawTable(execTimes,parameters):
	global cpuTimeSD
	global elapsedTimesSD
	global elapsedTimeRange
	global cpuTimeRange
	global directory
	header = list(execTimes.keys())
	f = open(directory+'/'+fileName+'.txt','a')
	f.write('Execution Times observed. (Also present as a .jpg file)\n')
	f.write(tabulate.tabulate(execTimes,headers=header,tablefmt='fancy_grid',numalign='right'))
	parameters['SD-CTime'] = [cpuTimeSD]
	parameters['SD-ETime'] = [elapsedTimesSD]
	parameters['Range-CTime'] = [cpuTimeRange]
	parameters['Range-ETime'] = [elapsedTimeRange]
	header = list(parameters.keys())
	f.write('\nParameter values used. Refer README.txt for the meaning of the columns\n')
	f.write(tabulate.tabulate(parameters,headers=header,tablefmt='fancy_grid',numalign='right'))
	f.close()

def correctnessReport(result,msgs):
	f = open(directory+'/'+fileName+'.report','a')
	f.write('Safety : ' + str(result[0]))
	f.write('  Liveness(i) : ' + str(result[1]))
	f.write('  Liveness(ii) : ' + str(result[2]))
	f.write('  Fairness : ' + str(result[3]))
	f.write(msgs)
	f.write('\n')
	f.close()
