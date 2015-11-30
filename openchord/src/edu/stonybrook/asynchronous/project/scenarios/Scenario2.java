package edu.stonybrook.asynchronous.project.scenarios;

import edu.stonybrook.asynchronous.project.data.StringKey;
import edu.stonybrook.asynchronous.project.userinteraction.Administrator;
import edu.stonybrook.asynchronous.project.userinteraction.User;

public class Scenario2 {
	
	public static void main(String[] args) {
		User admin = new Administrator();
		String csvFileDirectory = "/home/nishanth/MS/Fall2015/Asynchronous Systems/Project/";		
		String csvFileName = "nameservers.csv";
		admin.setupChord(csvFileDirectory, csvFileName);
		
		admin.insertData(new StringKey("Admin"),"Hello Chord!");
		System.out.println("Data inserted");
	}
}
