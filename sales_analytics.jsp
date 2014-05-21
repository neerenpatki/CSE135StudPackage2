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
		Statement stmt, stmt2;
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
			ResultSet rs=null;
			ResultSet prodRS=null;
			rs=stmt.executeQuery("SELECT * FROM categories order by id asc;");
			String c_name=null;
			int c_id=0;
		%>

<div style="width:98%; position:absolute; top:80px; left:10px; right:10px; height:87%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<%
		String[] states = { "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
			"Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana",
			"Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
			"Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
			"New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma",
			"Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
			"Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", 
			"Wyoming" };
		String action = request.getParameter("runQuery");
		String rowsTitle = "";
		String stateSel = "All States";
		if (action != null && action.equals("Run Query")) {
			rowsTitle = request.getParameter("rowTitle");
		} else {
			rowsTitle = "Customers"; 
		}
		stateSel = request.getParameter("state");

	   String c_id_str=null,key=null;
	   int c_id_int=-1;
	   try {c_id_str=request.getParameter("cid"); c_id_int=Integer.parseInt(c_id_str);}catch(Exception e){c_id_str=null;c_id_int=-1;}
	   try {key=request.getParameter("key");}catch(Exception e){key=null;}

		// Check for default "Customers" option selected and limit to 20 customers
		if(c_id_int==-1 && key==null)
		{
			if (rowsTitle.equals("States")){
				SQL = "SELECT state FROM users ORDER BY state asc LIMIT 20";

			}
			else{
				if(stateSel.equals("All States")){
					SQL="SELECT name FROM users ORDER BY name asc LIMIT 20";
				} else{
					SQL="SELECT name FROM users WHERE state = '"+stateSel+ 
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
	Filter By:
	<SELECT name="rowTitle">
		<OPTION value="Customers">Customers</OPTION>
		<OPTION value="States">States</OPTION>
	</SELECT>
	<SELECT NAME="state">
	   <OPTION value-="All States">All States</OPTION>
	   <%for (int i = 0; i < states.length; i++) {%>
	   <OPTION value=<%=states[i]%>><%=states[i]%></OPTION>
	   <%}%>
	</SELECT>
	<SELECT name="category">
		<OPTION value="All Categories">All Categories</OPTION>
		<%
		while (rs.next()) { %>
			<OPTION value=<%=rs.getString(2)%>><%=rs.getString(2)%></OPTION>
		<%
		}
		%>

	</SELECT>
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
		prodSQL="SELECT RPAD(name,10,\'\') FROM Products ORDER BY name LIMIT 10";
		prodRS=stmt2.executeQuery(prodSQL);
		rs=stmt.executeQuery(SQL);

		
		out.println("<table width=\"100%\"  border=\"1px\" align=\"center\">");
		out.println("<tr align=\"center\"><td width=\"20%\"><B>"+rowsTitle+"</B></td>");
		String prodName="";
		while(prodRS.next()){
			prodName = prodRS.getString(1);
			out.println("<td width=\"8%\"><B>"+prodName+"</B></td>");
		//<td width=\"20%\"><B>"+prodName+"</B></td><td width=\"20%\"><B>Category</B></td><td width=\"20%\"><B>Price</B></td><td width=\"20%\"><B>Operations</B></td></tr>");
		}	
		/*out.println("<table width=\"100%\"  border=\"1px\" align=\"center\">");
		out.println("<tr align=\"center\"><td width=\"20%\"><B>Product Name</B></td><td width=\"20%\"><B>SKU number</B></td><td width=\"20%\"><B>Categgory</B></td><td width=\"20%\"><B>Price</B></td><td width=\"20%\"><B>Operations</B></td></tr>");*/
		int id=0;
		String name="", SKU="",category=null;
		float price=0;
		int i = 0;
		while((rowsTitle.equals("States") ? (i < 20) : (rs.next())))
		{
			//if (!rs.next()) break;
			/*id=rs.getInt(1);
			name=rs.getString(2);
			 SKU=rs.getString(3);
			 category=rs.getString(4);
			 price=rs.getFloat(5);*/

			 //name = rs.getString(1);
			 //out.println("<tr align=\"center\"><td width=\"20%\">"+name+"</td>");

			if(rowsTitle.equals("States") && stateSel.equals("All States")){
				name = states[i];
			}
			else if(rowsTitle.equals("States") && !stateSel.equals("All States")){
				name = stateSel;
				stateSel = "All States";
				out.println("<tr align=\"center\"><td width=\"20%\">"+name+"</td>");
				break;
			}
		 	else{
		 		name = rs.getString(1);
		 	}
		 	out.println("<tr align=\"center\"><td width=\"20%\">"+name+"</td>");
		 	i++;
		}
		out.println("</table>");
		out.println("<br/>");
		%>
		<div align="right"><form action="sales_analytics.jsp">
			<input type="submit" name="next" value="Next"/>
		</form></div>
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