class CustomdocumentsController < ApplicationController
  before_filter :login_marshall

  def showcustomdocument
    @customdocs = Customdocument.find(params[:id])
    @policy = Policy.find(params[:policy_id])

    respond_to do |format|
      format.pdf do
        datetime = DateTime.now
        pdf = CustomdocGenerator.new(@customdocs, current_agent.generalagency_id, @policy)
        customdocument = pdf.render
        send_data customdocument, filename: "customdoc_#{datetime.to_s(:number)}.pdf",
                  type: "application/pdf",
                  disposition: "inline"

        file = StringIO.new(customdocument)
        file.class.class_eval {attr_accessor :original_filename, :content_type}
        file.original_filename = @customdocs.file_name.to_s
        file.content_type = "application/pdf"

        @document = Document.new
        @document.policy_id = @policy.id
        @document.name = @customdocs.document_name
        @document.generalagency_id = current_agent.generalagency_id
        @document.image = file
      end
    end
  end
end