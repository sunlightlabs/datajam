class Admin::CardsController < AdminController

  def index
    @cards = DataCard.all
    @card = DataCard.new
    render_if_pjax 'admin/cards/_table'
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
    @card = DataCard.new(params[:card])

    if params[:card][:csv_file].present?
      @card.csv = File.open(params[:card][:csv_file].tempfile.path).read
    end

    if @card.save
      flash[:success] = "Card saved."
      redirect_to admin_cards_path
    else
      flash[:error] = "There was a problem saving the card."
      redirect_to admin_cards_path
    end
  end

  def update
    @card = DataCard.find(params[:id])
    if @card.update_attributes(params[:card])
      flash[:success] = "Card updated."
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
