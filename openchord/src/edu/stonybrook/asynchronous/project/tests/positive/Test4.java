package edu.stonybrook.asynchronous.project.tests.positive;

import edu.stonybrook.asynchronous.project.data.StringKey;
import edu.stonybrook.asynchronous.project.userinteraction.Administrator;
import edu.stonybrook.asynchronous.project.userinteraction.User;

public class Test4 {
	public static void main(String[] args) {
		User admin = new Administrator();
		String csvFileDirectory = "";//"/home/nishanth/MS/Fall2015/Asynchronous Systems/Project/";		
		String csvFileName = "nameservers.csv";
		admin.setupChord(csvFileDirectory, csvFileName);
		
		/*User usUser = new User();
		usUser.setCountry("US");
		usUser.joinNetwork();
		usUser.insertData(new StringKey("US"),"Hello From US!");*/
		
		User canadaUser = new User();
		canadaUser.setCountry("CA");
		canadaUser.joinNetwork();
		User britainUser = new User();
		britainUser.setCountry("GB");
		britainUser.joinNetwork();

		admin.insertData(new StringKey("US"),"Hello From US!");
		canadaUser.insertData(new StringKey("CA"),"Hello From CA!");
		
		
		System.out.println(admin.retrieve(new StringKey("US")));
	}
}
