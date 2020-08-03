require 'fileutils'
require 'mime/types'

module Babbas
  class File
    class EmptyFileError < StandardError; end
    class UnrecognisedTypeError < StandardError; end

    VALID_TYPES = %w[jpeg gif png]

    attr_reader :params, :url

    def initialize(params)
      @params = params
      save_file
    end

    def url
      @url ||= [ENV['ENDPOINT_URL'].chomp('/'), file_path].join('/')
    end

    private

    def save_file
      validate
      return url if ::File.exist?(file_path)
      write_file
    end

    def write_file
      params[:file][:tempfile].rewind
      FileUtils.mkdir_p(::File.dirname(full_file_path))
      FileUtils.install(params[:file][:tempfile].path, full_file_path, mode: 0644)
    end

    def file_path
      @file_path ||= ::File.join([ENV['DATA_DIRECTORY'],
                                  file_name[0..1],
                                  "#{file_name}.#{extension}"].reject(&:empty?))
    end

    def full_file_path
      @full_file_path ||= ::File.join(ENV['ENDPOINT_BASE'], file_path)
    end

    def file_name
      @file_name ||= Digest::SHA256.hexdigest(params[:file][:tempfile].read)
    end

    def content_type
      @content_type ||= params[:file][:type]
    end

    def extension
      @extension ||= MIME::Types[content_type].first.preferred_extension
    end

    def validate
      raise MediaEndpoint::File::EmptyFileError if params.dig(:file, :tempfile).size.zero?
      raise MediaEndpoint::File::UnrecognisedTypeError, content_type unless VALID_TYPES.include?(extension)
    end
  end
end
