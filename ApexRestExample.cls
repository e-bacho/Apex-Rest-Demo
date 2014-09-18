@RestResource(urlMapping='/v1.0/Account/*')
global with sharing class ApexRestExample
{
	global class GenericResponse
	{
		public Boolean success;
		public String errorMessage;
		public Account result;

		public GenericResponse(String e)
		{
			this.errorMessage = e;
			this.result = new Account();
			this.success = false;
		}

		public GenericResponse(Account a)
		{
			this.errorMessage = null;
			this.result = a;
			this.success = true;
		}
	}

	@HttpGet
	global static GenericResponse doGet()
	{
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;

		try
		{
			// get the account ID parameter from the URL
			Id accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

			// query the database and reutn the result
			return new GenericResponse([SELECT Id, Name, Phone FROM Account WHERE Id = :accountId]);
		}
		catch (Exception e)
		{
			// possible invalid ID
			return new GenericResponse('An error occurred: ' + e.getMessage());
		}
	}
}