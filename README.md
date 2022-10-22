# InstabugTask

1. Main Idea:
    - It's a framework for saving all network calls in core data that the user has made while browsing the application. But we have two restrictions: we only save the last 1000 network calls and the payload must be equal to or less than 1 MB.

2. App Features:
    - This app contains just one record called (Network Entity) which contains 7 properties, three for request calls and 4 for response.
    
    - All operations for core data have been manipulated in a background thread.
    
    - Using singleton pattern in NetworkClient and CoreDataStack to prevent anyone take an object from them except the Testing target I've added custom flag (Testing) so can mock for testing.
    
    - Using URLProtocol to mock network in addition to mock URLSessionDataDelegate to respond to whatever success or failure.
    
    - Have added protocol Restriction Network to mock count records from 1000 to 5 and payload size from 1MB to 10 bits to be easier to test.
    
    - InstabugNetworkClient was tested by unit tests (91.7% total framework coverage).
   
  Thanks! 😊 
 
