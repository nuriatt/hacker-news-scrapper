# frozen_string_literal: true

require 'nokogiri'
require 'httparty'

response = HTTParty.get('https://news.ycombinator.com/')
document = Nokogiri::HTML(response.body)

Entry = Struct.new(:id, :rank, :title, :score, :comments)

submissions = document.css('tr.athing.submission').map do |submission|
  metadata = submission.next_sibling
  [submission, metadata]
end

submissions.map do |submission, metadata|
  id = submission.attribute('id').value
  rank = submission.css('span.rank').first.children.first.text.chomp('.').to_i
  title = submission.css('span.titleline').first.children.first.text

  score = metadata.css('span.score')
  score = score.empty? ? 0 : score.first.children.first.text.chomp(' points').to_i

  comments = metadata.css('a').at('a:contains("comments")')
  comments = comments.nil? ? 0 : comments.children.text.chomp(' comments').to_i

  entry = Entry.new(id, rank, title, score, comments)

  puts entry.title

  entry
end
