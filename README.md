# 🗞️ Hacker News Scraper

A Ruby command line program that scrapes and filters Hacker News posts. Built with simplicity and maintainability in mind.

## 🛠️ Prerequisites

- Ruby 3.x
- Bundler

## 🚀 Getting Started

1. Clone the repository

2. Install dependencies:

```bash
bundle install
```

3. Run the program:

```bash
ruby main.rb
```

4. Play a few rounds.

5. Once you are done, all your filtering usage logs should have been saved in `usage_data.json`.

## 🧪 Running Tests

```bash
bundle exec ruby test/test_hacker_news_scraper.rb
```

## 🏗️ Design Decisions

### 1. Ruby Implementation

- I chose to implement the scraper in just Ruby without a UI to focus on backend functionality
- This aligns with my goal of growing my skills in backend development
- Makes the codebase simpler to maintain and test

### 2. Gems

- `httparty`: User friendly HTTP client
- `nokogiri`: Parser that makes easy to deal with XML and HTML documents
- `json`: For handling JSON data
- `minitest` and `mocha` for unit testing

## 3. Testing Strategy

- Unit tests for core functionality
- Mock external HTTP requests to ensure reliable testing
- Test coverage for edge cases and error handling
