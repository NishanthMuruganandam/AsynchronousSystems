package com.dns.tests;

import java.net.MalformedURLException;

import de.uniba.wiai.lspi.chord.data.URL;
import de.uniba.wiai.lspi.chord.service.Chord;
import de.uniba.wiai.lspi.chord.service.PropertiesLoader;
import de.uniba.wiai.lspi.chord.service.ServiceException;
import de.uniba.wiai.lspi.chord.service.impl.ChordImpl;
import edu.stonybrook.asynchronous.project.data.StringKey;

public class OpenDHTExample {
	public static void main(String[] args) throws ServiceException, MalformedURLException {
		
	PropertiesLoader.loadPropertyFile () ;
	
	String protocol = URL . KNOWN_PROTOCOLS . get ( URL . LOCAL_PROTOCOL ) ;
	URL localURL = null ;
	try {
	localURL = new URL ( protocol + ":// localhost:8080/ " ) ;
	} catch ( MalformedURLException e ) {
	throw new RuntimeException ( e ) ;
	}
	Chord chord = new ChordImpl() ;
	try {
	chord . create ( localURL ) ;
	} catch ( ServiceException e ) {
	throw new RuntimeException ( " Could not create DHT ! " , e ) ;
	}
	
	/*URL bootstrapURL = new URL ( protocol + ":// localhost:8080/ " ) ;
	try{
		localURL = new URL(protocol + ":// localhost:8181/ " ) ;
	}catch(MalformedURLException e){
		throw new RuntimeException(e);
	}					
	System.out.println(localURL);
	System.out.println(bootstrapURL);
	new ChordImpl().join(localURL,bootstrapURL);*/	
	System.out.println("Chord created");
	
	String data = "Hello World";
	StringKey key = new StringKey(data);
	try{
		chord.insert(key,data);
		
		//System.out.println(chord.retrieve(key));
	}catch(ServiceException e){
		throw new RuntimeException("Error while inserting data ! ", e);
	}
	System.out.println(chord.retrieve(key));
}
}
