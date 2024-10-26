class Api::V2::ProfileController < ApplicationController
  before_action :set_company, only: [:update_company]

  def show_company_by_user
    company = Company.find_by(company_id: params[:user_id]) # Corrigido para usar company_id

    if company
      render json: company
    else
      render json: { error: 'Company not found' }, status: :not_found
    end
  end

  def create_company
    # Verifica se a empresa já existe com o company_id
    existing_company = Company.find_by(company_id: params[:user_id])

    if existing_company
      render json: { message: 'Company already exists', company: existing_company }, status: :conflict
      return
    end

    # Criação da nova empresa
    @company = Company.new(company_params)
    @company.company_id = params[:user_id]

    if @company.save
      render json: { message: 'Company created successfully', company: @company }, status: :created
    else
      render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_company
    if @company.nil?
      render json: { error: 'Company not found' }, status: :not_found and return
    end

    if @company.update(company_params)
      render json: { message: 'Company updated successfully', company: @company }, status: :ok
    else
      render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_company
    Rails.logger.info("Attempting to find company with company_id: #{params[:id]}")
    @company = Company.find_by(company_id: params[:id]) # Usar company_id para buscar

    if @company.nil?
      Rails.logger.error("Company not found for company_id: #{params[:id]}")
    end
  end

  def company_params
    # Adicione todos os parâmetros necessários para a criação da empresa
    params.permit(:address1, :address2, :city, :county, :postcode, :country, :phone, :mobile, :website, :email)
  end
end
