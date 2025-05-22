# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require 'nokogiri'
require_relative '../lib/scraper'
require_relative '../lib/entry'

class TestScraper < Minitest::Test
  def setup
    @http_getter = mock
    @html_parser = mock
    @entry_parser = mock
    @scraper = Scraper.new(@http_getter, @html_parser, @entry_parser)
  end

  def test_fetch_entries_parses_and_returns_entries
    html_response = <<~HTML
      <html>
        <body>
          <tr class="athing submission" id="44057841">
            <td align="right" valign="top" class="title"><span class="rank">1.</span></td>
            <td valign="top" class="votelinks"><center><a id="up_44057841" href="vote?id=44057841&amp;how=up&amp;goto=news"><div class="votearrow" title="upvote"></div></a></center></td>
            <td class="title"><span class="titleline"><a href="https://example.com/first-post">First Post</a><span class="sitebit comhead"> (<a href="from?site=example.com"><span class="sitestr">example.com</span></a>)</span></span></td>
          </tr>
          <tr>
            <td colspan="2"></td>
            <td class="subtext"><span class="subline">
              <span class="score" id="score_44057841">100 points</span> by <a href="user?id=user1" class="hnuser">user1</a> <span class="age" title="2024-03-22T01:19:41"><a href="item?id=44057841">11 hours ago</a></span> <span id="unv_44057841"></span> | <a href="hide?id=44057841&amp;goto=news">hide</a> | <a href="item?id=44057841">50&nbsp;comments</a>
            </span></td>
          </tr>
          <tr class="athing submission" id="44057842">
            <td align="right" valign="top" class="title"><span class="rank">2.</span></td>
            <td valign="top" class="votelinks"><center><a id="up_44057842" href="vote?id=44057842&amp;how=up&amp;goto=news"><div class="votearrow" title="upvote"></div></a></center></td>
            <td class="title"><span class="titleline"><a href="https://example.com/second-post">Second Post</a><span class="sitebit comhead"> (<a href="from?site=example.com"><span class="sitestr">example.com</span></a>)</span></span></td>
          </tr>
          <tr>
            <td colspan="2"></td>
            <td class="subtext"><span class="subline">
              <span class="score" id="score_44057842">200 points</span> by <a href="user?id=user2" class="hnuser">user2</a> <span class="age" title="2024-03-22T02:19:41"><a href="item?id=44057842">10 hours ago</a></span> <span id="unv_44057842"></span> | <a href="hide?id=44057842&amp;goto=news">hide</a> | <a href="item?id=44057842">75&nbsp;comments</a>
            </span></td>
          </tr>
        </body>
      </html>
    HTML

    http_response = mock
    http_response.stubs(:body).returns(html_response)

    document = Nokogiri::HTML(html_response)
    submissions = document.css('tr.athing.submission')

    entry1 = Entry.new('44057841', 1, 'First Post', 100, 50)
    entry2 = Entry.new('44057842', 2, 'Second Post', 200, 75)

    @http_getter.expects(:get).with('https://news.ycombinator.com/').returns(http_response)
    @html_parser.expects(:parse).with(html_response).returns(document)

    @entry_parser.expects(:parse_entry).with(submissions[0], submissions[0].next_sibling).returns(entry1)
    @entry_parser.expects(:parse_entry).with(submissions[1], submissions[1].next_sibling).returns(entry2)

    entries = @scraper.fetch_entries

    assert_equal 2, entries.length
    assert_equal entry1, entries[0]
    assert_equal entry2, entries[1]
  end

  def test_fetch_entries_raises_error_when_no_entries_found
    html_response = '<html><body></body></html>'
    http_response = mock
    http_response.stubs(:body).returns(html_response)
    document = Nokogiri::HTML(html_response)

    @http_getter.expects(:get).with('https://news.ycombinator.com/').returns(http_response)
    @html_parser.expects(:parse).with(html_response).returns(document)

    error = assert_raises(RuntimeError) do
      @scraper.fetch_entries
    end

    assert_equal 'No entries found', error.message
  end
end
