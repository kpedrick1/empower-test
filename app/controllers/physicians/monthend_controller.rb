class Physicians::MonthendController < Physicians::ApplicationController


  def index
    # get inventory from salesforce

    get_inventory_salesforce

  end

  protected

  def get_inventory_salesforce

    account_id = session[:account_id]

    client = Restforce.new

    result = client.get '/services/apexrest/portal/InventoryMonthEnd/', :username => account_id

    @inventory = result.body.portalInventoryRowList

    @grandTotal = result.body.grandTotal

    @accountName = result.body.accountName

    @monthName = result.body.monthName


  end


end