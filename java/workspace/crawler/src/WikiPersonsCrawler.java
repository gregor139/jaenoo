import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;
 
 
public class WikiPersonsCrawler {
	private static Integer year;
	private static String pot_link;
	private static String URL;
	private static String nextURL;
	private static Integer invalidURL;
	public static String startpage;
	public static DB db = new DB();
 
	public static void main(String[] args) throws SQLException, IOException {
		db.runSql2("TRUNCATE STG_WIKI_PERSONS;");
		year = 1900;
		while (year<=1905) {
			//System.out.println("0: "+year);
			if (year>0)
		      startpage = "http://de.wikipedia.org/wiki/Kategorie:Geboren_"+year;
			else if (year >=-100 ) startpage = "https://de.wikipedia.org/wiki/Kategorie:Geboren_im_1._Jahrhundert_v._Chr.";
			else if (year >=-200 ) startpage = "https://de.wikipedia.org/wiki/Kategorie:Geboren_im_2._Jahrhundert_v._Chr.";
			else if (year >=-300 ) startpage = "https://de.wikipedia.org/wiki/Kategorie:Geboren_im_3._Jahrhundert_v._Chr.";
			//startpage = startpage.concat(String.valueOf(year));
//			System.out.println("1: "+startpage);
			processYear(year, startpage);
			if (year>=0)
			  year = year+1;
			else year = year+100;
			// System.out.println("Parsing page ".concat(startpage));
		}
	}
 
	public static void processYear(Integer year, String URL) throws SQLException, IOException{
			//get useful information
		nextURL="";
		invalidURL=0;
			try {
			  Document doc = Jsoup.connect(URL).timeout(0).get();
	 
			  //get all links and call the processPerson method
			  //Elements questions = doc.select("a[href]");
			  Elements questions = doc.select("a[href]");
			  for(Element link: questions){
				  pot_link=link.attr("abs:href");
				  //if(link.attr("href").matches("^[^\\d].*") ) {
				  //if(link.toString().matches("^<li><a href=.*") ) {
//				        System.out.println("2: "+link.attr("abs:href"));
				        validatePerson(year, pot_link);
				        //pot_link="/w/index.php?title=Kategorie:Geboren_1875&amp;pagefrom=Byatt%2C+Horace+Archer%0AHorace+Archer+Byatt#mw-pages";
				        if (pot_link.contains("mw-pages") ) nextURL = pot_link;
				  }
		  
			} //catch (org.jsoup.HttpStatusException e) { System.out.println("Page not available: ".concat(URL)); }
			catch (Exception e) { invalidURL=1; }
			//if (nextURL.isEmpty() ) {  System.out.println("nextURL: empty"); }
			//else {
			  //System.out.println("nextURL: "+nextURL);
			  if (invalidURL==0) processYear(year, nextURL);
			//}
	}

	public static void validatePerson(Integer year, String URL) throws SQLException, IOException{
			//get useful information
//			try {
		try {
		    Thread.sleep(1000);                 //1000 milliseconds is one second.
		} catch(InterruptedException ex) {
		    Thread.currentThread().interrupt();
		}
				Document doc = Jsoup.connect(URL).timeout(0).get();
				Elements content = doc.select("table[id=\"Vorlage_Personendaten\"]");
//				System.out.println("3: "+content);
				//Element masthead = content.select("tr").first();
				if (content.hasText()) {
					System.out.println("4: "+URL);
					//System.out.println("5: "+content);
					processPerson(year, content, URL);
				};
				//else System.out.println("not a person: "+URL);

	}
	
	public static void processPerson(Integer year, Elements persondata, String URL) throws SQLException, IOException{
		String sql;
		String[] persStart= new String[30];
		String[] persEnd= new String[30];
		String pers_name = new String();
		String pers_other_names= new String();
		String pers_description= new String();
		String pers_birth_date= new String();
		String pers_birth_place= new String();
		String pers_death_date= new String();
		String pers_death_place= new String();

		
		Integer i=1;
		Integer j=1;
 
			Element fst = persondata.first();
			System.out.println("5.1: "+fst.text());
			
			//get useful information
//			try {
			  Document doc = Jsoup.parse(persondata.toString());
//			  System.out.println("ok 01");
			  if(doc.text().contains("NAME")){
//				  System.out.println("ok 02");
			        for (Element link : persondata) {
			        	Pattern p = Pattern.compile("(\\b[A-Z]+\\b)");
						Matcher m = p.matcher(fst.text());
						
						while (m.find()) {
					      persStart[i]=m.group(1);
//					      list_start.add(m.group(1));
					      persEnd[i-1]=m.group(1);
//					      list_end.add(m.group(1));
					      i++;
						}
			        }
					persEnd[i-1]="$";
//					System.out.println("ok 03");
//					System.out.println("ok 03.2"+persStart.length);
                    for (j=1; j<persStart.length; j++) {
                    	if (persStart[j]==null) break;
                    	//System.out.println("04: "+j);
                    	//System.out.println("05: "+persStart[j]);
                    	//System.out.println("06: "+persEnd[j]);
                    	
                        Pattern p3 = Pattern.compile(Pattern.quote(persStart[j]) + "(.*?)" + persEnd[j]);
                        Matcher m3 = p3.matcher(fst.text());
                        while (m3.find()) {
                           //System.out.println("5.4: "+persStart[j]+": "+m3.group(1));
                           if (persStart[j].equals("NAME")) pers_name=m3.group(1);
                           else if (persStart[j].equals("ALTERNATIVNAMEN")) pers_other_names=m3.group(1);
                           else if (persStart[j].equals("KURZBESCHREIBUNG")) pers_description=m3.group(1);
                           else if (persStart[j].equals("GEBURTSDATUM")) pers_birth_date=m3.group(1);
                           else if (persStart[j].equals("GEBURTSORT")) pers_birth_place=m3.group(1);
                           else if (persStart[j].equals("STERBEDATUM")) pers_death_date=m3.group(1);
                           else if (persStart[j].equals("STERBEORT")) pers_death_place=m3.group(1);
                           else System.out.println("5.5: no match for "+persStart[j]);
                           //System.out.println("5.6: Name: "+pers_name);
	                    }		
                        //System.out.println("ok 1");
                    }
                    //System.out.println("ok 2");
			     }
			        //System.out.println("ok 3");
			 // }
			  //System.out.println("ok 4");
			  
			if (pers_birth_date.contains(year.toString()) || pers_birth_date.contains("Jahrhundert"))  {
				sql = "INSERT INTO  Crawler.STG_WIKI_PERSONS " + "(YEAR, URL, NAME, OTHER_NAMES, DESCRIPTION, BIRTH_DATE, BIRTH_PLACE, DEATH_DATE, DEATH_PLACE) VALUES " + "(?, ?, ?, ?, ?, ?, ?, ?, ?);";
				//System.out.println("9: "+sql);
				
				PreparedStatement stmt = db.conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
				stmt.setString(1, String.valueOf(year));
				stmt.setString(2, URL);
				stmt.setString(3, pers_name);
				stmt.setString(4, pers_other_names);
				
				stmt.setString(5, pers_description);
				stmt.setString(6, pers_birth_date);
				stmt.setString(7, pers_birth_place);
				stmt.setString(8, pers_death_date);
				stmt.setString(9, pers_death_place);
				
				//System.out.println("9: "+stmt);
				stmt.execute();
			}

}	
	
    private static void print(String msg, Object... args) {
        System.out.println(String.format(msg, args));
    }

}