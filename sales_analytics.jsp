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
if(session.getAttribute("name")!=null)
{
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
%>


		<%
		Connection conn=null;
		Statement stmt, stmt2, stmt3, stmt4, stmt5, stmt6;
		String SQL=null;
		String prodSQL=null;
		try
		{
			try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
			String url="jdbc:postgresql://127.0.0.1:5432/P1";
			String user="postgres";
			String password="880210";
			conn =DriverManager.getConnection(url, user, password);
			stmt =conn.createStatement();
			stmt2 =conn.createStatement();
			stmt3 = conn.createStatement();
			stmt4 = conn.createStatement();
			stmt5 = conn.createStatement();
			stmt6 = conn.createStatement();
			ResultSet rs=null;
			ResultSet prodRS=null;
			ResultSet spentRS = null;
			ResultSet stateSpentRS = null;
			ResultSet customerSpentRS = null;
			ResultSet prodSpentRS = null;
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
		String rowsTitle = "";
		String stateSel = "All States";
		String category = "All Categories";
		String ageSel = "All Ages";
		// If the user clicked run query
		if (action != null && action.equals("Run Query")) {
			rowsTitle = request.getParameter("rowTitle");
		} else {
			rowsTitle = "Customers"; // Set default to be Customers
		}
		stateSel = request.getParameter("state"); // Get the selected state
		if (stateSel == null) {
			stateSel = "All States"; // Set default to be All States
		}
		category = request.getParameter("category"); // Get the selected category
		if (category == null) {
			category = "All Categories"; // Set the default to be All Categories
		}
		ageSel = request.getParameter("age"); // Get the selected age range
		int upperAge = 0; 
		int lowerAge = 0;
		String upperStr = "";
		String lowerStr = "";
		int dash = -1;
		if (ageSel == null) {
			ageSel = "All Ages"; // Set the default to be All Ages
		} 
		//Parse the selected age range to grab the upper and lower bounds
		if (!ageSel.equals("All Ages")) {
			dash = ageSel.indexOf("-");
			lowerStr = ageSel.substring(0, dash);
			upperStr = ageSel.substring(dash+1, ageSel.length());
			lowerAge = Integer.parseInt(lowerStr);
			if(!upperStr.equals("")){
				upperAge = Integer.parseInt(upperStr);
			}		
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
				if(stateSel != null && stateSel.equals("All States")) {
					SQL="SELECT id, name FROM users ORDER BY name asc LIMIT 20";
				} else { // There was some specified state
					SQL="SELECT id, name FROM users WHERE state = '"+stateSel+ 
					"' ORDER BY name asc LIMIT 20";
				}
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
<form action="sales_analytics.jsp">
	<input type="hidden">&nbsp;</>
	Rows:
	<SELECT name="rowTitle">
		<OPTION value="Customers">Customers</OPTION>
		<OPTION value="States">States</OPTION>
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
		<OPTION value="All Ages">All Ages</OPTION>
		<OPTION value="12-18">12-18</OPTION>
		<OPTION value="18-45">18-45</OPTION>
		<OPTION value="45-65">45-65</OPTION>
		<OPTION value="65-">65-</OPTION>
	</SELECT>
	<input type="submit" name="runQuery" value="Run Query"/>
</form>

<br>


<%		
		// If category is All Categories
		if(category != null && category.equals("All Categories")){
			prodSQL="SELECT id, name FROM products ORDER BY name LIMIT 10";
			category = "c.name";
		} else { // Category is specified
			category = "'"+category+"'";
			prodSQL="SELECT p.id, p.name FROM products p, categories c WHERE c.name= "+category+" AND c.id=p.cid ORDER BY p.name LIMIT 10";
		}
		prodRS=stmt2.executeQuery(prodSQL);
		rs=stmt.executeQuery(SQL);

		out.println("<table width=\"100%\"  border=\"1px\" align=\"center\">");
		out.println("<tr align=\"center\"><td width=\"20%\"><B>"+rowsTitle+"</B></td>");
		String prodName=""; // Store the product name
		int[] prodID = new int[10]; // Store the first 10 id's of the products
		int prodIndex = 0;
		// Go through the first 10 products and get id and name
		while (prodRS.next()) {
		    int id = prodRS.getInt(1);
		    prodName = prodRS.getString(2);
		    String stateTemp = stateSel;
		    // If state is not specified
		    if (stateTemp.equals("All States")) {
		    	stateTemp = "u.state";
			} else { // State is specified
				stateTemp = "'" + stateSel + "'";
			}
			// Truncate the product name to only 10 characters
		    String truncProdName = prodName.substring(0, Math.min(prodName.length(), 10));
		    String prodSpentSQL = "";
		    // If no age filter was specified
		    if (ageSel.equals("All Ages")) {
			    prodSpentSQL = "SELECT p.name, SUM(s.quantity*s.price) FROM products p, sales s, "
			    + " users u, categories c WHERE p.id = s.pid AND p.name = '"+prodName+"' AND u.state = "+stateTemp+" AND u.id = s.uid AND p.cid = c.id AND c.name = "+category+
			    " GROUP BY p.id ORDER BY p.name";
			} else if (lowerAge == 65) { // The range of 65- for age was selected
				prodSpentSQL = "SELECT p.name, SUM(s.quantity*s.price) FROM products p, sales s, "
			    + " users u, categories c WHERE p.id = s.pid AND p.name = '"+prodName+"' AND u.state = "+stateTemp+" AND u.id = s.uid AND u.age >= "+lowerAge+
			    " AND p.cid = c.id AND c.name = "+category+" GROUP BY p.id ORDER BY p.name";
			} else { // All other ranges for ages
				prodSpentSQL = "SELECT p.name, SUM(s.quantity*s.price) FROM products p, sales s, "
			    + " users u, categories c WHERE p.id = s.pid AND p.name = '"+prodName+"' AND u.state = "+stateTemp+" AND u.id = s.uid AND u.age >= "+lowerAge+" AND u.age < "+upperAge+
			    " AND p.cid = c.id AND c.name = "+category+" GROUP BY p.id ORDER BY p.name";
			}
		    prodSpentRS = stmt6.executeQuery(prodSpentSQL);
		    float prodSpentTot = 0;
		    if (prodSpentRS.next()) // There was some money spent on that product
		    	prodSpentTot = prodSpentRS.getFloat(2);
			out.println("<td width=\"8%\"><B>"+truncProdName+"<br/>($"+prodSpentTot+")</B></td>");
			prodID[prodIndex] = id; // Store the product id
			prodIndex++; // Increment the index for later use
		}
		int id=0; // Store the id
		int uID = 0; // Store the user id
		String name="", SKU="", tempState = "";
		float price=0;
		int i = 0;
		int temp = i; // Store index temporarily
		float stateSpentTot = 0; // Total amount spent by the state
		float customerSpentTot = 0; // Total amount spent by the customer
		// If the rows selected is states, then show the first 20 states
		// otherwise traverse through the products
		while((rowsTitle.equals("States") ? (i < 20) : (rs.next()))) {
			// If the state was not specified and rows selection was States
			if(rowsTitle.equals("States") && stateSel.equals("All States")){
				name = states[i];
				tempState = name;
			}
			// If the rows selection was States and a state was specified
			else if(rowsTitle.equals("States") && !stateSel.equals("All States")){
				name = stateSel;
				tempState = name; // Store the state temporarily
				stateSel = "All States";
				temp = i; // Store the index
				i = 20; // Essentially break out of the loop
			}
		 	else { // Rows selection was Customer
		 		name = rs.getString(2); // Get the name of the product
		 	}
			String stateSpentSQL = "";
			// If the rows selection was States
			if (rowsTitle.equals("States")) {
			 	if (ageSel.equals("All Ages")) {
			 		stateSpentSQL = "SELECT SUM(s.quantity*s.price) FROM users u, sales s,"
			 	+ " categories c, products p WHERE u.state = '"+tempState+"' AND u.id = s.uid AND "
			 	+ "s.pid = p.id AND p.cid = c.id AND c.name = "+category+" GROUP BY u.state";
			 	} else if (lowerAge == 65) {
			 		stateSpentSQL = "SELECT SUM(s.quantity*s.price) FROM users u, sales s,"
				 	+ " categories c, products p WHERE u.state = '"+tempState+"' AND u.id = s.uid AND "
				 	+ "s.pid = p.id AND p.cid = c.id AND c.name = "+category+" AND " +
				 	"u.age >= "+lowerAge+" GROUP BY u.state";
			 	} else {
				 	stateSpentSQL = "SELECT SUM(s.quantity*s.price) FROM users u, sales s,"
				 	+ " categories c, products p WHERE u.state = '"+tempState+"' AND u.id = s.uid AND "
				 	+ "s.pid = p.id AND p.cid = c.id AND c.name = "+category+" AND " +
				 	"u.age >= "+lowerAge+" AND age < "+upperAge+" GROUP BY u.state";
			 	}
			 	stateSpentRS = stmt4.executeQuery(stateSpentSQL);
			 	if (stateSpentRS.next()) {
			 		stateSpentTot = stateSpentRS.getFloat(1);
			 	} 
			 	else {
			 		stateSpentTot = 0;
			 	}
			 }
			 else {
			    uID = rs.getInt(1); // Get the user id
			 	name = rs.getString(2); // Get the user name
			 	String customerSpentSQL = "";
			 	if (ageSel.equals("All Ages")) {
			 		customerSpentSQL = "SELECT SUM(s.quantity * s.price) FROM users u, sales s, categories c, products p WHERE u.name = '"+name+"' AND u.id = s.uid AND s.pid = p.id AND p.cid = c.id AND c.name = "+category+" GROUP BY u.name";
			 	} else if (lowerAge == 65) {
			 		customerSpentSQL = "SELECT SUM(s.quantity * s.price) FROM users u, sales s, categories c, products p WHERE u.name = '"+name+"' AND u.id = s.uid AND s.pid = p.id AND p.cid = c.id AND c.name = "+category+" AND u.age >= "+lowerAge+
			 		" GROUP BY u.name";
			 	} else {
			 		customerSpentSQL = "SELECT SUM(s.quantity * s.price) FROM users u, sales s, categories c, products p WHERE u.name = '"+name+"' AND u.id = s.uid AND s.pid = p.id AND p.cid = c.id AND c.name = "+category+" AND u.age >= "+lowerAge+" AND age < "+upperAge+" GROUP BY u.name";
			 	}
			 	customerSpentRS = stmt5.executeQuery(customerSpentSQL);
			 	if(customerSpentRS.next()){
			 	    customerSpentTot = customerSpentRS.getFloat(1);
			 	}
			 	else{
			 	    customerSpentTot = 0;
			 	}
			 }
			 	
		 	// If the rows selection was States then display state and total spent by that state
		 	if(rowsTitle.equals("States")){
		 	    out.println("<tr align=\"center\"><td width=\"20%\">"+name+" ($"+stateSpentTot+")</td>");
		 	}
		 	else { // Rows selection was Customers so display customer name and total spent by customer
		 	    out.println("<tr align=\"center\"><td width=\"20%\">"+name+" ($"+customerSpentTot+")</td>");

		 	}
		 	
		 	// Iterate through the number of products retrieved by query
			for (int j = 0; j < prodIndex; j++) {
			    String spentSQL = "";
			    if (rowsTitle.equals("States")) {
			    	if (ageSel.equals("All Ages")) {
				    	spentSQL = "SELECT SUM(s.quantity*s.price) FROM users u, sales s, products p WHERE" 
				    	+ " u.state = '"+tempState+"' AND s.uid = u.id AND p.id = "+prodID[j]+
				    	" AND s.pid = p.id GROUP BY u.state";
				 	} else if (lowerAge == 65) {
				 		spentSQL = "SELECT SUM(s.quantity*s.price) FROM users u, sales s, products p WHERE" 
				    	+ " u.state = '"+tempState+"' AND s.uid = u.id AND p.id = "+prodID[j]+
				    	" AND s.pid = p.id AND u.age >= "+lowerAge+" GROUP BY u.state";
				 	} else {
				 		spentSQL = "SELECT SUM(s.quantity*s.price) FROM users u, sales s, products p WHERE" 
				    	+ " u.state = '"+tempState+"' AND s.uid = u.id AND p.id = "+prodID[j]+
				    	" AND s.pid = p.id AND u.age >= "+lowerAge+" AND age < "+upperAge+" GROUP BY u.state";
				 	}
				}
			 	else {
			 		if (ageSel.equals("All Ages")) {
			 			spentSQL = "SELECT SUM(s.quantity*s.price) FROM users u, sales s, "+
			 			"products p WHERE u.id = "+uID+" AND s.uid = u.id AND p.id = "+prodID[j]+" AND s.pid = p.id";
				 	} else if (lowerAge == 65) {
				 		spentSQL = "SELECT SUM(s.quantity*s.price) FROM users u, sales s, "+
			 			"products p WHERE u.id = "+uID+" AND s.uid = u.id AND p.id = "+prodID[j]+" AND s.pid = p.id AND u.age >= "+lowerAge+" AND age < "+upperAge;
				 	} else {
				 		spentSQL = "SELECT SUM(s.quantity*s.price) FROM users u, sales s, "+
			 			"products p WHERE u.id = "+uID+" AND s.uid = u.id AND p.id = "+prodID[j]+" AND s.pid = p.id AND u.age >= "+lowerAge;
				 	}
			 	}
			 	spentRS = stmt3.executeQuery(spentSQL);
			 	if (spentRS.next()) {
			 		out.print("<td width=\"8%\">$"+spentRS.getFloat(1)+"</td>");
			 	} else {
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
		%>
		<div align="right"><form action="sales_analytics.jsp">
			<input type="submit" name="<%=nextVal%>" value="<%=nextVal%>"/>
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