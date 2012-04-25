class Admin::AssetsController < AdminController

  def index
    @assets = filter_and_sort Asset.all.order(:created_at => :asc)

    @asset = Asset.new
    render_if_ajax 'admin/assets/_table'
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
      flash[:error] = "There was a problem saving the asset."
      redirect_to admin_assets_path
    end
  end

  def update
    @asset = Asset.find(params[:id])
    if @asset.update_attributes(params[:asset])
      flash[:success] = "Asset updated."
      redirect_to admin_assets_path
    else
      flash[:error] = "There was a problem updating the asset."
      redirect_to admin_assets_path
    end
  end

  def destroy
    @asset = Asset.find(params[:id])
    if @asset.destroy
      flash[:success] = "Asset deleted."
    else
      flash[:error] = "There was a problem deleting the asset."
    end
    redirect_to admin_assets_path
  end

end
