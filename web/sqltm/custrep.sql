SELECT P.ExpireDate, P.PostDate, P.CustomerID, P.AuctionID, A.CurrentHiBid, I.Name, A.CurrentHiBidder FROM Post P, Auction A, Item I, Person PE WHERE P.ExpireDate > NOW() AND P.AuctionID = A.AuctionID AND P.CustomerID = PE.SSN AND I.ItemID = A.ItemID;