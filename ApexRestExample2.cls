@RestResource(urlMapping='/v1.0/Contacts/*')
global with sharing class ApexRestExample2
{
	@HttpGet
	global static List <Contact> doGet()
	{
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;

		try
		{
			// get the account ID parameter from the URL
			Id accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
			// OR Id accountId = req.params.get('id'); for key=value

			// query the database and reutn the result
			return [SELECT Id, Name, Phone FROM Contact WHERE AccountId = :accountId];
		}
		catch (Exception e)
		{
			// possible invalid ID, return empty list
			return new List <Contact> ();
		}
	}

	@HttpPost
	global static String doPost(String firstName, String lastName, String accountId)
	{
		Contact contact = new Contact();
		contact.FirstName = firstName;
		contact.LastName = lastName;
		contact.AccountId = accountId;
		insert contact;

		return contact.Id;

		/*
			{
				"firstName":"Test",
				"lastName":"Contact",
				"accountId":"001900000136LSj"
			}
		*/
	}

	global class CustomContact
	{
		public String id;
		public String firstname;
		public String lastname;
	}

	@HttpPatch
	global static String doPatch(CustomContact contact)
	{
		if (contact.id != null)
		{
			Contact sfContact = new Contact(Id = contact.id);
			sfContact.FirstName = contact.firstname;
			sfContact.LastName = contact.lastname;
			update sfContact;

			return 'success';
		}

		return 'Contact ID is missing';

		/*
			{
				"contact":
				{
					"id":"00390000017jqYsAAI",
					"firstname":"abc",
					"lastname":"test"
				}
			}

			OR XML (Change the Content-type header to application/xml)

			<request>
				<contact>
					<id>00390000017jqYsAAI</id>
					<firstname>aaa</firstname>
					<lastname>bbb</lastname>
				</contact>
			</request>
		*/
	}

}