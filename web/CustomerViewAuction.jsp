<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.NumberFormat"%>
<!DOCTYPE html>
<html>
    <%
    String mysJDBCDriver = "com.mysql.jdbc.Driver"; 
    String mysURL = "jdbc:mysql://mysql2.cs.stonybrook.edu:3306/asfeng?allowMultipleQueries=true"; 
    String mysUserID = "asfeng"; 
    String mysPassword = "108685053";
    int auctionId = Integer.parseInt(request.getParameter("auctionId"));
    String customerId = ""+session.getValue("login");
  			java.sql.Connection conn=null;
			try
			{
            	Class.forName(mysJDBCDriver).newInstance();
    			java.util.Properties sysprops=System.getProperties();
    			sysprops.put("user",mysUserID);
    			sysprops.put("password",mysPassword);
        
				//connect to the database
            			conn=java.sql.DriverManager.getConnection(mysURL,sysprops);
            			System.out.println("Connected successfully to database using JConnect");
                                conn.setAutoCommit(false);
            			String query = "SELECT * FROM Item I, Auction A, Post P WHERE P.AuctionId = ? AND P.AuctionId = A.AuctionId AND A.ItemId = I.ItemId";
            			java.sql.PreparedStatement ps = conn.prepareStatement(query);
            			ps.setInt(1,auctionId);
				java.sql.ResultSet rs = ps.executeQuery();
                                NumberFormat formatter = new DecimalFormat("#0.00");
				if(rs.first()){
                                    
%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" integrity="sha512-dTfge/zgoMYpP7QbHy4gWMEGsbsdZeCXz7irItjcC3sPUFtf0kuFbDz/ixG7ArTxmDjLXDmezHubeNikyKGVyQ==" crossorigin="anonymous">

        <!-- Optional theme -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css" integrity="sha384-aUGj/X2zp5rLCbBxumKTCw2Z50WgIr1vs/PFN4praOTvYXWlVyh2UtNUU0KAUhAX" crossorigin="anonymous">

        <!-- Latest compiled and minified JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js" integrity="sha512-K1qjQ+NcF2TYO/eI3M6v8EiNYZfA95pQumfvcVrTHtwQVDG+aHRqLi/ETn2uB+1JqwYqVG3LIvdm9lj6imS/pQ==" crossorigin="anonymous"></script>
        <title>EDAY - Home</title>
    </head>
    <body>
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                      <span class="sr-only">Toggle navigation</span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="#"><%=session.getValue("login")%></a>
                </div>
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
			<li><a href="CustomerHome.jsp">Home</a></li>
                        <li><a href="CustomerAuctions.jsp">My Auctions</a></li>
                        <li><a href="#">My Bids</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="#"><span class="glyphicon glyphicon-log-out"></span></a></li>
                    </ul>
                </div><!-- /.navbar-collapse -->
            </div>
        </nav>
        <div class ="container">
            <div class="row">
		<div class="col-lg-8 col-lg-offset-2">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h2 class="panel-title">Auction #<%=rs.getInt("AuctionId")%></h2>
                        </div>
                        <div class="panel-body">
                            <div class="col-xs-6">
                            <ul class="list-unstyled">
                                <li><b>Item:</b> <%=rs.getString("Name")%></li>
                                <li><b>Type:</b> <%=rs.getString("Type")%></li>
                                <li><b>Year:</b> <%=rs.getString("Year")%></li>
                                <li><b>Copies:</b> <%=rs.getString("NumCopies")%></li>
                                <li><b>Description:</b> <%=rs.getString("Description")%></li>
                                <li><b>Post Date:</b> <%=rs.getString("PostDate")%></li>
                            </ul>
                            </div>
                            <div class="col-xs-6">
                                <ul class="list-unstyled">
                                <li><b>Minimum Bid:</b> <%=rs.getString("MinimumBid")%></li>
                                <li><b>Bid Increment:</b> <%=rs.getString("BidIncrement")%></li>
                                <li><b>Reserve Price:</b> <%=rs.getString("ReservePrice")%></li>
                                <li><b>Current Hi Bid:</b> <%=rs.getString("CurrentHiBid")%></li>
                                <li><b>Current Hi Bidder:</b>  <%=rs.getString("CurrentHiBidder")%></li>
                                <li><b>Expire Date:</b> <%=rs.getString("ExpireDate")%></li>
                                </ul>
                            </div>
                            <h4>Bid History</h4>
                    <table class="table">
                        <tr>
                            <th>Bidder</th>
                            <th>Bid Price</th>
                            <th>Bid Time</th>
                            <th></th>
                        </tr>
                        <%
                                }
                                String query2 = "SELECT B.CustomerId, B.BidTime, B.BidPrice FROM Bid B WHERE B.AuctionId = ? ORDER BY B.BidTime DESC";
                                ps = conn.prepareStatement(query2);
            			ps.setInt(1,auctionId);
				rs = ps.executeQuery();
                                while(rs.next()){
                        %>
                                <tr>
                                    <td><%=rs.getString("CustomerId")%></td>
                                    <td><%=formatter.format(rs.getDouble("BidPrice"))%></td>
                                    <td><%=rs.getString("BidTime")%></td>
                                    <td><span><form action="CustomerViewAuction.jsp" method="post"><input type="hidden" name="auctionId" id="auctionId" value=<%=rs.getInt("AuctionId")%>><button type="submit">View Details</button></form></span>
                                </tr>
<%                          }
                                
                        }
                        catch(Exception e)
			{
				e.printStackTrace();
				out.print(e.toString());
			}
			finally{
			
				try{conn.close();}catch(Exception ee){};
			}
%>
                    </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>