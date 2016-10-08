import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
 
 
public class Crawler {
	public static Integer year;
	public static String startpage = "http://de.wikipedia.org/wiki/Kategorie:Geboren_";
	public static String firstname = "Albert";
	public static String lastname = "Borer";
	public static DB db = new DB();
 
	public static void main(String[] args) throws SQLException, IOException {
		db.runSql2("TRUNCATE STG_WIKI_PERSONS;");
		year = 1960;
		while (year<2016) {
			startpage = "http://de.wikipedia.org/wiki/Kategorie:Geboren_";
			startpage = startpage.concat(String.valueOf(year));
			processYear(year, startpage);
			year = year+1;
			// System.out.println("Parsing page ".concat(startpage));
		}
	}
 
	public static void processYear(Integer year, String URL) throws SQLException, IOException{
		//check if the given URL is already in database
		String sql = "select * from STG_WIKI_PERSONS where URL = '"+URL+"'";
		ResultSet rs = db.runSql(sql);
		if(rs.next()){
 
		}else{
			//store the URL to database to avoid parsing again
			sql = "INSERT INTO  Crawler.STG_WIKI_PERSONS " + "(YEAR, URL) VALUES " + "(?, ?);";
			PreparedStatement stmt = db.conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			stmt.setString(1, String.valueOf(year));
			stmt.setString(2, URL);
			stmt.execute();
 if (URL != startpage) {
	 System.out.println(URL+' '+startpage);
 }
			//get useful information
			try {
			  Document doc = Jsoup.connect(startpage).get();
			  if(doc.text().contains(firstname)){
					//System.out.println(URL);
			  }
	 
			  //get all links and recursively call the processPage method
			  Elements questions = doc.select("a[href]");
			  for(Element link: questions){
					if(link.attr("href").contains(firstname))
						processYear(year, link.attr("abs:href"));
			  }			  
			} catch (org.jsoup.HttpStatusException e) { System.out.println("Page not available: ".concat(URL)); }

		}
	}
}