package edu.stonybrook.asynchronous.project.demo;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import edu.stonybrook.asynchronous.project.data.StringKey;
import edu.stonybrook.asynchronous.project.userinteraction.Administrator;
import edu.stonybrook.asynchronous.project.userinteraction.User;
import java.util.concurrent.ThreadLocalRandom;

public class PrepareNetwork {
	
	private static User admin;
	private static List<User> users;
	
	private static String adminCountry = "US";
	private static Map<String, Map<String, List<String>>> countryToDNSIPMap;
	public static void setAdminCountry(String adminCountry) {
		PrepareNetwork.adminCountry = adminCountry;
	}
	
	private static void prepareUsers(Set<String> countries){
		users = new ArrayList<>();		
		for (String country : countries){
			if(country.equalsIgnoreCase(adminCountry)){
				admin = new Administrator();
				admin.setCountry(country);				
				continue;
			}
			User user = new User();
			user.setCountry(country);
			users.add(user);			
		}
	}
	
	private static void usersSetup(String csvFileDirectory, String csvFileName){
		admin.setupChord(csvFileDirectory, csvFileName);			
		for(User user : users){					
			user.joinNetwork();
		}
		System.out.println("Users finished joining the network");
	}
	
	private static boolean insertDataAdmin(String country){
		if(admin.getCountry().equalsIgnoreCase(country)){
			Map<String,List<String>> dnsToIPs = countryToDNSIPMap.get(country);
			for (String dns:dnsToIPs.keySet()){
				ArrayList<String> ips = (ArrayList<String>) dnsToIPs.get(dns);
				admin.insertData(new StringKey(dns), ips);				
			}
			return true;
		}
		return false;
	}
	public static void insertData(String country){
		for (User user:users){			
			if (user.getCountry().equalsIgnoreCase(country)){
				continue;
			}
			Map<String,List<String>> dnsToIPs = countryToDNSIPMap.get(country);
			for (String dns:dnsToIPs.keySet()){
				ArrayList<String> ips = (ArrayList<String>) dnsToIPs.get(dns);
				user.insertData(new StringKey(dns), ips);
			}
		}
	}
	
	public static void insertData(){
		for(String country : countryToDNSIPMap.keySet()){
			System.out.println("Inserting data for : " + country);
			if (!insertDataAdmin(country)){
				insertData(country);
			}
		}
		System.out.println("Finished inserting data");
	}
	
	public static void prepareNetwork(String csvFileDirectory, String csvFileName){
		countryToDNSIPMap = PrepareData.prepareData(csvFileDirectory, csvFileName);
		prepareUsers(countryToDNSIPMap.keySet());		
		usersSetup(csvFileDirectory,csvFileName);		
		insertData();
		
	}
	public static void main(String[] args) throws IOException {
		String csvFileDirectory = "/home/nishanth/MS/Fall2015/Asynchronous Systems/Project/";		
		String csvFileName = "nameservers.csv";
		long startTime = System.currentTimeMillis();
		prepareNetwork(csvFileDirectory, csvFileName);
		long elapsedTime = System.currentTimeMillis() - startTime;		
		System.out.println("NetworkSetup Finished");
		System.out.println("Elapsed time for setting up the network : " + elapsedTime);
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File("results.txt")));
		bw.write("Elapsed Time for setting up the network (in ms): " + elapsedTime);
		bw.newLine();
		for (int i = 0 ; i<10;i++){
			int n = ThreadLocalRandom.current().nextInt(0, users.size() - 1);
			System.out.println("n : "  + n);
			User user = users.get(n);
			System.out.println("Chosen User Country: " + user.getCountry());
			bw.write("Chosen User Country: " + user.getCountry());
			long retrieveStart = System.currentTimeMillis();
			System.out.println(user.retrieve(new StringKey("87-204-55-61.ilkus.net.")));
			bw.write("    Retrieve time : " + (System.currentTimeMillis()-retrieveStart));
			bw.newLine();
		}		
		bw.close();
	}
}
