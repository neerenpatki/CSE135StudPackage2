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
		Statement stmt;
		String SQL=null;
		try
		{
			try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
			String url="jdbc:postgresql://127.0.0.1:5432/P1";
			String user="postgres";
			String password="880210";
			conn =DriverManager.getConnection(url, user, password);
			stmt =conn.createStatement();
			ResultSet rs=null;
			rs=stmt.executeQuery("SELECT * FROM categories order by id asc;");
			String c_name=null;
			int c_id=0;
		%>

<div style="width:98%; position:absolute; top:80px; left:10px; right:10px; height:80%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<%
	   String c_id_str=null,key=null;
	   int c_id_int=-1;
	   try {c_id_str=request.getParameter("cid"); c_id_int=Integer.parseInt(c_id_str);}catch(Exception e){c_id_str=null;c_id_int=-1;}
	   try {key=request.getParameter("key");}catch(Exception e){key=null;}

		
		if(c_id_int==-1 && key==null)
		{
			SQL="SELECT id,name,SKU, category, price FROM products order by id asc;";
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
	   <OPTION value="Alabama">Alabama</OPTION>
	   <OPTION value="Alaska">Alaska</OPTION>
	   <OPTION value="Arizona">Arizona</OPTION>
	   <OPTION value="Arkansas">Arkansas</OPTION>
	   <OPTION value="California">California</OPTION>
	   <OPTION value="Colorado">Colorado</OPTION>
	   <OPTION value="Connecticut">Connecticut</OPTION>
	   <OPTION value="Delaware">Delaware</OPTION>
	   <OPTION value="Florida">Florida</OPTION>
	   <OPTION value="Georgia">Georgia</OPTION>
	   <OPTION value="Hawaii">Hawaii</OPTION>
	   <OPTION value="Idaho">Idaho</OPTION>
	   <OPTION value="Illinois">Illinois</OPTION>
	   <OPTION value="Indiana">Indiana</OPTION>
	   <OPTION value="Iowa">Iowa</OPTION>
	   <OPTION value="Kansas">Kansas</OPTION>
	   <OPTION value="Kentucky">Kentucky</OPTION>
	   <OPTION value="Louisiana">Louisiana</OPTION>
	   <OPTION value="Maine">Maine</OPTION>
	   <OPTION value="Maryland">Maryland</OPTION>
	   <OPTION value="Massachusetts">Massachusetts</OPTION>
	   <OPTION value="Michigan">Michigan</OPTION>
	   <OPTION value="Minnesota">Minnesota</OPTION>
	   <OPTION value="Mississippi">Mississippi</OPTION>
	   <OPTION value="Missouri">Missouri</OPTION>
	   <OPTION value="Montana">Montana</OPTION>
	   <OPTION value="Nebraska">Nebraska</OPTION>
	   <OPTION value="Nevada">Nevada</OPTION>
	   <OPTION value="New Hampshire">New Hampshire</OPTION>
	   <OPTION value="New Jersey">New Jersey</OPTION>
	   <OPTION value="New Mexico">New Mexico</OPTION>
	   <OPTION value="New York">New York</OPTION>
	   <OPTION value="North Carolina">North Carolina</OPTION>
	   <OPTION value="North Dakota">North Dakota</OPTION>
	   <OPTION value="Ohio">Ohio</OPTION>
	   <OPTION value="Oklahoma">Oklahoma</OPTION>
	   <OPTION value="Oregon">Oregon</OPTION>
	   <OPTION value="Pennsylvania">Pennsylvania</OPTION>
	   <OPTION value="Rhode Island">Rhode Island</OPTION>
	   <OPTION value="South Carolina">South Carolina</OPTION>
	   <OPTION value="South Dakota">South Dakota</OPTION>
	   <OPTION value="Tennessee">Tennessee</OPTION>
	   <OPTION value="Texas">Texas</OPTION>
	   <OPTION value="Utah">Utah</OPTION>
	   <OPTION value="Vermont">Vermont</OPTION>
	   <OPTION value="Virginia">Virginia</OPTION>
	   <OPTION value="Washington">Washington</OPTION>
	   <OPTION value="West Virginia">West Virginia</OPTION>
	   <OPTION value="Wisconsin">Wisconsin</OPTION>
	   <OPTION value="Wyoming">Wyoming</OPTION>
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
		String action = request.getParameter("runQuery");
		String rowsTitle = "";
		if (action != null && action.equals("Run Query")) {
			rowsTitle = request.getParameter("rowTitle");
		} else {
			rowsTitle = "Customers"; 
		}
		rs=stmt.executeQuery(SQL);
		out.println("<table width=\"100%\"  border=\"1px\" align=\"center\">");
		out.println("<tr align=\"center\"><td width=\"20%\"><B>"+rowsTitle+"</B></td><td width=\"20%\"><B>SKU number</B></td><td width=\"20%\"><B>Category</B></td><td width=\"20%\"><B>Price</B></td><td width=\"20%\"><B>Operations</B></td></tr>");
		/*out.println("<table width=\"100%\"  border=\"1px\" align=\"center\">");
		out.println("<tr align=\"center\"><td width=\"20%\"><B>Product Name</B></td><td width=\"20%\"><B>SKU number</B></td><td width=\"20%\"><B>Categgory</B></td><td width=\"20%\"><B>Price</B></td><td width=\"20%\"><B>Operations</B></td></tr>");
		int id=0;
		String name="", SKU="",category=null;
		float price=0;
		while(rs.next())
		{
			id=rs.getInt(1);
			name=rs.getString(2);
			 SKU=rs.getString(3);
			 category=rs.getString(4);
			 price=rs.getFloat(5);
			 out.println("<tr align=\"center\"><td width=\"20%\">"+name+"</td><td width=\"20%\">"+SKU+"</td><td width=\"20%\">"+category+"</td><td width=\"20%\">"+price+"</td><td width=\"20%\"><a href=\"product_order.jsp?id="+id+"\">Buy it</a></td></tr>");
		}*/
		out.println("</table>");
	}
	catch(Exception e)
	{
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