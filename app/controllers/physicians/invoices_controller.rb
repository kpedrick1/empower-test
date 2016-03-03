class Physicians::InvoicesController < Physicians::ApplicationController

  layout 'physicians'


  def index


    @oppId = params[:oppId]

    puts "\n\n"
    puts @oppId
    puts "\n\n"

  end

  def create

    redirect_to '/physicians/orderhistories'

  end

end