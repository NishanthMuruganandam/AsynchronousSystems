package edu.stonybrook.asynchronous.project.parser.impl;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import edu.stonybrook.asynchronous.project.parser.ParseCSV;
import edu.stonybrook.asynchronous.project.parser.templates.Extractor;

public final class CountryExtractor implements Extractor<Set<String>> {

	
	private static final int COUNTRY_COLUMN = 2;
	private File cleanCSVFile;
	
	
	private Set<String> countries = null;
	public CountryExtractor(String csvFileDirectory,
			String csvFileName) throws IOException {
		cleanCSVFile = new File(csvFileDirectory+"clean_"+csvFileName);
		ParseCSV.removeEmptyRecords(new File(csvFileDirectory+csvFileName), 
				cleanCSVFile);
	}
	@Override
	public Set<String> extract() {
		if (countries != null){
			//Return the cached copy
			return countries;
		}
		CSVParser parser;
		try {
			countries = new HashSet<>();
			parser = CSVParser.parse(cleanCSVFile,Charset.forName("ASCII"), CSVFormat.RFC4180);
			for(CSVRecord csvRecord:parser){
				countries.add(csvRecord.get(COUNTRY_COLUMN));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return countries;
	}	
}
