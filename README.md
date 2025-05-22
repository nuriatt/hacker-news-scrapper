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

## 💭 Why I Built It This Way

### Backend Approach

I decided to build this project just in Ruby because it's the language I enjoy the most and the one I want to keep developing my skills in. This was a chance to focus on writing clean, well structured Ruby without relying on frameworks or a UI.

### Gems

- `httparty` for making HTTP requests, very user-friendly
- `nokogiri` to handle all the HTML parsing
- `json` for handling the data storage (keeping it simple with the standard library)
- `minitest` and `mocha` for unit testing

### Testing Strategy

- Write unit tests for all the core functionality
- Mock external HTTP requests (so tests are fast and reliable)
- Keep the test suite maintainable

The goal was to keep everything simple and maintainable. No fancy frameworks, no complex setup - just pure Ruby 💎
