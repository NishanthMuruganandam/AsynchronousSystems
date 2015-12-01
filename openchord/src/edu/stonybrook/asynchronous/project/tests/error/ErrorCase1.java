package edu.stonybrook.asynchronous.project.tests.error;

import edu.stonybrook.asynchronous.project.userinteraction.Administrator;
import edu.stonybrook.asynchronous.project.userinteraction.User;

public class ErrorCase1 {

	public static void main(String[] args) {
		User admin = new Administrator();
		String csvFileDirectory = "/home/nishanth/MS/Fall2015/Asynchronous Systems/Project/";		
		String csvFileName = "nameservers.csv";
		admin.setupChord(csvFileDirectory, csvFileName);
		
		User canadaUser = new User();
		canadaUser.joinNetwork();
		
	}
}