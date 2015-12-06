package edu.stonybrook.asynchronous.project.tests.positive;


import edu.stonybrook.asynchronous.project.userinteraction.Administrator;
import edu.stonybrook.asynchronous.project.userinteraction.User;

public class Test1 {
	
	public static void main(String[] args) {
		User admin = new Administrator();
		String csvFileDirectory = "";//"/home/nishanth/MS/Fall2015/Asynchronous Systems/Project/";		
		String csvFileName = "nameservers.csv";
		admin.setupChord(csvFileDirectory, csvFileName);	
	}
}
