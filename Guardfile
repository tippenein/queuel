# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

guard :cane do
  watch(%r{^app/.+\.(erb|haml|rhtml|rb)$})
  watch(%r{^lib/.+\.rb$})
end

guard 'rspec', rvm: ["2.0.0@postal_service", "rbx-2.0.0@postal_service", "1.9.3-p327@postal_service"], cli: "--format NyanCatFormatter" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
