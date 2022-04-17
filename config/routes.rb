Bindlink::Application.routes.draw do
  resources :s3_uploads

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'marketing#index'
  resources :carriernaics
  match 'announcements/:id/hide', to: 'announcements#hide', as: 'hide_announcement'




  match 'postalfile/:id' => 'al3files#postalfile', :as =>"postalfile"
  match 'emaillog' => 'emaillog', :as => 'emaillog'

  resources :workstreams
  resources :worksteps
  resources :al3transactions
  match 'al3transactions/matchtransaction/:id' => 'al3transactions#matchtransaction'
  match 'al3transactions/processtransaction/:id' => 'al3transactions#processtransaction'
  match 'al3transactions/processnew/:id' => 'al3transactions#processnew'
  resources :acord_xml_pers_auto_policies
  resources :homeownerpolicies
  resources :customfieldvalues
  resources :customfields  do
    collection do
      get :fieldtype
    end
  end
  resources :emails
  resources :message_templates


  resources :producingagencies do
    resources :policies
    resources :documents
    resources :submissions
    resources :tasks
    resources :notes
    resources :namedinsureds
  end
  ##### online quoting routes
  resources :onlinequotes do
    resources :qualifyinganswers
  end
  resources :qualifyingquestions
  resources :qualifyinganswers


  ##### end online quoting routes


  resources :referers do
    resources :referrals
  end

  resources :referrals do
    resources :referers
  end

  resources :prospectpolicies
  resources :checklists do
    resources :lobcommissions
    resources :checklistitems
  end
  resources :quotes do
    resources :notes
    resources :tasks
    resources :policies
  end
  resources :namedinsureds do
    resources :submissions
    resources :policies
  end
  resources :checklistitems
  resources :submissions do
    resources :quotes
    resources :namedinsureds
    resources :notes
  end
  resources :clientphoneemails
  resources :clientaddresses
  resources :clientcontacts
  resources :lobcommissions
  resources :carrierlobs do
    resources :lobcommissions
  end
  resources :submissionposts
  resources :accounting
  resources :submission_applications
  resources :generalagencies

  resources :quotingentities
  resources :locations
  resources :carriers do
    resources :carriernaics
    resources :lineofbusinesses  do
      resources :carrierlobs
    end
  end
  resources :cashtransactions
  resources :appointments
  resources :invoices

  resources :notes do
    resources :tasks
    collection do
      get :infinitenotes
    end
  end
  resources :documents
  resources :pfcs
  resources :tasks
  resources :journalentries
  resources :policies do
    resources :journalentries
    resources :tasks
    resources :policypremiumtransactions
    resources :notes
    resources :acord_xml_pers_auto_policies
    resources :homeownerpolicies
    collection do
      get :invoicedue
      get :returnamountgnome
      get :cancbalance
      post :cancellationreturntoinvoice
      get :updateaftertransaction
      post :reinstatementtransactions
      get :carrierlobs
      get :feecalcs
    end
  end
  get "/reporting/clientcnt" => "clients#clientcnt"
  resources :clients do
    resources :clientaddresses
    resources :clientphoneemails
    resources :clientcontacts
    resources :referrals
    resources :referers
    resources :prospectpolicies
    resources :notes
    resources :policies
    resources :documents
    resources :quotes
    resources :tasks
    resources :customfieldvalues
    resources :acordforminstances
  end

  match '/acordforminstances/showmenu/:id' => 'acordforminstances#showmenu' , :as=> "showacordmenu"
  match 'customdocuments/showcustomdocument/:id/:policy_id' => 'customdocuments#showcustomdocument', :as=>'showcustomdocument'

  match '/statements/reconcilestatement' => 'statements#reconcilestatement'
  match '/statements/processreconciliation' => 'statements#processreconciliation'
  match '/statements/processreconciliationentries' => 'statements#processreconciliationentries'
  match '/statements/selectedpolicyentry/:id' => 'statements#selectedpolicyentry', :as=>'selectedpolicyentry'
  match '/statements/recordentry/:id' => 'statements#recordentry', :as=>'recordentry'


  resources :statements do
    collection { post :import }
  end

  match '/policypremiumtransactions/newajustment/:id' => 'policypremiumtransactions#newadjustment', :as=>'newadjustment'
  match '/policypremiumtransactions/processadjustment/:id' => 'policypremiumtransactions#processadjustment', :as=>'processadjustment'
  match '/policypremiumtransactions/reconcilesingleppt/:id' => 'policypremiumtransactions#reconcilesingleppt', :as=>'reconcilesingleppt'

  match '/emails/createdocemail' => 'emails#createdocemail', :as=>'createdocemail'
  match 'emails/sendalldocs/:id/:type/:doctype' => 'emails#sendalldocs' , :as=>'sendalldocs'
  match 'emails/sendalldocs/:id/:type' => 'emails#sendalldocs' , :as=>'sendalldocs'
  match 'emails/createdocmultipleemail' => 'emails#createdocmultipleemail' , :as=>'createdocmultipleemail'

  match 'download_document/:id' => 'documents#download', :as=>"download_document"
  match '/documents/editlist/:id' => "documents#editlist", :as=>"editlist"
  match '/documents/updatelist/:id' => "documents#updatelist", :as=>"updatelist"
  match '/documents/showgrid/:id/:type/:doctype' => "documents#showgrid", :as=>"showgrid"
  match '/documents/showlist/:id/:type/:doctype' => "documents#showlist", :as=>"showlist"
  match '/documents/createnewdocument/:id/:type/:doctype' => "documents#createnewdocument", :as=>"createnewdocument"
  match '/documents/showgrid/:id/:type' => "documents#showgrid", :as=>"showgrid"
  match '/documents/showlist/:id/:type' => "documents#showlist", :as=>"showlist"
  match '/documents/createnewdocument/:id/:type' => "documents#createnewdocument", :as=>"createnewdocument"
  match '/documentpages/showpages/:id' => "documentpages#showpages", :as=>"showpages"
  match '/clients/showactivepolicies/:id' => "clients#showactivepolicies" , :as=>"showactivepolicies"
  match '/clients/showrenewedpolicies/:id' => "clients#showrenewedpolicies" , :as=>"showrenewedpolicies"
  match '/clients/showcancelledpolicies/:id' => "clients#showcancelledpolicies" , :as=>"showcancelledpolicies"
  match '/clients/showrenewedpolicies/:id' => "clients#showrenewedpolicies" , :as=>"showrenewedpolicies"
  match '/clients/showrexpiredpolicies/:id' => "clients#showexpiredpolicies" , :as=>"showexpiredpolicies"
  match '/clients/showallpolicies/:id' => "clients#showallpolicies" , :as=>"showallpolicies"
  match '/tasks/showoutstandingtasks/:id' => "tasks#showoutstandingtasks", :as=>"showoutstandingtasks"
  match '/tasks/showcompletedtasks/:id' => "tasks#showcompletedtasks", :as=>"showcompletedtasks"
  resources :inboundemails

  match 'postemail/:id' => 'inboundemails#postemail', :as =>"postemail"
  match 'associateemail/:id' => 'inboundemails#associateemail', :as=>"associateemail"
  match 'associatepolicy' => 'inboundemails#associatepolicy'
  match 'associateclient' => 'inboundemails#associateclient'
  match 'associatesubmission' => 'inboundemails#associatesubmission'

  resources :agencies
  resources :cashtransactions
  resources :reports
  devise_for :agents, :path_prefix => 'd'
  resources :agent
  resources :agents

  devise_for :underwriters, :path_prefix => 'd'
  resources :underwriters

  devise_for :admins

  resources :applications
  resources :lineofbusinesses do
    resources :fees do
      resources :lobfees
    end
  end
  resources :fees
  resources :lobfees
  resources :dashboardlanding


  get "xmltests/testpage"

  get "home/index"
  get "/pricing" => "home#pricing"
  get "greetings/hello"
  get "greetings/goodbye"
  get "dashboardlanding/bindlinkWelcome"
  get "submission_applications/new"
  get "invoices/index"
  get "/dashbardlanding/policycountchart" => "dashboardlanding#policycountchart"
  get "/dashbardlanding/commissionchart" => "dashboardlanding#commissionchart"
  get "/dashbardlanding/premiumfornonwcmonthly" => "dashboardlanding#premiumfornonwcmonthly"
  get "/dashbardlanding/premiumforwcmonthly" => "dashboardlanding#premiumforwcmonthly"
  get "/dashbardlanding/activepolcntbycarrier" => "dashboardlanding#activepolcntbycarrier"

  as :agent do
    get "/login" => "devise/sessions#new"
    get "/d/agents/sign_out" => "devise/sessions#destroy"

  end

  as :underwriter do
    get "/login" => "devise/sessions#new"
    get "/d/underwriters/sign_out" => "devise/sessions#destroy"
  end

  as :admin do
    get "/login" => "devise/sessions#new"
    get "/admins/sign_out" => "devise/sessions#destroy"
  end


  match '/welcome' => "dashboardlanding#bindlinkWelcome", :as => :agent_root
  match '/welcome' => "dashboardlanding#bindlinkWelcome", :as => :underwriter_root
  match '/welcome' => "dashboardlanding#bindlinkWelcome", :as => :admin_root

  match 'edit_agent' => 'agent#edit'
  match 'edit_underwriter' => 'underwriters#edit'
  match 'edit_quotingentity' => 'quotingentities#edit'
  match 'disableagent/:id' => 'agents#disableagent', :as=>"disableagent"
  match 'enableagent/:id' => 'agents#enableagent', :as=>"disableagent"

  match 'next_step' => 'submissions#selectedclient'
  match 'create_conversation' => 'conversations#createconversation'



  match 'create_appointment' => 'appointments#createnew'
  match 'view_submission' => 'submissions#view'
  match 'create_post' => 'conversations#createsubmissionpost'
  match 'createfollowup_post' => 'conversations#createsubmissionpostfollowup'
  match 'pricing' => 'home#pricing'

  match 'create_invoice_policy' => 'invoices#createfrompolicy'




  match 'show_invoice_table' => 'invoices#invoicetable'
  match 'invoice_home' => 'invoices#show'
  match 'view_invoice' => 'invoices#view'



  match 'enter_cash'  => 'invoices#entercash'
  match 'create_cash_transaction_invoice/:id' => 'cashtransactions#createfrominvoice', :as=>'create_cash_transaction_invoice'
  match 'create_cash_transaction_bulk' => 'cashtransactions#createfrombulk'
  match '/cashtransactions/bulkentry' => 'cashtransactions#show'
  match 'bulkcash' => 'cashtransactions#entercash'
  match 'enternsf' => 'cashtransactions#enternsf'
  match 'transfercash/:id' => 'cashtransactions#transfercash', :as=>'transfercash'
  match 'cashtransactions/voidpayment/:id' => 'cashtransactions#voidpayment', :as=>'voidpayment'
  match 'processtransfercash' => 'cashtransactions#processtransfercash'
  match 'cashtransactions/returnlist/:id' => 'cashtransactions#returnlist', :as => 'returnlist'
  match 'cashtransactions/compaylist/:id' => 'cashtransactions#compaylist', :as => 'compaylist'
  match 'returnhome' => 'cashtransactions#returnhome'
  match 'compayhome' => 'cashtransactions#compayhome'
  match 'createreturnbatch' => 'cashtransactions#createreturnbatch'
  match 'createcompaybatch' => 'cashtransactions#createcompaybatch'
  match 'cashtransactions/:id/selectedreturn' => 'cashtransactions#selectedreturn',  :as => 'selectedreturn'
  match 'cashtransactions/:id/processreturn' => 'cashtransactions#processreturn',  :as => 'processreturn'
  match 'cashtransactions/returnpremium/:id' =>'cashtransactions#returnpremium', :as => 'returnpremium'
  match 'cashtransactions/paycompay/:id' =>'cashtransactions#paycompay', :as => 'paycompay'
  match 'cashtransactions/viewreturnbatch/:id' => 'cashtransactions#viewreturnbatch', :as => 'viewreturnbatch'
  match 'cashtransactions/viewreturnbatchpre/:id' => 'cashtransactions#viewreturnbatchpre', :as => 'viewreturnbatchpre'
  match 'cashtransactions/:id/printreturncheck' => 'cashtransactions#printreturncheck',  :as => 'printreturncheck'
  match 'cashtransactions/:id/printcompaycheck' => 'cashtransactions#printcompaycheck',  :as => 'printcompaycheck'
  match 'create_producingagency' => 'producingagencies#new'
  match 'producingagencies/booktransfer/:id' => 'producingagencies#booktransfer', :as=> 'booktransfer'
  match 'producingagencies/updatebooktransfer/:id' => 'producingagencies#updatebooktransfer', :as=> 'updatebooktransfer'

  match 'cashtransactions/processcompaybatch/:id' => 'cashtransactions#processcompaybatch',  :as=> 'processcompaybatch'
  match 'cashtransactions/processreturnbatch/:id' => 'cashtransactions#processreturnbatch',  :as=> 'processreturnbatch'

  match 'cashtransactions/retprintsuccess/:id' => 'cashtransactions#retprintsuccess' , :as=> 'retprintsuccess'
  match 'cashtransactions/editreturnbatch/:id' => 'cashtransactions#editreturnbatch', :as=>'editreturnbatch'
  match 'cashtransactions/printinvoicesunprocessed/:id' => 'cashtransactions#printinvoicesunprocessed', :as=>'printinvoicesunprocessed'
  match 'cashtransactions/printinvoicesprocessed/:id' => 'cashtransactions#printinvoicesprocessed', :as=>'printinvoicesprocessed'
  match 'cashtransactions/deletereturnpremiumbatch/:id' => 'cashtransactions#deletereturnpremiumbatch', :as=>'deletereturnpremiumbatch'
  match 'cashtransactions/editreturncheck/:id' => 'cashtransactions#editreturncheck', :as=>'editreturncheck'
  match 'cashtransactions/updatereturncheck/:id' => 'cashtransactions#updatereturncheck', :as=>'updatereturncheck'
  match 'cashtransactions/printsinglereturncheck/:id' => 'cashtransactions#printsinglereturncheck', :as=>'printsinglereturncheck'

  match 'cashtransactions/viewcompaybatch/:id' => 'cashtransactions#viewcompaybatch', :as => 'viewcompaybatch'
  match 'cashtransactions/viewcompaybatchpre/:id' => 'cashtransactions#viewcompaybatchpre', :as => 'viewcompaybatchpre'
  match 'cashtransactions/compayprintsuccess/:id' => 'cashtransactions#compayprintsuccess' , :as=> 'compayprintsuccess'
  match 'cashtransactions/editcompaybatch/:id' => 'cashtransactions#editcompaybatch', :as=>'editcompaybatch'
  match 'cashtransactions/editcompaycheck/:id' => 'cashtransactions#editcompaycheck', :as=>'editcompaycheck'
  match 'cashtransactions/updatecompaycheck/:id' => 'cashtransactions#updatecompaycheck', :as=>'updatecompaycheck'
  match 'cashtransactions/printsinglecompaycheck/:id' => 'cashtransactions#printsinglecompaycheck', :as=>'printsinglecompaycheck'
  match 'cashtransactions/unearnedcommissionpay/:id' => 'cashtransactions#unearnedcommissionpay', :as=>'unearnedcommissionpay'
  match 'cashtransactions/enterunearnedcommcheck/:id' => 'cashtransactions#enterunearnedcommcheck', :as=>'enterunearnedcommcheck'
  match 'accounting_home' =>'accounting#show'





  #policy matches
  match 'flag_policy/:id' => 'policies#flag_policy', :as =>'flag_policy'
  match 'flag_policy_process/:id' => 'policies#flag_policy_process', :as =>'flag_policy_process'
  match 'flag_policy_remove/:id' => 'policies#flag_policy_remove', :as =>'flag_policy_remove'
  match 'autoxml/:id' => 'policies#autoxml', :as=>'autoxml'
  match 'createpolicydoc/:id' => 'policies#createpolicydoc' , :as=>'create_policydoc'
  match 'newpolicylanding' => 'policies#newpolicylanding'
  match 'cancel_new_policy' =>'policies#show'
  match 'policy_home'  => 'policies#show'
  match 'view_policy'  => 'policies#view'
  match '/policies/show/:id' => 'policies#view'
  match 'existing_client_policy' => 'policies#selectexisting'
  match 'existing_prospect_policy' => 'policies#selectprospect'
  match 'create_client_policy' => 'policies#createclient'
  match 'create_invoice' => 'policies#createinvoice'
  match 'existing_client' => 'policies#existingclient'
  match 'create_client' => 'policies#clientform'
  match 'existing_prospect' => 'policies#existingprospect'
  match 'existing_producingagency_policy' => 'policies#selectproducingagency'
  match 'flatcancel_policy/:id' => 'policies#flatcancel', :as =>"flatcancel_policy"
  match 'cancel_policy/:id' => 'policies#cancel', :as =>"cancel_policy"
  match 'cancelled_policy_transactions/:id' => 'policies#canceltransactions', :as=>"canceltransactions"
  match 'cancelled_policy_transactions_simple/:id' => 'policies#canceltransactionssimple', :as=>"canceltransactionssimple"
  match 'reinstate_policy/:id' => 'policies#reinstate', :as=>"reinstate_policy"
  match 'reinstate_policy_transactions/:id' => 'policies#reinstatementtransactions' , :as=>"reinstatetransactions"
  match 'renew_policy/:id' => 'policies#renew', :as=>"renew_policy"
  match 'agentofrecordchange/:id' => 'policies#agentofrecordchange', :as=>"agentofrecordchange"
  match 'updateagentofrecord/:id' => 'policies#updateagentofrecord' , :as=>"updateagentofrecord"
  match 'editcommissionrate/:id' => 'policies#editcommissionrate', :as=>'editcommissionrate'
  match 'updatecommissionrate/:id' => 'policies#updatecommissionrate', :as=>'updatecommissionrate'

  match 'nonrenew/:id' => 'policies#nonrenew', :as=>"nonrenew"
  match 'updatenonrenew/:id' => 'policies#updatenonrenew', :as=>"updatenonrenew"
  match 'pendingcancellation/:id' => 'policies#pendingcancellation', :as=>"pendingcancellation"
  match 'updatependingcancellation/:id' => 'policies#updatependingcancellation', :as=>"updatependingcancellation"
  match 'upload_document/:id' => 'policies#documentupload', :as=>"documentupload"
  match 'endorse_policy/:id' => 'policies#endorse', :as=>"endorse_policy"
  match 'renew_policy_transactions' => 'policies#createrenew'
  match 'endorsed_policy_transactions/:id' => 'policies#endorsetransactions', :as=>"endorsetransactions"
  match 'pay_carrier/:id' => 'policies#paycarrier', :as=>"pay_carrier"
  match 'pay_carrier_transactions/:id' => 'policies#paycarriertransactions' , :as=>"pay_carrier_transactions"
  match 'apply_cash_invoice/:id' => 'policies#applycashtoinvoice', :as=>"apply_cash_invoice"
  match 'view_invoice_history' => 'policies#viewinvoicehistory'
  match 'hide_invoice_history' => 'policies#hideinvoicehistory'
  match 'printinvoice/:id' => 'policies#printinvoice'
  match 'printcertificate/:id' => 'policies#printcertificate'
  match 'create_note' => 'policies#createnote'
  match 'newquotepolicy/:id' => 'policies#newquotepolicy', :as=>"newquotepolicy"
  match 'newquotepolicyga/:id' => 'policies#newquotepolicyga', :as=>"newquotepolicyga"
  match 'newpolicyga' => 'policies#newpolicyga'
  match 'renewal' => 'policies#renewal'
  match 'agedinvoices' => 'policies#agedinvoices'
  #end policy matches

  #accord apps
  match 'acord_pdf90fl/:id' => 'clients#clientname'



  #end accord apps




  #prospect matches
  match 'create_prospect' => 'clients#createprospect'
  match 'new_prospect' => 'clients#newprospect'
  match 'prospect_home' => 'clients#prospectindex'
  match 'show_prospect/:id' => 'clients#showprospect' , :as=>"showprospect"
  match 'edit_sales_stage/:id' => 'clients#editsalesstage' , :as=>"editsalesstage"
  match 'updatesalesstage/:id' => 'clients#updatesalesstage', :as=>"updatesalesstage"
  match 'createclientdoc/:id' => 'clients#clientcreatedocument', :as=>"createclientdoc"
  #### OLDER delete soon
  match 'prospects_home' => 'prospects#show'
  match 'view_prospect' => 'prospects#view'
  match 'edit_prospect' => 'prospects#edit'
  match 'process_edit_prospect' => 'prospects#processedit'
  match 'convert_prospect' => 'prospects#convert'

  #end prospect matches


  #producingagency matches

  match 'editprospectgeneral/:id' => 'producingagencies#editgeneral', :as=>"editproducinggeneral"
  match 'newproducingagencypolicy/:id' => 'policies#newpolicyga', :as=>"newproducingagencypolicy"
  match 'createproducingagencydoc/:id' => 'producingagencies#createproducingagencydoc', :as=>"createproducingagencydoc"

  #end



  #quote matches
  match 'createquotedoc/:id' => 'quotes#createquotedocument', :as=>"createquotedoc"

  #end quote matches

  #submission matches

  match 'createsubmissiondoc/:id' => 'submissions#createsubmissiondocument', :as=>"createsubmissiondoc"

  #end submission matches


  #carrier matches

  match 'create_carrier_policy' => 'carriers#createfrompolicy'
  match 'lob_view' => 'carriers#lobview'
  match 'add_commission' => 'carriers#addcommission'
  match 'deletelob' => 'carriers#deletelob'
  match 'editlobcommission' => 'carriers#editlob'
  match 'disablelobcommission/:id' => 'lobcommissions#disablelob', :as=>"disablelobcommission"
  match 'enablelobcommission/:id' => 'lobcommissions#enablelob', :as=>"enablelobcommission"
  match 'process_edit_comm' => 'carriers#processeditlobcomm'
  #end carrier matches

  #pfc matches

  match 'edit_pfc/:id' => 'pfcs#edit', :as => 'edit_pfc'
  match 'process_edit_pfc/:id' => 'pfcs#processedit' , :as=>'process_edit_pfc'
  #end pfc matches

  #lob matches
  match 'lob_home' => 'lineofbusinesses#show'
  match 'create_lob' => 'lineofbusinesses#new'
  match 'view_lob' => 'lineofbusinesses#view'
  match 'edit_lob' => 'lineofbusinesses#edit'
  match 'process_edit_lob' => 'lineofbusinesses#processedit'
  match 'associate_fee_to_lob' => 'lineofbusinesses#associatefee'
  match 'delete_fee_association' => 'lineofbusinesses#deletefeeassociation'
  #end lob matches



  # reports matches
  get 'cashreport' => 'reports#cashreport'
  get 'policylistingreport' => 'reports#policylistingreport'
  get 'accountingreport' => 'reports#accountingreport'
  match 'aragingreport' => 'reports#agingreport', :as=>'aragingreport'
  match 'aragingreportpdf' => 'reports#agingreportpdf', :as=>'aragingreportpdf'
  match 'aragingreportxls' => 'reports#agingreportxls', :as=>'aragingreportxls'
  match 'returnreport' => 'reports#returnreport', :as=>'returnreport'
  match 'returnreportpdf' => 'reports#returnreportpdf', :as=>'returnreportpdf'
  match 'returnreportinvoices' => 'reports#returnreportinvoices', :as=>'returnreportinvoices'
  match 'feesreport' => 'reports#feesreport'
  match 'surpluslinesreport' => 'reports#surpluslinesreport', :as=>'surpluslinesreport'
  match 'surpluslinesreportauto' => 'reports#surpluslinesreportauto', :as=>'surpluslinesreportauto'
  match 'commissionreport' => 'reports#commissionreport', :as=>'commissionreport'
  match 'expirationreport' => 'reports#expirationreport', :as=>'expirationreport'
  match 'renewalreport' => 'reports#renewalreport', :as=>'renewalreport'
  match 'incomereport' => 'reports#incomereport', :as=>'incomereport'
  match '/reportbackground' , :to => redirect('/reportbackground.html')
  match 'producerrpt' => 'reports#producerrpt'
  #end reports



  #searches
  match '/searches/findpolicy' => 'searches#findpolicy'
  match '/searches/findpolicyreco' => 'searches#findpolicyreco'
  match '/searches/finduniversal' => 'searches#finduniversal'
  match '/searches/findpolicytransfer' => 'searches#findpolicytransfer'
  match '/searches/findtoassociateemail/:id' => 'searches#findtoassociateemail',:as=>'findtoassociateemail'
  #end searches



  #task matches

  match '/tasks/completetask/:id' => 'tasks#completetask', :as =>'completetask'
  match '/tasks/newtaskreply/:id' => 'tasks#newtaskreply', :as =>'newtaskreply'
  match '/tasks/createreply/:id' => 'tasks#createreply' , :as=>'createreply'
  match '/tasks/taskview/:type' => 'tasks#taskview' , :as=>'taskview'
  match '/tasks/taskview/:type/:agent' => 'tasks#taskview' , :as=>'taskview'
  #end task


  #autopolicy matches
  match '/acord_xml_pers_auto_policies/associatevehdrv/:id' => 'acord_xml_pers_auto_policies#associatevehdrv', :as=>'associatevehdrv'



  #marketing

  resources :marketing
  get '/contact'  => 'marketing#contact', :as=>'contact'
  get '/features' => 'marketing#features', :as=>'features'
  get '/contactthanks' => 'marketing#contactthanks', :as=>'contactthanks'
  match '/marketing/contactform' => 'marketing#contactform', :as=>'contactform'

  #renewal web service

  get '/gic/renewalwebservice/:key/:policy_id' => 'renewalservice#getrenewaldetails'

  #payment web service

  get '/gic/paymentwebservice/:key/:policy_id' => 'paymentservice#getpolicyinvoices'

  #payment web service

  get '/gic/gicwebpolicyservice/:key/:agency_code' => 'gicwebpolicyservice#getactivepolicies'
  get '/gicwebpolicyservice/:key/:agency_code' => 'gicwebpolicyservice#getactivepoliciessinglequery'
  get '/gicwebdocservice/:key/:id' => 'gicwebpolicyservice#getdocument'

end
