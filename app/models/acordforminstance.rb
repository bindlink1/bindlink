class Acordforminstance < ActiveRecord::Base
  belongs_to :client


  def prepareacordform(formname)

    acordformbuilder = Acordformbuilder.new

    acordform = Acordform.find_by_form_name(formname)


    imageurls = getformimage(acordform)

    acordformbuilder.acordform = acordform
    acordformbuilder.formurls = imageurls

    acordformbuilder



  end


  def getformimage(acordform)

    formname = acordform.form_name
    imageurls = Array.new


    #acordform.numberofpages

    s3config = YAML.load_file("#{::Rails.root}/config/amazon_s3.yml")

    AWS.config(:access_key_id => s3config[::Rails.env]["access_key_id"], :secret_access_key => s3config[::Rails.env]["secret_access_key"])
    s3 = AWS::S3.new

    formbucket = s3.buckets['blforms']


    if acordform.numberofpages <= 1
      formimages = formbucket.objects["AcordForms/#{formname}.png"]
      imageurls << formimages.url_for(:read, :secure => true, :expires => 5.minutes).to_s
    else
      for i in 1..acordform.numberofpages


        formimages = formbucket.objects["AcordForms/#{formname}-#{i}.png"]

        imageurls << formimages.url_for(:read, :secure => true, :expires => 5.minutes).to_s


      end
    end




    imageurls


  end





end
