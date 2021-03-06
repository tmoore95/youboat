class ListingsController < ApplicationController
  def index
    if params[:query].present?
      @listings = Listing.global_search(params[:query])
      @current_user = current_user
      @markers = @listings.geocoded.map do |listing|
        {
          lat: listing.latitude,
          lng: listing.longitude,
          info_window: render_to_string(partial: "info_window", locals: { listing: listing }),
          image_url: helpers.asset_url('https://svgsilh.com/svg/153812.svg')
        }
      end
    else
      @listings = Listing.all
      @current_user = current_user
      @markers = @listings.geocoded.map do |listing|
        {
          lat: listing.latitude,
          lng: listing.longitude,
          info_window: render_to_string(partial: "info_window", locals: { listing: listing }),
          image_url: helpers.asset_url('https://svgsilh.com/svg/153812.svg')
        }
      end
    end
  end

  def show
    @listing = Listing.find(params[:id])
    @review = Review.new
    @current_user = current_user
    @marker = [{
      lat: @listing.latitude,
      lng: @listing.longitude,
      info_window: render_to_string(partial: "info_window", locals: { listing: @listing }),
      image_url: helpers.asset_url('https://svgsilh.com/svg/153812.svg')
    }]
  end
  
  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.user_id = current_user.id
    if @listing.save
      redirect_to @listing
    else
      render :new
    end
  end

  def edit
    @listing = Listing.find(params[:id])
  end

  def update
    @listing = Listing.find(params[:id])
    if @listing.update(listing_params)
      redirect_to @listing
    else
      render :edit
    end
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    redirect_to root_path
  end

  private
  
  def listing_params
    params.require(:listing).permit(:name, :location, :craft_type, :price_per_day, :photo)
  end
end
