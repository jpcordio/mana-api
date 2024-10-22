class Api::V1::ConnectionsController < ApplicationController
  before_action :set_connection, only: [:show, :update, :destroy]
  include DeviseTokenAuth::Concerns::User

  before_action :authenticate_api_user!

  # GET /connections
  # def index
  #   @connections = Connection.all

  #   render json: @connections
  # end
  def index
    if current_user.customer?
      companies = current_user.followed_companies
      render json: companies, status: :ok
    else
      render json: { message: "You are not authorized to view this content." }, status: :forbidden
    end
  end

  # GET /connections/1
  def show
    render json: @connection
  end

  # POST /connections
  # def create
  #   company = User.find(params[:company_id])

  #   if current_user.customer? && company.company?
  #     current_user.followed_companies << company
  #     redirect_to company_path(company), notice: "You are now following #{company.name}."
  #   else
  #     redirect_to root_path, alert: "You can only follow companies as a customer."
  #   end
  # end

  def create
    company = User.find(params[:company_id])

    if current_user.customer? && company.company?
      connection = current_user.connections_as_customer.build(company: company)

      if connection.save
        render json: { message: "You are now following #{company.name}." }, status: :created
      else
        render json: { errors: connection.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "You can only follow companies as a customer." }, status: :forbidden
    end
  end

  # PATCH/PUT /connections/1
  # def update
  #   if @connection.update(connection_params)
  #     render json: @connection
  #   else
  #     render json: @connection.errors, status: :unprocessable_entity
  #   end
  # end
  def update
    connection = Connection.find(params[:id])

    if connection.customer == current_user
      if connection.update(connection_params)
        render json: { message: "Connection updated successfully." }, status: :ok
      else
        render json: { errors: connection.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "You are not authorized to update this connection." }, status: :forbidden
    end
  end

  # DELETE /connections/1
  def destroy
    company = User.find(params[:company_id])
    current_user.followed_companies.delete(company)
    redirect_to company_path(company), notice: "You have unfollowed #{company.name}."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connection
      @connection = Connection.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def connection_params
      params.require(:connection).permit(:customer_id, :company_id)
      params.require(:connection).permit(:notification_enabled)  # Exemplo de parâmetro que pode ser atualizado
    end
end
