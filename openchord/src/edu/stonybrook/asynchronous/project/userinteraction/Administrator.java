package edu.stonybrook.asynchronous.project.userinteraction;

import java.io.IOException;

import de.uniba.wiai.lspi.chord.service.Chord;
import de.uniba.wiai.lspi.chord.service.ServiceException;
import edu.stonybrook.asynchronous.project.setup.NetworkSetup;

public class Administrator extends User{
			
	@Override
	public void setupChord(String csvFileDirectory, String csvFileName){
		NetworkSetup.setBootStrapCountry(this.country);		
		try {
			this.chord = NetworkSetup.createNetwork(csvFileDirectory, csvFileName);
		} catch (IOException | ServiceException e) {
			System.out.println("Error while setting up network");
			e.printStackTrace();
		}	
	}
}
