module Api
  class ImportRestaurantsController < ApplicationController
    def create
      json_data = JSON.parse(request.body.read)
      importer = JsonImporter.new(json_data)
      result = importer.call

      render json: { success: result[:success], logs: result[:logs] }, status: :ok
    rescue JSON::ParserError => e
      render json: { success: false, logs: ["Invalid JSON: #{e.message}"] }, status: :bad_request
    rescue StandardError => e
      render json: { success: false, logs: ["Error: #{e.message}"] }, status: :internal_server_error
    end
  end
end
