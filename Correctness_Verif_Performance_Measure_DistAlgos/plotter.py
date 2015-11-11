import tabulate
import numpy as np
import matplotlib.pyplot as plt
import os

#######################################################
#This is a utility module for plotting graphs, drawing# 
#from the values passed by monitor                    #
#######################################################
def drawTable(rows,header,filename):

	#print(tabulate.tabulate(rows,headers=header,tablefmt='fancy_grid', numalign='right'));
	f = open('output/'+filename+'.txt','w')
	f.write(tabulate.tabulate(rows,headers=header,tablefmt='fancy_grid', numalign='right'));
	f.close();

def prepGraph(rows):

	f = open('Graph.txt','a');
	i = 0;
	for row in rows:
		string = 'P'+str(i)		
		f.write(string + ' ')
		j = 1
		while j<len(row):
			f.write(str(row[j])+ ' ')
			j += 1
		f.write("\n")
		i += 1
	f.close()


def drawGraph(filename):


	x = []
	tty = []
	comy = []
	csy = []
	wty=[]

	f = open('Graph.txt','r')
	processedP = set()

	lines = f.readlines()
	lines.sort()

	for line in lines:
		line = line.split(' ')
		if line[1] not in x:
			x.append(line[1])
	
	lines1 = lines;
	for line in lines:
		line = line.split(' ')
		if line[0] in processedP:
			continue
		tty = []
		comy =[]
		csy = []
		wty = []
		processedP.add(line[0])
		for line1 in lines1:
			line1 = line1.split(' ')
			if line1[0] == line[0]:
				tty.append(line1[2])
				comy.append(line1[3])
				csy.append(line1[4])
				wty.append(line1[5])
		
		figure0 = plt.figure(0)
		plt.plot(x,tty)
		plt.xlabel('Performance Parameter = Communication Delay(in seconds)', fontsize = 18)
		plt.ylabel('Total Time (in seconds) ' ,fontsize = 18)
		figure0.suptitle('Total Time Measurement', fontsize=20)
		figure0.savefig('output/TotalTime' + filename + '.jpg')
		
		figure1 = plt.figure(1)
		plt.plot(x,comy)
		plt.xlabel('Performance Parameter = Communication Delay(in seconds)', fontsize = 18)
		plt.ylabel('Communication time (in seconds) ' , fontsize = 18)
		figure1.suptitle('Communication Time Measurement', fontsize=20)		
		figure1.savefig('output/CommTime' + filename + '.jpg')	

		figure2 = plt.figure(2)
		plt.plot(x,csy)
		plt.xlabel('Performance Parameter = Communication Delay(in seconds)', fontsize = 18)
		plt.ylabel('Time in CS(in seconds)',fontsize = 18)
		figure2.suptitle('Time spent in critical section', fontsize = 20)
		figure2.savefig('output/CSTime' + filename + '.jpg')
		
		figure3 = plt.figure(3)
		plt.plot(x,wty)
		plt.xlabel('Performance Parameter = Communication Delay(in seconds)', fontsize = 18)
		plt.ylabel('Totol waiting time',fontsize = 18)
		figure3.suptitle('Waiting Time', fontsize=20)
		figure3.savefig('output/WaitingTime' + filename + '.jpg')

	plt.show()
	destroy()			
		
def destroy():
	os.remove('Graph.txt')
