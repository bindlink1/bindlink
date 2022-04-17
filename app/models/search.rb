class Search < ActiveRecord::Base
  attr_accessor :result_id, :type, :identifier, :carrier, :status, :effective, :expiration, :contact_type, :contact_value, :score


  def searchforcashentry(polnum,carrier_id, agency_id)
    @results = Policy.where("policy_number ILIKE ? AND carrier_id = ? AND generalagency_id = ?", "%#{polnum}%", carrier_id, agency_id )
  end


  def universalsearch(searchinput, agency_id, agencytype, searchtype)
    searchresults = []

    if agencytype == "GA"
      if searchtype == "Anything" or searchtype =="Producing Agencies"
        producer = searchbyproducer(searchinput,agency_id)
        producer.each do |prod|
          search = Search.new
          search.result_id = prod.id
          search.type = "producer"
          search.identifier = prod.agency_name
          search.score = prod.totalscore
          if  prod.totalscore.to_f > 0.1
            searchresults << search
          end
        end
      end
      if searchtype == "Anything" or searchtype == "Agency Code"
        producercode = searchbyproducercode(searchinput,agency_id)
        producercode.each do |prod|
          search = Search.new
          search.result_id = prod.id
          search.type = "producercode"
          search.identifier = prod.agency_code
          search.score = prod.totalscore
          if  prod.totalscore.to_f > 0.5
            searchresults << search
          end
        end
      end
      if searchtype == "Anything" or searchtype == "Named Insureds"
        namedinsured = searchbynamedinsured(searchinput, agency_id)
        namedinsured.each do |prod|
          search = Search.new
          search.result_id = prod.id
          search.type = "namedinsured"
          search.identifier = prod.named_insured
          search.score = prod.totalscore
          if  prod.totalscore.to_f > 0.1
            searchresults << search
          end
        end
      end


    else

      if searchtype == "Anything" or searchtype == "Phone/e-Mails"
        clientcontact = searchbyclientcontact(searchinput, agency_id)
        clientcontact.each do |prod|
          search = Search.new
          search.result_id = prod.id

          search.type = "clientcontact"

          search.score = prod.totalscore
          if  prod.totalscore.to_f > 0.1
            searchresults << search
          end
        end
      end

      if searchtype == "Anything" or searchtype == "Clients"
        client = searchbyclient(searchinput, agency_id)
        client.each do |prod|
          search = Search.new
          search.result_id = prod.id

          search.type = "client"

          search.score = prod.totalscore

          if  prod.totalscore.to_f > 0.1
            searchresults << search
          end
        end
      end

      if searchtype == "Anything" or searchtype == "Clients"
        contact = searchbycontact(searchinput, agency_id)
        contact.each do |prod|
          search = Search.new
          search.result_id = prod.id
          search.type = "contact"
          search.score = prod.totalscore
          if  prod.totalscore.to_f > 0.1
            searchresults << search
          end
        end
      end
      if searchtype == "Anything" or searchtype == "Addresses"
        address = searchbyaddress(searchinput, agency_id)
        address.each do |prod|
          search = Search.new
          search.result_id = prod.id
          search.type = "address"
          search.score = prod.totalscore
          if  prod.totalscore.to_f > 0.1
            searchresults << search
          end
        end
      end
    end

    if searchtype == "Anything" or searchtype == "Policies"
    policy = searchbypolicy(searchinput, agency_id, agencytype)

    policy.each do |prod|
      search = Search.new
      search.result_id = prod.id
      search.type = "policy"
      search.identifier = prod.policy_number
      search.score = prod.totalscore
      if  prod.totalscore.to_f > 0.1
        searchresults << search
      end
    end
    end


    searchresults.sort_by!(&:score).reverse

  end


  def searchbyclient(searchinput, agency_id)

    @results = Client.find_by_sql(['SELECT clients.id, clients.first_name, clients.last_name, clients.corporate_name , clients.client_type, clients.client_status ,((similarity(clients.corporate_name,:search_input)) +  (similarity(clients.first_name,:search_input)) + (similarity(clients.last_name,:search_input))) AS totalscore FROM clients WHERE clients.agency_id = :agency_id AND ((similarity((clients.first_name  || clients.last_name),:search_input)>0.1) OR (similarity(clients.corporate_name, :search_input) > 0.1)) ORDER BY totalscore DESC LIMIT 10', :agency_id => agency_id ,:search_input => "%#{searchinput}%"])
    @results
  end

  def searchbyaddress(searchinput, agency_id)

    @results = Clientaddress.find_by_sql(['SELECT clientaddresses.id, clientaddresses.client_id, clientaddresses.address_1, clientaddresses.address_2, clientaddresses.city, clientaddresses.state, clientaddresses.zip, similarity((clientaddresses.address_1  || clientaddresses.address_2 || clientaddresses.city || clientaddresses.state || clientaddresses.zip) ,:search_input) as totalscore FROM clientaddresses LEFT JOIN clients ON clientaddresses.client_id = clients.id WHERE clients.agency_id = :agency_id and (similarity((clientaddresses.address_1  || clientaddresses.address_2 || clientaddresses.city || clientaddresses.state || clientaddresses.zip) ,:search_input) >0.3) ORDER BY totalscore DESC LIMIT 10', :agency_id => agency_id ,:search_input => "%#{searchinput}%" ])

     @results
  end

  def searchbycontact(searchinput, agency_id)
    @results = Client.find_by_sql(['SELECT clients.id, clients.first_name, clients.last_name, clients.corporate_name , clients.client_type, clients.client_status , clientphoneemails.contact_value, clientphoneemails.contact_type ,clientphoneemails.client_id ,( (similarity(clientphoneemails.contact_value,:search_input))) AS totalscore FROM clients LEFT JOIN clientphoneemails ON clients.id = clientphoneemails.client_id WHERE clients.agency_id = :agency_id AND (similarity(clientphoneemails.contact_value, :search_input) > 0.3) ORDER BY totalscore DESC LIMIT 10', :agency_id => agency_id ,:search_input => "%#{searchinput}%"])
    @results
  end

  def searchbyclientcontact(searchinput, agency_id)
    @results = Clientcontact.find_by_sql(['SELECT clientcontacts.id, clientcontacts.contact_value, ( (similarity(clientcontacts.contact_value,:search_input))) AS totalscore FROM clientcontacts LEFT JOIN clients ON clientcontacts.client_id = clients.id WHERE clients.agency_id = :agency_id AND (similarity(clientcontacts.contact_value, :search_input) > 0.3) ORDER BY totalscore DESC LIMIT 10', :agency_id => agency_id ,:search_input => "%#{searchinput}%"])
    @results
  end

  def searchbyproducer(searchinput, generalagency_id)
    @results = Producingagency.find_by_sql(['SELECT producingagencies.id, producingagencies.agency_name, producingagencies.status,( (similarity(producingagencies.agency_name,:search_input))) AS totalscore FROM producingagencies WHERE producingagencies.generalagency_id = :generalagency_id AND (similarity(producingagencies.agency_name, :search_input) > 0.3) ORDER BY totalscore DESC LIMIT 10', :generalagency_id => generalagency_id ,:search_input => "%#{searchinput}%"])
    @results
  end

  def searchbyproducercode(searchinput, generalagency_id)
    @results = Producingagency.find_by_sql(['SELECT producingagencies.id, producingagencies.agency_name, producingagencies.agency_code, producingagencies.status,( (similarity(producingagencies.agency_code,:search_input))) AS totalscore FROM producingagencies WHERE producingagencies.generalagency_id = :generalagency_id AND (similarity(producingagencies.agency_code, :search_input) > 0.5) ORDER BY totalscore DESC LIMIT 10', :generalagency_id => generalagency_id ,:search_input => "%#{searchinput}%"])
    @results
  end

  def searchbynamedinsured(searchinput, generalagency_id)
    @results = Namedinsured.find_by_sql(['SELECT namedinsureds.id, namedinsureds.named_insured, ( (similarity(namedinsureds.named_insured,:search_input))) AS totalscore FROM namedinsureds WHERE namedinsureds.generalagency_id = :generalagency_id AND (similarity(namedinsureds.named_insured, :search_input) > 0.1) ORDER BY totalscore DESC LIMIT 10', :generalagency_id => generalagency_id ,:search_input => "%#{searchinput}%"])
    @results
  end

  def searchbypolicy(searchinput, agency_id, agency_type)

    if agency_type == "GA"

      @results = Policy.find_by_sql(['SELECT policies.id, policies.policy_number, policies.carrier_id, policies.status, policies.effective_date, policies.expiration_date ,( (similarity(policies.policy_number,:search_input))) AS totalscore FROM policies WHERE policies.generalagency_id = :generalagency_id AND (similarity(policies.policy_number, :search_input) > 0.3) ORDER BY totalscore DESC LIMIT 10', :generalagency_id => agency_id ,:search_input => "%#{searchinput}%"])

    else
      @results = Policy.find_by_sql(['SELECT policies.id, policies.policy_number, policies.carrier_id, policies.status, policies.effective_date, policies.expiration_date ,( (similarity(policies.policy_number,:search_input))) AS totalscore FROM policies WHERE policies.agency_id = :agency_id AND (similarity(policies.policy_number, :search_input) > 0.3) ORDER BY totalscore DESC LIMIT 10', :agency_id => agency_id ,:search_input => "%#{searchinput}%"])

    end


    @results
  end


end
