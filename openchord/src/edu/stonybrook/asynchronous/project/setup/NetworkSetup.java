package edu.stonybrook.asynchronous.project.setup;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import de.uniba.wiai.lspi.chord.data.URL;
import de.uniba.wiai.lspi.chord.service.Chord;
import de.uniba.wiai.lspi.chord.service.PropertiesLoader;
import de.uniba.wiai.lspi.chord.service.ServiceException;
import de.uniba.wiai.lspi.chord.service.impl.ChordImpl;
import edu.stonybrook.asynchronous.project.parser.impl.CountryExtractor;
import edu.stonybrook.asynchronous.project.parser.templates.Extractor;
import edu.stonybrook.asynchronous.project.utils.NetworkUtils;

public class NetworkSetup {	
	
	private static Map<String,Integer> countryToPortMap;
	private static final String PROTOCOL = URL.KNOWN_PROTOCOLS.get(URL.LOCAL_PROTOCOL);	
	private static final String COLON = ":";
	private static final String HOSTNAME = COLON + "//localhost";
	private static String bootstrapCountry = "US";
	private static URL bootstrapURL;
	private static boolean networkEstablished = false;

	public static void setBootStrapCountry(String country){
		NetworkSetup.bootstrapCountry = country;
	}
	private static void countryToPortMapper(Set<String> countries) throws IOException{
		countryToPortMap = new HashMap<>();
		int portNumber = 8080;
		for(String country : countries){
			int startPortNumber = portNumber;
			while(!NetworkUtils.available(portNumber)){
				if((portNumber-startPortNumber)>countries.size()){
					throw new IOException("Ports are not available");
				}
				portNumber++;				
			}
			countryToPortMap.put(country, portNumber);
			portNumber++;
		}
	}
	
	private static Chord createBootstrapNode(int port){
		URL localURL = null;
		try {
			//localURL = new URL(PROTOCOL + ":// localhost:8080/ " ) ;
			localURL = new URL(PROTOCOL + HOSTNAME + COLON +port+"/");			
		} catch ( MalformedURLException e ) {
			throw new RuntimeException ( e ) ;
		}
		setBootstrapURL(localURL);
		Chord chord = new ChordImpl() ;
		try {
			chord.create(localURL) ;
		} catch ( ServiceException e ) {
			throw new RuntimeException ( " Could not create DHT ! " , e ) ;
		}
		return chord;
		
	}
	private static Chord joinNetwork(int port) throws ServiceException{
		URL localURL = null;
		try{
			localURL = new URL(PROTOCOL + HOSTNAME + COLON + port+"/");
		}catch(MalformedURLException e){
			throw new RuntimeException(e);
		}					
		Chord chord = new ChordImpl();
		chord.join(localURL,bootstrapURL);
		return chord;
		
	}
	private static void setBootstrapURL(URL bootStrapURL){
		NetworkSetup.bootstrapURL = bootStrapURL;
	}
	public static Chord joinNetwork(String country) throws ServiceException{
		if(!countryToPortMap.containsKey(country)){
			System.out.println("Invalid country \"" + country 
					+ "\" or it is already in the network");
			return null;
		}
		return joinNetwork(countryToPortMap.get(country));
	}
	public static Chord createNetwork(String csvFileDirectory, String csvFileName)
			throws IOException, ServiceException{		
		
		PropertiesLoader.loadPropertyFile();
		if (countryToPortMap == null){
			Extractor<Set<String>> countryExtractor = 
					new CountryExtractor(csvFileDirectory,csvFileName);
			countryToPortMapper(countryExtractor.extract());
		}
		
		if (!countryToPortMap.containsKey(bootstrapCountry)){
			throw new IllegalStateException("Bootstrapping from an unknown country");
		}				
		Chord chord = createBootstrapNode(countryToPortMap.get(bootstrapCountry));
		countryToPortMap.remove(bootstrapCountry);		
			
		setNetworkEstablished(true);		
		System.out.println("Base network created");	
		return chord;
	}
	public static boolean isNetworkEstablished() {
		return networkEstablished;
	}
	private static void setNetworkEstablished(boolean networkEstablished) {
		NetworkSetup.networkEstablished = networkEstablished;
	}
}
