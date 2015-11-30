package edu.stonybrook.asynchronous.project.parser;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.Charset;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

public class ParseCSV {
	
	public static void removeEmptyRecords(File csvFile,File outputFile) throws IOException{		
		CSVParser parser;
		BufferedWriter bw = null;
		try {
			parser = CSVParser.parse(csvFile,Charset.forName("ASCII"), CSVFormat.RFC4180);
			bw = new BufferedWriter(new FileWriter(outputFile));				
			for (CSVRecord csvRecord : parser) {				
				if (csvRecord.get(0).trim().length() == 0 || 
						csvRecord.get(1).trim().length() == 0 ||
						csvRecord.get(2).trim().length() == 0)
					continue;
				StringBuffer sb = new StringBuffer();
				for (int i=0;i<3;i++){
					sb.append(csvRecord.get(i)+",");
				}						
				sb.deleteCharAt(sb.lastIndexOf(","));
				bw.write(sb.toString());
				bw.newLine(); 
			}
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			try{
				bw.close();
			}catch(IOException e){
				System.out.println("Error while closing");
				throw e;
			}
		}
	}
	public static void main(String[] args) {
		String directory = "/home/nishanth/MS/Fall2015/Asynchronous Systems/Project/";
		String inputFilePath = directory + "nameservers.csv";		
		String outputFilePath = directory + "nameservers_clean.csv";
		try {
			ParseCSV.removeEmptyRecords(new File(inputFilePath),new File(outputFilePath));
		} catch (IOException e) {			
			e.printStackTrace();
		}
	}
}
