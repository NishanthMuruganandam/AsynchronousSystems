package edu.stonybrook.asynchronous.project.userinteraction;

import java.io.Serializable;
import java.util.Set;

import de.uniba.wiai.lspi.chord.service.Chord;
import de.uniba.wiai.lspi.chord.service.ServiceException;
import edu.stonybrook.asynchronous.project.data.StringKey;
import edu.stonybrook.asynchronous.project.setup.NetworkSetup;
import edu.stonybrook.asynchronous.project.user.templates.UserInsert;
import edu.stonybrook.asynchronous.project.user.templates.UserJoin;
import edu.stonybrook.asynchronous.project.user.templates.UserLogin;
import edu.stonybrook.asynchronous.project.user.templates.UserRetrieve;

public class User implements UserLogin,UserJoin,UserInsert,UserRetrieve{
	protected String country = "US";
	protected Chord chord = null;
	
	@Override
	public void setCountry(String country) throws IllegalArgumentException {	
		this.country = country;				
	}
	
	public String getCountry() {
		return country;
	}

	@Override
	public void insertData(StringKey key, Serializable data){
		while(!NetworkSetup.isNetworkEstablished()){
			System.out.println("Waiting for network to be up");
		}
		try{
			chord.insert(key,data);		
		}catch(ServiceException e){
			throw new RuntimeException("Error while inserting data ! ", e);
		}
	}
	public void setupChord(String csvFileDirectory, String csvFileName){
		throw new IllegalStateException("No privilege to create network. Sorry bro!");		
	}

	@Override
	public void joinNetwork() {
		try {
			this.chord = NetworkSetup.joinNetwork(country);
			//System.out.println(country + " joined");
		} catch (ServiceException e) {
			e.printStackTrace();
		}		
	}

	@Override
	public Set<Serializable> retrieve(StringKey key) {
		try {			
			return this.chord.retrieve(key);
		} catch (ServiceException e) {			
			e.printStackTrace();
		}
		return null;
	}
	public String toString(){
		return this.country + " NetworkSetup: " +
			 new String(this.chord != null?Boolean.toString(true):Boolean.toString(false));
	}
}
