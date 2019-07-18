require 'open-uri'
require_relative 'lib/reader'
require_relative 'lib/repo/parser'
require_relative 'lib/repo/searcher'
require_relative 'lib/reader'
require_relative 'lib/table'
# rubocop:disable Naming/VariableNumber
options = Reader::Shell.new.load_parameters
gem_names = Reader::File.new(options[:file]).read
client = Octokit::Client.new(access_token: ENV['KEY_TOKEN'])
repos = gem_names.map do |gem_name|
  Repo::Searcher.call(gem_name: gem_name, client: client)
end
parsed_data = repos.map do |repo|
  Repo::Parser.new(repo: repo).parse
end
filter_repos = parsed_data.select { |hash| hash[:name] =~ /#{options[:name]}/ }
sorted_repos = filter_repos.sort do |repo_1, repo_2|
  repo_1[:used_by] <=> repo_2[:used_by]
end
sorted_repos = sorted_repos.take(options[:top].to_i) if options[:top]
table = Table::Printer.create(sorted_repos: sorted_repos)
puts table
# rubocop:enable Naming/VariableNumber
