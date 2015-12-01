package edu.stonybrook.asynchronous.project.tests.positive;

import edu.stonybrook.asynchronous.project.data.StringKey;
import edu.stonybrook.asynchronous.project.userinteraction.Administrator;
import edu.stonybrook.asynchronous.project.userinteraction.User;

public class Test3 {
	public static void main(String[] args) {
		User admin = new Administrator();
		String csvFileDirectory = "/home/nishanth/MS/Fall2015/Asynchronous Systems/Project/";		
		String csvFileName = "nameservers.csv";
		admin.setupChord(csvFileDirectory, csvFileName);
		
		admin.insertData(new StringKey("US"),"Hello From US!");
		System.out.println("Data inserted");
		
		User canadaUser = new User();
		canadaUser.setCountry("CA");
		canadaUser.joinNetwork();
		canadaUser.insertData(new StringKey("CA"),"Hello From CA!");
	}
}
