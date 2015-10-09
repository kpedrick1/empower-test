class Physicians::InventoriesController < Physicians::ApplicationController

  # layout "physicians"
  #
  #
  # def index
  #   #get inventory from salesforce
  #
  #   get_inventory_salesforce
  #
  # end
  #
  # def create
  #   #send data to salesforce endpoint
  #
  #   puts '\n'
  #   puts '\n'
  #   puts '-----------------create called -------------------------'
  #   puts params.inspect
  #   puts '\n'
  #   puts '\n'
  #
  #   client = Restforce.new
  #
  #   args = Hash.new
  #   args["username"] = session[:account_id]
  #   args["order"] = params[:inventory]
  #
  #   result = client.post '/services/apexrest/portal/OrderInventory/', :userid => session[:account_id], :par => params
  #
  #
  #
  #
  #   redirect_to action: "index"
  #
  # end
  #
  # def show
  #   render layout: false
  # end
  #
  #
  # def get_inventory_salesforce
  #
  #   account_id = session[:account_id]
  #
  #   client = Restforce.new
  #
  #   result = client.get '/services/apexrest/portal/Inventory/', :username => account_id
  #
  #   @inventory = result.body.portalInventoryRowList
  #
  #   @grandTotal = result.body.grandTotal
  #
  #
  # end


end