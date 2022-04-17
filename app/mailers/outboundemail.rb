class Outboundemail < ActionMailer::Base


  def senddocument(from, email, subject, body, doc)

    doc.each do |d|
      document = Document.find(d)
      attachments[document.image_file_name] = open(document.authenticated_url()) {|f| f.read }
    end

    mail(:from=>from, :to => email, :subject => subject, :body => body)
  end

  def sendsimple(from, email, subject, body, doc)

    attachments['report.pdf'] = {
        mime_type: 'application/pdf',
        content: doc.render
    }

    mail(:from=>from, :to => email, :subject => subject, :body => body)
  end
  def sendinvoice(from, email, subject, body, policynumber ,doc)

    attachments['GICInvoice_'+ policynumber + '.pdf'] = {
        mime_type: 'application/pdf',
        content: doc.render
    }

    mail(:from=>from, :to => email, :subject => subject, :body => body)
  end

end
