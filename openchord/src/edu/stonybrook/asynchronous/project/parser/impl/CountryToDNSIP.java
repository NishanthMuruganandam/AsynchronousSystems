package edu.stonybrook.asynchronous.project.parser.impl;

import java.util.Set;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import edu.stonybrook.asynchronous.project.parser.ParseCSV;
import edu.stonybrook.asynchronous.project.parser.templates.Extractor;

public class CountryToDNSIP implements Extractor<Map<String,Map<String,List<String>>>>{

	private String csvFileDirectory;
	private String csvFileName;
	private static final int COUNTRY_COLUMN = 2;
	private static final int DNS_COLUMN = 1;
	private static final int IP_COLUMN = 0;
	public CountryToDNSIP(String csvFileDirectory, String csvFileName){
		this.csvFileDirectory = csvFileDirectory;
		this.csvFileName = csvFileName;
	}
	private File cleanCSVFile(){
		File file = new File(csvFileDirectory+"clean_"+csvFileName);
		if (file.exists()){
			return file;
		}
		try {
			ParseCSV.removeEmptyRecords(new File(csvFileDirectory+csvFileName), 
					file);
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
		return file;
	}
	@Override
	public Map<String, Map<String, List<String>>> extract() {
		try {
			Extractor<Set<String>> extractor =  new CountryExtractor(csvFileDirectory, csvFileName);
			Set<String> countries = extractor.extract();
			Map<String,Map<String, List<String>>> resultMap = new HashMap<>();
			for (String country : countries){
				CSVParser parser;
				Map<String,List<String>> dnsToIP = new HashMap<>();
				try {					
					parser = CSVParser.parse(cleanCSVFile(),Charset.forName("ASCII"), CSVFormat.RFC4180);
					for(CSVRecord csvRecord:parser){
						if(csvRecord.get(COUNTRY_COLUMN).equalsIgnoreCase(country)){
							String dns = csvRecord.get(DNS_COLUMN);
							List<String> list = null;
							if (!dnsToIP.containsKey(dns)){
								list = new ArrayList<>();															
							}else{
								list = dnsToIP.get(dns);							
							}
							list.add(csvRecord.get(IP_COLUMN));
							dnsToIP.put(dns,list);
						}
					}					
				} catch (IOException e) {
					e.printStackTrace();
				}
				resultMap.put(country,dnsToIP);
			}
			return resultMap;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

	
}
