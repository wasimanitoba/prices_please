task scrape: [:environment] do
  Extract::WebScrapingPipeline.crawl!(Pipeline.last)
end
