class Admin::CardsController < AdminController

  def index
    @cards = DataCard.all
    @card = DataCard.new
  end

  def show
    @card = DataCard.find(params[:id])
  end

  def new
    @card = DataCard.new
  end

  def edit
    @card = DataCard.find(params[:id])
  end

  def create
    @card = DataCard.new(params[:data_card])
    @card.csv = File.open(params[:data_card][:csv_file].tempfile.path).read

    if @card.save
      flash[:notice] = "Card saved."
      redirect_to admin_cards_path
    else
      flash[:error] = "There was a problem saving the card."
      redirect_to admin_cards_path
    end
  end

  def update
    @card = DataCard.find(params[:id])
    if @card.update_attributes(params[:data_card])
      flash[:notice] = "Card updated."
      redirect_to edit_admin_card_path(@card)
    else
      flash[:error] = "There was a problem saving the card."
      redirect_to edit_admin_card_path(@card)
    end
  end

  def destroy
    @card = DataCard.find(params[:id])
    @card.destroy
    redirect_to admin_cards_path
  end

end
