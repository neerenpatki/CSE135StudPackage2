<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>
<%@include file="welcome.jsp" %>
<div align="center"> <h2>Sales Analytics</h2></div>
<%
long startTime = System.nanoTime();
if(session.getAttribute("name")!=null)
{
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
	if (session.getAttribute("nextProds") == null) {
		session.setAttribute("nextProds", 0);
	}
	if (session.getAttribute("nextRows") == null) {
		session.setAttribute("nextRows", 0);
	}
	int nextProds = (Integer)session.getAttribute("nextProds");
	int nextRows = (Integer)session.getAttribute("nextRows");
	
	//out.println("Next rows: " + nextRows + " Next prods: " + nextProds);
	
%>


		<%
		Connection conn=null;
		Statement stmt, stmt2, stmt3, stmt4, stmt5, stmt6, stmt7;
		String SQL=null;
		String prodSQL=null, prodSpentSQL = "";
		String customerSpentSQL = "", stateSpentSQL = "";
		try
		{
			try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
			String url="jdbc:postgresql://127.0.0.1:5432/P1";
			String user="postgres";
			String password="880210";
			conn =DriverManager.getConnection(url, user, password);
			stmt =conn.createStatement();
			stmt2 =conn.createStatement();
			stmt3 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			stmt4 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			stmt5 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			stmt6 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			stmt7 = conn.createStatement();
			ResultSet rs=null;
			ResultSet prodRS=null;
			ResultSet spentRS = null;
			ResultSet stateSpentRS = null;
			ResultSet customerSpentRS = null;
			ResultSet prodSpentRS = null;
			ResultSet customersRS = null;
			rs=stmt.executeQuery("SELECT * FROM categories order by id asc;");
			String c_name=null;
			int c_id=0;
		%>

<div style="width:98%; position:absolute; top:80px; left:10px; right:10px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<%
		// Declare array of states
		String[] states = { "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
			"Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana",
			"Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
			"Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
			"New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma",
			"Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
			"Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", 
			"Wyoming" };
		String action = request.getParameter("runQuery"); // Store action when query is ran
		String rowsTitle = (String)session.getAttribute("rowsTitle");
		String stateSel = "All States";
		String category = "All Categories";
		String ageSel = "All Ages";
		String stateFilter = "TRUE", lowerAgeFilter = "TRUE", upperAgeFilter = "TRUE", categoryFilter = "TRUE";
		String nextProdsStr = request.getParameter("Next 10 Products");
		String nextRowsStr = request.getParameter("Next 20 Rows");
		ArrayList<String> prodNames = new ArrayList<String>();

		//TODO DELETE THESE ONLY FOR RESETTING
		session.setAttribute("nextProds", 0);
		session.setAttribute("nextRows", 0);
		//session.setAttribute("stateSel", "All States");
		//session.setAttribute("ageSel", "All Ages");
		
		// If the user clicked run query
		if (action != null && action.equals("Run Query")) {
			rowsTitle = request.getParameter("rowTitle");
			session.setAttribute("rowsTitle", rowsTitle);
			//session.setAttribute("stateFilter", stateFilter);
			session.setAttribute("ageSel", request.getParameter("age"));
			
		} else if(session.getAttribute("rowsTitle") != null && session.getAttribute("rowsTitle").equals("States")){
			rowsTitle = "States";
		}
		else {
			rowsTitle = "Customers"; // Set default to be Customers
			session.setAttribute("rowsTitle", rowsTitle);
		}
		
		stateSel = request.getParameter("state");
		if (stateSel == null) {
			stateSel = "All States"; // Set default to be All States
		} else {
			stateFilter = "u.state = '" + stateSel + "'";
			//session.setAttribute("stateFilter", stateFilter);
		}
		
		if (stateSel.equals("All States")) stateFilter = "TRUE";
		category = request.getParameter("category"); // Get the selected category
		if (category == null) {
			category = "All Categories"; // Set the default to be All Categories
		} else {
			categoryFilter = "c.name = '" + category + "'";
			session.setAttribute("categoryFilter", categoryFilter);
		}

		if (category.equals("All Categories")) categoryFilter = "TRUE";

		if(session.getAttribute("ageSel") == null){
			ageSel = request.getParameter("age"); // Get the selected age range
		} else if(session.getAttribute("ageSel").equals("All Ages")){
			ageSel = "All Ages";
		} else{
			ageSel = (String)session.getAttribute("ageSel");
		}
		int upperAge = 0; 
		int lowerAge = 0;
		String upperStr = "";
		String lowerStr = "";
		int dash = -1;
		if (ageSel == null) {
			ageSel = "All Ages"; // Set the default to be All Ages
		}

		if (!ageSel.equals("All Ages")) {
			dash = ageSel.indexOf("-");
			lowerStr = ageSel.substring(0, dash);
			upperStr = ageSel.substring(dash+1, ageSel.length());
			lowerAge = Integer.parseInt(lowerStr);
			
			//if not "65-"
			if(!upperStr.equals("")){
				upperAge = Integer.parseInt(upperStr);
				upperAgeFilter = "u.age < " + upperAge;
			}
			lowerAgeFilter = "u.age >= " + lowerAge;	
		}

		// Update count for number of times next buttons have been clicked
		if (nextProdsStr != null && nextProdsStr.equals("Next 10 Products")) {
			nextProds++;
			session.setAttribute("nextProds", nextProds);
			session.setAttribute("nextRows", nextRows);
			session.setAttribute("stateSel", stateSel);
			session.setAttribute("stateFilter", stateFilter);
			session.setAttribute("ageSel", ageSel);
		} else if (nextRowsStr != null && (nextRowsStr.equals("Next 20 Customers") 
				|| nextRowsStr.equals("Next 20 States"))) {
			nextRows++;
			session.setAttribute("nextRows", nextRows);
			session.setAttribute("nextProds", nextProds);
			session.setAttribute("rowsTitle", rowsTitle);
			session.setAttribute("stateSel", stateSel);
			session.setAttribute("stateFilter", stateFilter);
			session.setAttribute("ageSel", ageSel);
		}

	   String c_id_str=null,key=null;
	   int c_id_int=-1;
	   try {c_id_str=request.getParameter("cid"); c_id_int=Integer.parseInt(c_id_str);}catch(Exception e){c_id_str=null;c_id_int=-1;}
	   try {key=request.getParameter("key");}catch(Exception e){key=null;}

		// Check for default "Customers" option selected and limit to 20 customers
		if(c_id_int==-1 && key==null)
		{
			// If States and All Ages are selected
			if (rowsTitle.equals("States") && ageSel.equals("All Ages")) {
				SQL = "SELECT state FROM users ORDER BY state asc LIMIT 20";
			}
			// If States and some specified range of ages are selected
			else if (rowsTitle.equals("States") && !ageSel.equals("All Ages")) {
				SQL = "SELECT state FROM users WHERE age >= "+lowerAge+" AND age < "+upperAge+" ORDER BY name asc LIMIT 20";
			}
			// Customers are selected
			else {
				// If state selected is All States
				//if(stateSel != null && stateSel.equals("All States")) {
					SQL="SELECT id, name FROM users ORDER BY name asc LIMIT 20";
				//} else { // There was some specified state
				//	SQL="SELECT id, name FROM users WHERE state = '"+stateSel+ 
				//	"' ORDER BY name asc LIMIT 20";
				//}
			}
		}
		else
		{
			if(c_id_int==-1 && key!=null)
			{
				SQL="SELECT id,name,SKU, category, price FROM products where name LIKE '"+key+"%' order by id asc;";
			}
			else if(c_id_int!=-1 && key!=null)
			{
				SQL="SELECT id,name,SKU, category, price FROM products where cid="+c_id_int+" and name LIKE '"+key+"%' order by id asc;";
			}
			else if(c_id_int!=-1 && key==null)
			{
				SQL="SELECT id,name,SKU, category, price FROM products where cid="+c_id_int+" order by id asc;";
			}
		}
%>
<% if(nextProds == 0 && nextRows == 0){%>
	<form action="sales_analytics.jsp">
		<input type="hidden">&nbsp;</>
		Rows:
		<SELECT name="rowTitle">
			<% if(rowsTitle.equals("States")){%>
				<OPTION value="Customers">Customers</OPTION>
				<OPTION value="States" selected>States</OPTION>
			<%} else{%>
				<OPTION value="Customers" selected>Customers</OPTION>
				<OPTION value="States">States</OPTION>
			<%}%>
		</SELECT>
		State:
		<SELECT NAME="state">
		   <OPTION value-="All States">All States</OPTION>
		   <%for (int i = 0; i < states.length; i++) {%>
		   <OPTION value="<%=states[i]%>"><%=states[i]%></OPTION>
		   <%}%>
		</SELECT>
		Category:
		<SELECT name="category">
			<OPTION value="All Categories">All Categories</OPTION>
			<%
			while (rs.next()) { %>
				<OPTION value="<%=rs.getString(2)%>"><%=rs.getString(2)%></OPTION>
			<%
			}
			%>

		</SELECT>
		Age:
		<SELECT name="age">
			<% if(ageSel.equals("All Ages")){%>
				<OPTION value="All Ages" selected>All Ages</OPTION>
				<OPTION value="12-18">12-18</OPTION>
				<OPTION value="18-45">18-45</OPTION>
				<OPTION value="45-65">45-65</OPTION>
				<OPTION value="65-">65-</OPTION>
			<%} else if(ageSel.equals("12-18")){%>
				<OPTION value="All Ages">All Ages</OPTION>
				<OPTION value="12-18" selected>12-18</OPTION>
				<OPTION value="18-45">18-45</OPTION>
				<OPTION value="45-65">45-65</OPTION>
				<OPTION value="65-">65-</OPTION>
			<%} else if(ageSel.equals("18-45")){%>
				<OPTION value="All Ages">All Ages</OPTION>
				<OPTION value="12-18">12-18</OPTION>
				<OPTION value="18-45" selected>18-45</OPTION>
				<OPTION value="45-65">45-65</OPTION>
				<OPTION value="65-">65-</OPTION>
			<%} else if(ageSel.equals("45-65")){%>
				<OPTION value="All Ages">All Ages</OPTION>
				<OPTION value="12-18">12-18</OPTION>
				<OPTION value="18-45">18-45</OPTION>
				<OPTION value="45-65" selected>45-65</OPTION>
				<OPTION value="65-">65-</OPTION>
			<%} else if(ageSel.equals("65-")){%>
				<OPTION value="All Ages">All Ages</OPTION>
				<OPTION value="12-18">12-18</OPTION>
				<OPTION value="18-45">18-45</OPTION>
				<OPTION value="45-65">45-65</OPTION>
				<OPTION value="65-" selected>65-</OPTION>
				<%}%>
		</SELECT>
		<input type="submit" name="runQuery" value="Run Query"/>
	</form>

	<br>
<%}%>
<%		
		// If category is All Categories
		if(category != null && category.equals("All Categories")){
			prodSQL="SELECT id, name FROM products ORDER BY name LIMIT 10 OFFSET "+(nextProds*10);
			prodSpentSQL = "SELECT p.id, p.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN" + " categories c ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) " + 
			"LEFT OUTER JOIN users u ON (s.uid = u.id) WHERE "+stateFilter+" AND "+categoryFilter+" AND "
			+lowerAgeFilter+" AND "+upperAgeFilter+" GROUP BY p.id ORDER BY p.name";
			category = "c.name";
		} else { // Category is specified
			category = "'"+category+"'";
			prodSQL="SELECT p.id, p.name FROM products p, categories c WHERE c.name= "+category+" AND c.id=p.cid ORDER BY p.name LIMIT 10";
			prodSpentSQL = "SELECT p.id, p.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN" + " categories c ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) " + 
			"LEFT OUTER JOIN users u ON (s.uid = u.id) WHERE "+stateFilter+" AND "+categoryFilter+" AND "
			+lowerAgeFilter+" AND "+upperAgeFilter+" GROUP BY p.id ORDER BY p.name";
		}
		prodRS=stmt2.executeQuery(prodSQL);
		prodSpentRS = stmt6.executeQuery(prodSpentSQL);
		rs=stmt.executeQuery(SQL);

		out.println("<table width=\"100%\"  border=\"1px\" align=\"center\">");
		out.println("<tr align=\"center\"><td width=\"20%\"><B>"+rowsTitle+"</B></td>");
		String prodName=""; // Store the product name
		//int[] prodID = new int[10]; // Store the first 10 id's of the products
		int prodIndex = 0;
		// Go through the first 10 products and get id and name
		while (prodRS.next()) {
		    int id = prodRS.getInt(1);
		    prodName = prodRS.getString(2);
		    prodNames.add("'"+prodName+"'");
		    String stateTemp = stateSel;
		    // If state is not specified
		    if (stateTemp.equals("All States")) {
		    	stateTemp = "u.state";
			} else { // State is specified
				stateTemp = "'" + stateSel + "'";
			}
			// Truncate the product name to only 10 characters
		    String truncProdName = prodName.substring(0, Math.min(prodName.length(), 10));
		    float prodSpentTot = 0;
		    while (prodSpentRS.next()) {
		    	if (prodSpentRS.getString(2).equals(prodName)) {
		    		prodSpentTot = prodSpentRS.getFloat(3);
		    		break;
		    	}
			}
			prodSpentRS.beforeFirst();
			out.println("<td width=\"8%\"><B>"+truncProdName+"<br/>($"+prodSpentTot+")</B></td>");
			//prodID[prodIndex] = id; // Store the product id
			//prodIndex++; // Increment the index for later use
		}
		int id=0; // Store the id
		int uID = 0; // Store the user id
		String name="", SKU="", tempState = "";
		float price=0;
		int i = nextRows*20;
		int temp = i; // Store index temporarily
		float stateSpentTot = 0; // Total amount spent by the state
		float customerSpentTot = 0; // Total amount spent by the customer
		String spentSQL = "";

		if (rowsTitle.equals("States")) {
			stateSpentSQL = "SELECT u.state, COALESCE(SUM(s.quantity*s.price),0) FROM "
			+ "users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON "
			+ "(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE "+stateFilter+
			" AND "+categoryFilter+ " AND "+lowerAgeFilter+" AND "+upperAgeFilter+" GROUP BY u.state "
			+ "ORDER BY u.state";
			long start = System.nanoTime();
			stateSpentRS = stmt4.executeQuery(stateSpentSQL);
			long end = System.nanoTime();
			out.println("State Spent: " + (end - start));
			String startState = "";
			String endState = "";
			if (nextRows >= 2) {
				startState = states[40];
				endState = states[49];
			} else if (nextRows == 1) {
				startState = states[20];
				endState = states[39];
			} else {
				startState = states[0];
				endState = states[19];
			}
			spentSQL = "SELECT p.id, p.name, u.state, SUM(s.quantity*s.price) FROM "
			+"products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN "+
			"sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id AND "+lowerAgeFilter+
			" AND "+upperAgeFilter+" WHERE p.name >= '"+
			prodNames.get(0)+"' AND p.name <= '"+prodNames.get(prodNames.size()-1)+"' AND u.state >= '"
			+startState+"' AND u.state <= '"+endState+"' "+
			"GROUP BY u.state, p.id ORDER BY u.state";

			start = System.nanoTime();
			spentRS = stmt3.executeQuery(spentSQL);
			end = System.nanoTime();
			out.println("Spent: " + (end - start));
		} else { // Dealing with customers
			customerSpentSQL = "SELECT u.id, u.name, COALESCE(SUM(s.quantity*s.price),0) FROM "
			+ "users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON "
			+ "(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE "+stateFilter+
			" AND "+categoryFilter+ " AND "+lowerAgeFilter+" AND "+upperAgeFilter+" GROUP BY u.id "
			+ "ORDER BY u.name LIMIT 20 OFFSET " +(nextRows*20);
			long start = System.nanoTime();
			customerSpentRS = stmt5.executeQuery(customerSpentSQL);
			long end = System.nanoTime();
			out.println("Customer Spent: " + (end - start));
			ArrayList<String> customerNames = new ArrayList<String>();
			if (customerSpentRS.next()) {
				customerSpentRS.first();
				customerNames.add("'"+customerSpentRS.getString(2)+"'");
				customerSpentRS.last();
				customerNames.add("'"+customerSpentRS.getString(2)+"'");
			}
			customerSpentRS.beforeFirst();
			// Add condition for if no customers to show
			if (customerNames.size() == 0) {
				customerNames.add("u.name");
			}
			if (prodNames.size() == 0) {
				prodNames.add("p.name");
			}
			customersRS = stmt7.executeQuery("SELECT id, name FROM users u WHERE "+stateFilter+" AND "
			+lowerAgeFilter+" AND "+upperAgeFilter+ " ORDER BY u.name LIMIT 20 OFFSET "+(nextRows*20));

			spentSQL = "SELECT p.id, p.name, u.name, SUM(s.quantity*s.price) FROM "
			+"products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN "+
			"sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id WHERE p.name >= "+
			prodNames.get(0)+" AND p.name <= "+prodNames.get(prodNames.size()-1)+" AND u.name >= "+
			customerNames.get(0)+" AND u.name <= "+customerNames.get(customerNames.size()-1)+
			" GROUP BY u.name, p.id ORDER BY u.name";
			start = System.nanoTime();
			spentRS = stmt3.executeQuery(spentSQL);

			end = System.nanoTime();
			out.println("Spent: " + (end - start));
		}

		// If the rows selected is states, then show the first 20 states
		// otherwise traverse through the products
		while((rowsTitle.equals("States") ? (i < (Math.min(20+(nextRows*20), states.length))) : (customersRS.next()))) {
			// If the state was not specified and rows selection was States
			if(rowsTitle.equals("States") && stateSel.equals("All States")){
				name = states[i];
				tempState = name;
			}
			// If the rows selection was States and a state was specified
			else if(rowsTitle.equals("States") && !stateSel.equals("All States")){
				name = stateSel;
				tempState = name; // Store the state temporarily
				//stateSel = "All States";
				temp = i; // Store the index
				i = 20; // Essentially break out of the loop
			}
			// If the rows selection was States
			stateSpentTot = 0;
			if (rowsTitle.equals("States")) {
				while (stateSpentRS.next()) {
			    	if (name.equals(stateSpentRS.getString(1))) {
			    		stateSpentTot = stateSpentRS.getFloat(2);
			    		break;
			    	}
				}
				stateSpentRS.beforeFirst();
				out.println("<tr align=\"center\"><td width=\"20%\">"+name+" ($"+stateSpentTot+")</td>");
			 }
			 else { // If the rows selection was Customers
			 	uID = customersRS.getInt(1);
			 	if (customerSpentRS.next() && 
			 			customersRS.getString(2).equals(customerSpentRS.getString(2))) {
			 		name = customerSpentRS.getString(2); // Get the user name
			 		customerSpentTot = customerSpentRS.getFloat(3);
			 		out.println("<tr align=\"center\"><td width=\"20%\">"+name+" ($"+customerSpentTot+")</td>");
			 	} else {
			 		customerSpentRS.previous();
			 		customerSpentTot = 0;
			 		name = customersRS.getString(2); // Get the user name
			 		out.println("<tr align=\"center\"><td width=\"20%\">"+name+" ($"+customerSpentTot+")</td>");
			 	}
			 	//name = customerSpentRS.getString(2); // Get the user name
			}
			//prodSpentRS = stmt6.executeQuery(prodSpentSQL);
			prodSpentRS.beforeFirst();
		 	// Iterate through the number of products retrieved by query

		 	ArrayList<String> prodsBought = new ArrayList<String>();
		 	ArrayList<Float> prodsPrice = new ArrayList<Float>();
		 	int count = 0;
		 	while (spentRS.next()) {
		 		if (rowsTitle.equals("States")) {
		 			//out.println(name);
		 			if (name.equals(spentRS.getString(3))) {
		 				prodsBought.add(spentRS.getString(2));
			 			prodsPrice.add(spentRS.getFloat(4));
		 			}
		 		} else {
			 		if (customersRS.getString(2).equals(spentRS.getString(3))) {
			 			//count++;
			 			prodsBought.add(spentRS.getString(2));
			 			prodsPrice.add(spentRS.getFloat(4));
			 		} else {
			 			//if (count > 0) break;
			 			count = 0;
			 		}
		 		}
		 	}
		 	spentRS.beforeFirst();
		 	for (int j = 0; j < prodNames.size(); j++) {
		 		boolean notFound = true;
		 		for (int k = 0; k < prodsBought.size(); k++) {
		 			if (prodNames.get(j).equals(prodsBought.get(k))) {
		 				out.print("<td width=\"8%\">$"+prodsPrice.get(k)+"</td>");
		 				notFound = false;
		 				break;
		 			}
		 		}
		 		if (notFound) {
		 			out.print("<td width=\"8%\">$0</td>");
		 		}
		 	}
			i++; // Increment index
			temp = i; // Store the index
		}
		out.println("</table>");
		out.println("<br/>");
		String nextVal = "";
		// Decide which button to show based on the rows selection
		if (rowsTitle.equals("States")) {
			nextVal = "Next 20 States";
		} else {
			nextVal = "Next 20 Customers";
		}
		
		long endTime = System.nanoTime();
		long totalTime = endTime - startTime;
		double seconds = (double)totalTime / 1000000000.0;
		out.println("Total time: " + (seconds));
		%>
		<div align="right"><form action="sales_analytics.jsp">
			<input type="submit" name="Next 20 Rows" value="<%=nextVal%>"/>
		</form></div>
		
		<div align="right"><form action="sales_analytics.jsp">
		    <input type="submit" name="Next 10 Products" value="Next 10 Products"/>
		</form></div>
		<br/>
		<%
	}
	catch(Exception e)
	{
		out.println(e);
		out.println(SQL);
		out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");

	
	}
	finally
	{
		conn.close();
	}
}
else
{
	out.println("Please go to <a href=\"login.jsp\" target=\"_self\">home page</a> to login first.");
}
%>
</div>
</body>
</html>