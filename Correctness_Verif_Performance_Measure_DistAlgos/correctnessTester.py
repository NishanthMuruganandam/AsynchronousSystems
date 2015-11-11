import colors

##################################################################
#This is the module used for testing correctness. It performs    #
#safety, liveliness and fairness test on the list of values sent #
#from the monitor.						 #
##################################################################


def testCorrectness(rows,istoken):

	color = colors.bcolors()
	

	if safetyTest(rows,istoken) == True:
		print (color.OKGREEN+'Safety Test Passed!!!')
	else:
		print (color.FAIL+'Safety Test Failed!!!')
		
	if livelinessTest(rows) == True:
		print (color.OKGREEN + 'Liveliness Test Passed!!!')
	else:
		print (color.WARNING + 'Liveliness Test Failed!!!')

	if fairnessTest(rows) == True:
		print (color.OKGREEN + 'Fairness Test Passed!!!')
	else:
		print (color.WARNING + 'Fairness Test Failed!!!')
	print (color.ENDC)



def safetyTest(rows,istoken):

	""" This function tests the safety property of the algorithm.
	    It does that in 2 steps: 1) CSSafe Test, 2) ReleaseSyncTest

	    1) CSSafe Test: This test ensures that at any time 'T' only one process uses CS.
	    2) ReleaseSync Test: This test ensures that only the process which executed CS, is releasing a resource.

	"""
	csTest = isCSSafe(rows)
	if istoken:
		return csTest
	releaseTest = isReleaseSync(rows)
	return csTest and releaseTest

def isCSSafe(rows):

	processesInCS = {}
	flag = True

	for row in rows:
		if (row[2]!='None'):
			if row[0] not in processesInCS:
				processesInCS[row[0]] = row[2]
			else:
				print ('!!!!!!!!!!!!!!!!'+str(row[2]) + ' and ' + str(processesInCS[row[0]]) + 'are in the CS at the same time T=' + str(row[0]))
				flag = False
	print ("Is CS safe: " + str(flag))
	return flag
	
def isReleaseSync(rows):

	currentlyInCS = 'None';

	for row in rows:

		if row[2] != 'None':
			if currentlyInCS == 'None':
				currentlyInCS = row[2]
			else:
				return False
		if row[3] != 'None':
			if row[3] == currentlyInCS:
				currentlyInCS = 'None'
			else:
				return False
	print ("Release is sync")
	return True
		

def livelinessTest(rows):
	""" This function checks if every process that requests for CS, eventually gets served"""
	
	firstEntry = True
	requestCount = 0
	processInCS = 'None'
	release = False

	for row in rows:
	
		if row[1] != 'None':
			if firstEntry or processInCS != 'None':
				requestCount += 1			
			elif release:
				pass
			else:
				print ("Process " + str(row[1]) + " is unneccessarily waiting for CS at time " + str(row[0]))
				return False
		if row[2] != 'None':
			firstEntry = False
			processInCS = row[2]
		if row[3] == processInCS:
			processInCS = 'None'
			release = True
			continue
		if (processInCS == 'None' and requestCount != 0 and not firstEntry):
			return False
		release = False
	return True	

def fairnessTest(rows):
	
	""" This function tests if the processes are being served in a fair way. The one who is waiting for long time
	    must be given priority over others(FIFO)"""

	queue = [] 
	flag = True
	color = colors.bcolors()

         
	for row in rows:
		if row[1] != 'None':
			queue.append(row[1])
			continue
		if row[2] != 'None' and queue[0] != row[2]:
			print (color.WARNING + "Process " + str(row[2]) + "jumped ahead of the queue. Fairness violated at " + str(row[0]) )
			return False
		elif row[2] != 'None':
			queue.remove(row[2])
	return True
