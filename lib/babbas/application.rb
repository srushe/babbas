require 'indie_auth/token_verification'
require_relative 'file'

module Babbas
  class Application < Sinatra::Application
    set :public_folder, ::File.dirname(__FILE__) + '/../../static'

    get '/' do
      send_file ::File.join(settings.public_folder, 'index.html')
    end

    post '/' do
      verify_token('create')

      save_file
    end

    private

    def verify_token(scope=nil)
      access_token = request.env['HTTP_AUTHORIZATION'] || params['access_token'] || ''
      IndieAuth::TokenVerification.new(access_token).verify(scope)
    rescue IndieAuth::TokenVerification::AccessTokenMissingError
      send_error(status: 401, error: 'unauthorized', description: 'Access token missing or empty')
    rescue IndieAuth::TokenVerification::MissingDomainError
      send_error(status: 400, error: 'invalid_request', description: 'DOMAIN is not specified')
    rescue IndieAuth::TokenVerification::MissingTokenEndpointError
      send_error(status: 400, error: 'invalid_request', description: 'TOKEN_ENDPOINT is not specified')
    rescue IndieAuth::TokenVerification::ForbiddenUserError
      send_error(status: 403, error: 'forbidden', description: 'User does not have permission')
    rescue IndieAuth::TokenVerification::IncorrectMeError
      send_error(status: 401, error: 'insufficient_scope', description: 'The "me" value does match the expected DOMAIN')
    rescue IndieAuth::TokenVerification::InsufficentScopeError
      send_error(status: 401, error: 'insufficient_scope', description: 'The scope of this token does not meet the requirements for this request')
    end

    def send_error(status: 400, error: 'invalid_request', description:)
      json = {
        error: error,
        error_description: description
      }.to_json

      halt(status, { 'Content-Type' => 'application/json' }, json)
    end

    def save_file
      file = Babbas::File.new(params)

      status 201
      headers 'Location' => file.url
    rescue Babbas::File::EmptyFileError
      send_error(description: 'No saveable data was provided')
    rescue Babbas::File::UnrecognisedTypeError => e
      # TODO: Include list of valid types in error description.
      send_error(description: "An unrecognisable file type was provided (#{e})")
    end
  end
end
