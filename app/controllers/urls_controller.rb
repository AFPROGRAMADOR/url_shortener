class UrlsController < ApplicationController
  before_action :set_url, only: %i[ show update destroy ]

  # GET /urls
  def index
    @urls = Url.order(visits: :desc).limit(100)
    render json: @urls
  end

  # GET /urls/1
  def show
    render json: @url
  end

  # POST /urls
  def create
    @url = Url.new(url_params)
    if @url.save
      render json: @url, status: :created
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /urls/1
  def update
    if @url.update(url_params)
      render json: @url
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  # DELETE /urls/1
  def destroy
    @url.destroy!
  end

  def redirect
    @url = Url.find_by(url_shortener: params[:url_shortener])
    if @url
      redirect_to @url.url_original, status: :moved_permanently, allow_other_host: true
      @url.increment!(:visits)
    else
      render plain: "URL no disponible para redirigir"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def url_params
      params.require(:url).permit(:url_original)
    end
end
