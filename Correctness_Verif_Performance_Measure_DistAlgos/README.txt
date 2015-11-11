Algorithms taken for correctness and performance tests:
1. Lamport Mutual Exclusion algorithm. [File name is lamutex.da].
2. Ricart & Agarwala Timestamp based Algorithm. [File name is ramutex.da].
3. Ricart & Agarwala Token Based Algorithm. [File name is ratoken.da].

IDEA BEHIND IMPLEMENTATION:

The distributed system (DS) runs on some algorithm X. The DS is wrapped by a Monitor which handles 'special messages' from DS. Montior then using utility modules like correctnessTester.py, etc to test the algorithm for correctness, performance, etc. Main.da is the entry point to this whole system. The correctness testing is looked at from the 'Critical Section' point of view. That is, assume writing to a file is the task in critical section. If some intelligence is added to the file, it can track if the requesting/accessing process has violated any of the properties. This is achieved by using the monitor. It is to this monitor every Process reports to in critical section. So, it has enough knowledge and intelligence to handle the inconsistency in algorithm, if any. Ultimately, output is written inside output directory in separate files, which the user can use to analyze. 

The various outputs are:
1. The table describing the overall execution state of the DS is written to .txt files in output folder.  
2. The performance metrics graph is saved as an JPG file. 
	a. Total Time Measurement Figure :- It records the total time taken for each process for different performance parameter values.
	b. Communication Time Measurement Figure:- It records the total time a process spends in communication to other process.
	c. Waiting Time Measurement Figure:- It records the time each process 'awaits' on a condition.
	d. CS Time Measurement Figure :- It records the time each process spends in the Critical Section.

Also, some information is output in the console in different colors. 

GREEN - TEST PASSED, SYSTEM IS CONSISTENT.
RED - TEST FAILED, SYSTEM IS INCONSISTENT.
ORANGE - TEST FAILED, SYSTEM IS CONSISTENT.

Note:- All performance measures are in time unit - seconds.

Performance Parameter Chosen:-

Performance parameter, 's' means the following in this implementation:

	It simulates the real-time communication lag which one might experience over network calls. So, s = 1 means each communication between processes has a delay of 1 second. 

Logic behind tests:

All the logic behind the tests are included in the doc string of the functions present in 'correctnessTester.py'. Documentation is added as needed in code as required. The monitor outputs a table of events as seen by it. It is chosen not to display these tables in console as I felt it is a bit cluttered. These tables can be found in the 'output' directory.

CREDITS:

The base implementation of all the three algorithms are taken from the 'examples' folder in DistAlgo source package found in git/sourceforge. The implementation of ratoken.da did not update the clock appropriately. So, added statements in the implementation in approriate places to updates the clock values.

Note: Screenshot of sample execution is enclosed in the zip file.
