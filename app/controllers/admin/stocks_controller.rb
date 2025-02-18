class Admin::StocksController < AdminController
  before_action :set_admin_stock, only: %i[ show edit update destroy ]
  before_action :set_product, only: %i[ index new create edit update ]

  # GET /admin/stocks or /admin/stocks.json
  def index
    @admin_stocks = @product.stocks
  end

  # GET /admin/stocks/1 or /admin/stocks/1.json
  def show
  end

  # GET /admin/stocks/new
  def new
    @admin_stock = @product.stocks.build
  end

  # GET /admin/stocks/1/edit
  def edit
  end

  # POST /admin/stocks or /admin/stocks.json
  def create
    @admin_stock = @product.stocks.build(admin_stock_params)
    if @admin_stock.save
      redirect_to admin_product_path(@product), notice: 'Stock was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/stocks/1 or /admin/stocks/1.json
  def update
    respond_to do |format|
      if @admin_stock.update(admin_stock_params)
        format.html { redirect_to admin_product_stock_path(@admin_stock.product, @admin_stock), notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: admin_product_stock_path(@admin_stock.product, @admin_stock) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/stocks/1 or /admin/stocks/1.json
  def destroy
    @admin_stock.destroy!

    respond_to do |format|
      format.html { redirect_to admin_stocks_path, status: :see_other, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_stock
      @admin_stock = Stock.find(params[:id])
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    # Only allow a list of trusted parameters through.
    def admin_stock_params
      params.require(:stock).permit(:amount, :size)
    end
end
