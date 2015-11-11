###################################
#Name     % Nishanth Muruganandam #
###################################
#StudentID% 110276247 		  #
###################################

CREDITS: The base code of Simple Paxos is taken from DistAlgo package in sourceforge.net. The answers to the first two questions were interpreted from the respective papers.

Description of files present and generated on run:

1. main.da - The place where the main code of Simple Paxos and various tests on them reside.

2. plotter.py - A script that takes care of drawing tables and graphs and then saving them. 

3. output - Directory where the output of the run is stored as files. When the program is run, it generates three files:
	.report - File where the report on the correctness is present. It reports the state on every possible update of the state in the system.

	.txt - File where the performance measures like Standard deviation, range, etc and the parameter set used for the run are present.

	.jpg - Graph reprsenting the CPU and Elapsed time in each run of the program.

4. answers.pdf - Answers to the first two questions is present there.

Parameters to main.da:

Parameters are described in the order they are given as input:

1. NumberOfAcceptors - default value 3.
2. NumberOfProposers - default value 3.
3. NumberOfLearners  - default value 3.
4. NumberOfRepitions - default value 3.
5. MSG_LOSS_RATE     - default value 0.It is a float value. 
6. MSG_DELAY         - default value 0.
7. WAIT_TIME 	     - default value 0. Gives the waiting time of 			proposer before proposing again.
8. TOUT_LEARNER      - Timeout value for learner.
9. TOUT_Proposer     - Timeout value for proposer.
10.Premption         - Flag to turn on/off Premptive mode.
11.Timeout           - Flag to turn on/off Timeout mode.
12.Filename          - Filename to save to in the output directory.

Note:
1. By giving all the possible values for 10 & 11, we can simulate the four modes of operation required in the assignment. 

2. The program throws an expected Exception on the following cases:
  (i)  MSG_LOSS_RATE should be between 0 and 1, strictly. 
  (ii) MSG_DELAY must be strictly lesser than TOUT_LEARNER & TOUT_Proposer. Otherwise, the program never runs into completion because timeout occurs before the receipt of any message.
  (iii)MSG_DELAY is 0 and both Timeout is not 0.

Logic on correcntss test:

Safety: In a system running Paxos, at any time T, there must be atmost one value that is learnt. The learner, on learning a value, sends the learnt value to the Monitor. If, at any instant, the number of leaders becomes more than one, it confirms the violation of safety and is reported in the .report file. Note that, the learner that sent the message to the Monitor will wait for the Ack from Monitor to ensure consistency. Also, a learner should learn only the value that was proposed and nothing else. Both safety checks are made in the Monitor.

Liveness: (i) If some processes are waiting to be the Leader, then some process is already the Leader. This is ascertained by sending a message from the Proposer to Monitor before sending prepare request. The Monitor has the count of the waiting processes and if there is no leader, it reports a violation on the Liveness. 
	  (ii) If a value is chosen, eventually all learners should learn that value. 
	  These two Liveness tests are done in the code and reported in the .report file. For more clarity, look into the 'On-termination' line in report. Other lines dynamically provide information on the state on each major step.

Fairness: Fairness measured here is StrongFairness - Starvation Freedom. If any process wants to be a leader, eventually it becomes a Leader. Otherwise, fairness is violated. This can be achieved by using the same Monitor by performing check when the run is terminating to check if all the requests are served. 

Results I found:
Correctness-wise: The algorithm fails to achieve Liveness because even when there is no Leader, waiting is inevitable as it waits for replies from majority of acceptors to become the Leader. Also, all the requested Process cannot become Leader as one other process may always edge it off to become the leader resulting in Starvation of the freedom. However, talking in real-world sense, these two do not impact the working of the system using the Paxos behind it. I happened to find a state when there was a lock in the execution when the Round_Waiting_Time was kept 0. It was not necessarily a deadlock but a live one. I could not reciprocate that state afterwards. The time out for proposer should not linear rather it should be an exponential backoff time period to ensure that livelock does not happen.

Performance-wise: The elapsed time and CPU time increase evidently with even a small increase in MSG_LOSS_RATE. If premption is enabled, the CPU time is decreasing a bit becuase of avoidance of awaiting of Proposer. Different interesting results can be obtained by varying the parameters 5,6,7,8,9,10 & 11. <Note: Make sure that file name is unique for each different runs otherwise the file will get overwritten>

