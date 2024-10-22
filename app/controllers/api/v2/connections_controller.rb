class Api::V2::ConnectionsController < ApplicationController
  before_action :set_connection, only: [:show, :update]
  #before_action :authenticate_api_user!


  # GET /connections
  # def index
  #   @connections = Connection.all

  #   render json: @connections
  # end
  def index
    if current_api_user.customer?
      companies = current_api_user.followed_companies
      render json: companies, status: :ok
    else
      render json: { message: "You are not authorized to view this content." }, status: :forbidden
    end
  end

  # GET /connections/1
  #   def show
  #     render json: @connection
  #   end

  def following_company
    # Check user table the user with role == true (company)
    company = User.find_by(id: params[:company_id], role: true)

    if company.nil?
      render json: { error: "Empresa não encontrada" }, status: :not_found
      return
    end

    # check the relationship on the connection
    connection = Connection.find_by(customer_id: current_api_user.id, company_id: company.id)

    # check if the relation exist
    if connection
      render json: { following: true, company: company.name }
    else
      render json: { following: false, company: company.name }
    end
  end

  def create
    company = User.find(params[:company_id])

    if current_api_user.customer? && company.company?
      connection = current_api_user.connections_as_customer.build(company: company)

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
    if @connection.customer == current_api_user
      if @connection.update(connection_params)
        render json: { message: "Connection updated successfully." }, status: :ok
      else
        render json: { errors: @connection.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "You are not authorized to update this connection." }, status: :forbidden
    end
  end

  # DELETE /connections/1
  def destroy
    company = User.find(params[:company_id])

    # Encontra a conexão entre o usuário atual (customer) e a empresa
    connection = current_api_user.connections_as_customer.find_by(company: company)

    if connection
      connection.destroy
      render json: { message: "You have unfollowed #{company.name}." }, status: :ok
    else
      render json: { message: "Connection not found or already unfollowed." }, status: :not_found
    end
  end

  private

  def set_connection
    @connection = Connection.find(params[:id])
  end

  def connection_params
    params.require(:connection).permit(:notification_enabled)
  end
end
