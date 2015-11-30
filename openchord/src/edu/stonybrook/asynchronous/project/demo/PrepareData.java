package edu.stonybrook.asynchronous.project.demo;

import java.util.List;
import java.util.Map;

import edu.stonybrook.asynchronous.project.parser.impl.CountryToDNSIP;

public class PrepareData {

	public static Map<String, Map<String, List<String>>> prepareData
										(String csvFileDirectory, String csvFileName){

		CountryToDNSIP countryToDNSIPmapper = new CountryToDNSIP(csvFileDirectory, csvFileName);
		Map<String, Map<String, List<String>>> countryToDNSIPmap = countryToDNSIPmapper.extract();
		return countryToDNSIPmap;
	}
	
}
