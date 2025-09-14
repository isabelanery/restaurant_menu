require 'rails_helper'
require 'rake'

RSpec.describe 'import:json', type: :task do
  let(:valid_json) do
    {
      'restaurants' => [
        {
          'name' => 'Test Restaurant',
          'menus' => [
            {
              'name' => 'lunch',
              'menu_items' => [
                { 'name' => 'Burger', 'price' => 10.0 }
              ]
            }
          ]
        }
      ]
    }
  end

  let(:malformed_json) { '{ malformed json' }

  before do
    Rake::Task.clear
    Rails.application.load_tasks
  end

  describe 'import:json task' do
    describe 'input validation' do
      context 'when file path is missing' do
        it 'aborts with usage message' do
          $stderr = StringIO.new
          expect do
            Rake::Task['import:json'].invoke
          end.to raise_error(SystemExit, /Usage: rake import:json\[file_path\]/)
        ensure
          $stderr = STDERR
        end
      end

      context 'when file does not exist' do
        let(:non_existent_path) { Rails.root.join('tmp/non_existent.json') }

        it 'aborts with file not found message' do
          $stderr = StringIO.new
          expect do
            Rake::Task['import:json'].invoke(non_existent_path.to_s)
          end.to raise_error(SystemExit, /File not found: #{non_existent_path}/)
        ensure
          $stderr = STDERR
        end
      end
    end

    describe 'file processing' do
      let(:file_path) { Rails.root.join('tmp', "test_#{SecureRandom.hex(8)}.json") }

      before do
        Rails.root.join('tmp').mkdir unless Rails.root.join('tmp').exist?
      end

      after do
        FileUtils.rm_f(file_path)
      end

      context 'with valid JSON file' do
        let(:importer) { instance_double(JsonImporter, call: { success: true, logs: ['Imported item "Burger"'] }) }

        before do
          File.write(file_path, valid_json.to_json)
          allow(JsonImporter).to receive(:new).with(valid_json.to_json).and_return(importer)
          Rake::Task['import:json'].reenable
        end

        it 'calls JsonImporter with file content' do
          expect(JsonImporter).to receive(:new).with(valid_json.to_json).and_return(importer)
          expect(importer).to receive(:call).and_return({ success: true, logs: ['Imported item "Burger"'] })
          $stdout = StringIO.new
          Rake::Task['import:json'].invoke(file_path)
        ensure
          $stdout = STDOUT
        end

        it 'outputs the results correctly' do
          expected_output = /Success: true\nLogs:\n- Imported item "Burger"\n/
          expect do
            Rake::Task['import:json'].invoke(file_path)
          end.to output(expected_output).to_stdout
        end

        context 'when JsonImporter returns failure' do
          let(:importer) do
            instance_double(JsonImporter, call:
          { success: false, logs: ['Failed to import item "Burger"'] })
          end

          before do
            allow(JsonImporter).to receive(:new).with(valid_json.to_json).and_return(importer)
            Rake::Task['import:json'].reenable
          end

          it 'outputs the results correctly for failed import' do
            expected_output = /Success: false\nLogs:\n- Failed to import item "Burger"\n/
            expect do
              Rake::Task['import:json'].invoke(file_path)
            end.to output(expected_output).to_stdout
          end
        end
      end

      context 'with malformed JSON file' do
        before do
          File.write(file_path, malformed_json)
        end

        it 'raises a JSON parse error' do
          $stdout = StringIO.new
          expect do
            Rake::Task['import:json'].invoke(file_path)
          end.to raise_error(JSON::ParserError)
        ensure
          $stdout = STDOUT
        end
      end
    end
  end
end
