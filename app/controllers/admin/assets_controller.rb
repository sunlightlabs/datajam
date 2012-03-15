class Admin::AssetsController < AdminController

  def index
    @assets = Asset.all
    @asset = Asset.new
  end

  def show
    @asset = Asset.find(params[:id])
  end

  def new
    @asset = Asset.new
  end

  def edit
    @asset = Asset.find(params[:id])
  end

  def create
    @asset = Asset.new(params[:asset])
    if @asset.save
      flash[:success] = "Asset saved."
      previous = Asset.where(asset_filename: @asset.asset_filename)
      if previous.count > 1
        previous.first.destroy
        flash[:success] += " Previous version deleted."
      end
      redirect_to admin_assets_path
    else
      flash[:error] = "There was a problem creating saving the file."
      redirect_to admin_assets_path
    end
  end

  def update
    @asset = Asset.find(params[:id])
    if @asset.update_attributes(params[:asset])
      flash[:success] = "Asset updated."
      redirect_to admin_assets_path
    else
      flash[:error] = "There was a problem saving the site settings."
      redirect_to admin_assets_path
    end
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    redirect_to admin_assets_path
  end

end
