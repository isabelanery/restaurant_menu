namespace :import do
  desc 'Import restaurant data from JSON file'
  task :json, [:file_path] => :environment do |_t, args|
    file_path = args[:file_path]
    abort('Usage: rake import:json[file_path]') if file_path.blank?

    begin
      file_content = File.read(file_path)
    rescue Errno::ENOENT => e
      abort("File not found: #{file_path} - #{e.message}")
    rescue StandardError => e
      abort("Error reading file: #{e.message}")
    end

    importer = JsonImporter.new(file_content)
    result = importer.call

    puts "Success: #{result[:success]}"
    puts 'Logs:'
    result[:logs].each { |log| puts "- #{log}" }
  end
end
