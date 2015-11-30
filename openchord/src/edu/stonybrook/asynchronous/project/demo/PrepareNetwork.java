package edu.stonybrook.asynchronous.project.demo;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import edu.stonybrook.asynchronous.project.data.StringKey;
import edu.stonybrook.asynchronous.project.userinteraction.Administrator;
import edu.stonybrook.asynchronous.project.userinteraction.User;

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
	public static void main(String[] args) {
		String csvFileDirectory = "/home/nishanth/MS/Fall2015/Asynchronous Systems/Project/";		
		String csvFileName = "nameservers.csv";
		prepareNetwork(csvFileDirectory, csvFileName);
		System.out.println("NetworkSetup Finished");
		User user = users.get(23);
		System.out.println("Chosen User Country: " + user.getCountry());
		System.out.println(user.retrieve(new StringKey("87-204-55-61.ilkus.net.")));
	}
}
