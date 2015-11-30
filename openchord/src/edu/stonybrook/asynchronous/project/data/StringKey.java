package edu.stonybrook.asynchronous.project.data;

import de.uniba.wiai.lspi.chord.service.Key;

public class StringKey implements Key{

	private String data;
	
	public StringKey ( String theString ) {
		this.data = theString ;
	}
	
	public byte [] getBytes() {
		return this.data.getBytes();
	}
	
	public int hashCode() {
		return this.data .hashCode () ;
	}
	
	public boolean equals(Object o) {
		if ( o instanceof StringKey ) {
			return (( StringKey ) o ).data.equals(this.data ) ;
		}
		return false ;
	}	

}
